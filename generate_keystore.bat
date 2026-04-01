@echo off
setlocal

echo ============================================
echo Generando keystore Android (Mi IP·RED)
echo ============================================

REM Crear carpeta si no existe
if not exist keys (
    mkdir keys
)

REM Variables
set STORE_PATH=keys\mi-ipred-release.jks
set STORE_PASS="geryon1325!?!?"
set KEY_PASS="geryon1325!?!?"
set KEY_ALIAS=mi-ipred-release

echo.
echo Generando keystore en %STORE_PATH%
echo.

keytool -genkeypair ^
 -v ^
 -keystore %STORE_PATH% ^
 -storepass %STORE_PASS% ^
 -keypass %KEY_PASS% ^
 -alias %KEY_ALIAS% ^
 -keyalg RSA ^
 -keysize 2048 ^
 -validity 10000 ^
 -dname "CN=Mi IP RED, OU=IT, O=SCAVO Technologies, L=Rosario, S=Santa Fe, C=AR"

echo.
echo ============================================
echo Keystore generado correctamente
echo ============================================

pause