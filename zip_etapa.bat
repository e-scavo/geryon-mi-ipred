@echo off
setlocal

if "%~1"=="" (
    echo Uso: zip_etapa.bat 6.3
    exit /b 1
)

set "ETAPA=%~1"
set "PROJECT_DIR=%cd%"
set "PROJECT_NAME=%~nxcd%"
set "OUTPUT_FILE=%cd%\..\geryon-mi-ipred-%ETAPA%.zip"

echo.
echo ========================================
echo Proyecto : %PROJECT_NAME%
echo Etapa    : %ETAPA%
echo Origen   : %PROJECT_DIR%
echo Destino  : %OUTPUT_FILE%
echo ========================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$src = '%PROJECT_DIR%';" ^
    "$dst = '%OUTPUT_FILE%';" ^
    "if (Test-Path $dst) { Remove-Item $dst -Force };" ^
    "Compress-Archive -Path (Join-Path $src '*') -DestinationPath $dst -Force"

if errorlevel 1 (
    echo.
    echo ERROR: no se pudo generar el zip.
    exit /b 1
)

echo.
echo ZIP generado correctamente:
echo %OUTPUT_FILE%
echo.

endlocal