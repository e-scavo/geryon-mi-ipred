#!/usr/bin/env bash
set -euo pipefail

REMOTE="${1:-origin}"
# Detectar rama principal del remoto (main/master)
MAIN_REF="$(git symbolic-ref -q --short refs/remotes/$REMOTE/HEAD || true)"
if [[ -z "$MAIN_REF" ]]; then
  # Fallback si no hay HEAD remoto configurado
  if git ls-remote --exit-code --heads "$REMOTE" main >/dev/null 2>&1; then
    MAIN_BRANCH="main"
  elif git ls-remote --exit-code --heads "$REMOTE" master >/dev/null 2>&1; then
    MAIN_BRANCH="master"
  else
    echo "❌ No pude detectar la rama principal en $REMOTE (ni main ni master)."
    exit 1
  fi
else
  MAIN_BRANCH="${MAIN_REF#"$REMOTE/"}"
fi

echo "🔎 Remoto: $REMOTE"
echo "🔎 Rama principal detectada: $MAIN_BRANCH"

# Asegurar que estamos en un repo git
git rev-parse --is-inside-work-tree >/dev/null

# Traer refs del remoto
git fetch "$REMOTE" --prune

# Armar nombres de backup
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_BRANCH="backup/casa-$STAMP"
TAG_NAME="backup-casa-$STAMP"

# Crear rama de backup desde el estado actual (incluye cambios sin commitear)
echo "🧷 Creando rama de backup: $BACKUP_BRANCH"
git switch -c "$BACKUP_BRANCH"

# Añadir TODO (también no trackeados)
git add -A || true

# Hacer commit sólo si hay cambios; si no, igual empujamos la rama apuntando al commit actual
if ! git diff --cached --quiet; then
  git commit -m "backup: snapshot PC de casa antes de sincronizar ($STAMP)"
else
  echo "ℹ️ No hay cambios para commitear; se respalda el commit actual igualmente."
fi

# Subir backup al remoto
echo "⬆️  Enviando rama de backup a $REMOTE/$BACKUP_BRANCH"
git push -u "$REMOTE" "$BACKUP_BRANCH"

# Crear y subir tag del backup (apunta al HEAD actual de backup)
echo "🏷️  Creando tag: $TAG_NAME"
git tag -a "$TAG_NAME" -m "Backup PC de casa antes de sincronizar ($STAMP)"
git push "$REMOTE" "$TAG_NAME"

# Dejar el repo idéntico al remoto en la rama principal
echo "🔁 Sincronizando rama principal: $MAIN_BRANCH"
# Si la rama no existe localmente, crearla desde el remoto
if ! git show-ref --verify --quiet "refs/heads/$MAIN_BRANCH"; then
  git switch -c "$MAIN_BRANCH" "$REMOTE/$MAIN_BRANCH"
else
  git switch "$MAIN_BRANCH"
  git fetch "$REMOTE" --prune
  git reset --hard "$REMOTE/$MAIN_BRANCH"
fi

# (Opcional) Actualizar submódulos
if [[ "${UPDATE_SUBMODULES:-1}" == "1" ]]; then
  echo "📦 Actualizando submódulos (si existen)…"
  git submodule update --init --recursive || true
fi

echo "✅ Listo. Backup en rama '$BACKUP_BRANCH' y tag '$TAG_NAME'."
echo "✅ Tu árbol local ahora es idéntico a '$REMOTE/$MAIN_BRANCH'."
