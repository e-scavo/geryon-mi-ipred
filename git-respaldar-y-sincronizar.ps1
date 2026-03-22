#Requires -Version 5
Param(
  [string]$Remote = "origin",
  [int]$UpdateSubmodules = 1
)

$ErrorActionPreference = "Stop"

function Exec {
  param(
    [Parameter(Mandatory=$true)][string]$cmd,
    [string]$errMsg = "Comando falló.",
    [switch]$AllowFailure
  )
  $pinfo = New-Object System.Diagnostics.ProcessStartInfo
  $pinfo.FileName = "cmd.exe"
  $pinfo.Arguments = "/c $cmd"
  $pinfo.RedirectStandardError = $true
  $pinfo.RedirectStandardOutput = $true
  $pinfo.UseShellExecute = $false
  $p = New-Object System.Diagnostics.Process
  $p.StartInfo = $pinfo
  $p.Start() | Out-Null
  $stdout = $p.StandardOutput.ReadToEnd()
  $stderr = $p.StandardError.ReadToEnd()
  $p.WaitForExit()
  if ($p.ExitCode -ne 0 -and -not $AllowFailure) {
    Write-Host $stdout
    Write-Error "$errMsg`n$stderr"
  }
  return $stdout.Trim()
}

# Verificar repo
Exec "git rev-parse --is-inside-work-tree" "No estás dentro de un repositorio Git."

# Traer refs
Exec "git fetch $Remote --prune" "Fallo git fetch."

# Detectar rama principal del remoto con 'git remote show'
$remoteShow = Exec "git remote show $Remote" "Fallo 'git remote show'."
$headLine = ($remoteShow -split "`r?`n") | Where-Object { $_ -match 'HEAD branch:' } | Select-Object -First 1
if ($headLine) {
  $MainBranch = ($headLine -replace '.*HEAD branch:\s*','').Trim()
} else {
  # Fallback si no hay HEAD definido
  $hasMain   = Exec "git ls-remote --exit-code --heads $Remote main" "" -AllowFailure
  $hasMaster = Exec "git ls-remote --exit-code --heads $Remote master" "" -AllowFailure
  if (-not [string]::IsNullOrWhiteSpace($hasMain)) {
    $MainBranch = "main"
  } elseif (-not [string]::IsNullOrWhiteSpace($hasMaster)) {
    $MainBranch = "master"
  } else {
    throw "No pude detectar la rama principal en $Remote (ni main ni master)."
  }
}

Write-Host "Remoto: $Remote"
Write-Host "Rama principal detectada: $MainBranch"

# Armar nombres backup
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupBranch = "backup/casa-$stamp"
$tagName = "backup-casa-$stamp"

# Crear rama de backup desde el estado actual
Write-Host "Creando rama de backup: $backupBranch"
Exec "git switch -c $backupBranch" "No se pudo crear la rama $backupBranch."

# Incluir todo (también no trackeados)
Exec "git add -A" "git add falló."
$hasStaged = (Exec "git diff --cached --name-only" "") -ne ""
if ($hasStaged) {
  Exec "git commit -m `"backup: snapshot PC de casa antes de sincronizar ($stamp)`"" "git commit falló."
} else {
  Write-Host "No hay cambios para commitear; se respalda el commit actual igualmente."
}

# Subir backup
Write-Host "Enviando rama de backup a $Remote/$backupBranch"
Exec "git push -u $Remote $backupBranch" "git push de rama de backup falló."

# Tag
Write-Host "Creando tag: $tagName"
Exec "git tag -a $tagName -m `"Backup PC de casa antes de sincronizar ($stamp)`"" "git tag falló."
Exec "git push $Remote $tagName" "git push del tag falló."

# Sincronizar rama principal: dejar igual al remoto
Write-Host "Sincronizando rama principal: $MainBranch"
# Si no existe local, crear desde remoto
$existsLocal = (Exec "git show-ref --verify --quiet refs/heads/$MainBranch 2>nul & echo %errorlevel%" "") -eq "0"
if (-not $existsLocal) {
  Exec "git switch -c $MainBranch $Remote/$MainBranch" "No se pudo crear la rama local $MainBranch."
} else {
  Exec "git switch $MainBranch" "No se pudo cambiar a $MainBranch."
  Exec "git fetch $Remote --prune" "Fallo git fetch final."
  Exec "git reset --hard $Remote/$MainBranch" "git reset --hard falló."
}

if ($UpdateSubmodules -eq 1) {
  Write-Host "Actualizando submódulos (si existen)…"
  try {
    Exec "git submodule update --init --recursive" "git submodule update falló."
  } catch {
    Write-Host "Sin submódulos o actualización no necesaria."
  }
}

Write-Host "Listo. Backup en rama '$backupBranch' y tag '$tagName'."
Write-Host "Tu árbol local ahora es idéntico a '$Remote/$MainBranch'."
