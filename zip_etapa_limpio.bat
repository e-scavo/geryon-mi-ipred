@echo off
setlocal

if "%~1"=="" (
    echo Uso: zip_etapa_limpio.bat 6.3
    exit /b 1
)

set "ETAPA=%~1"
set "PROJECT_DIR=%cd%"
set "OUTPUT_FILE=%cd%\..\geryon-mi-ipred-%ETAPA%.zip"
set "TEMP_DIR=%temp%\geryon_mi_ipred_zip_%random%%random%"

echo.
echo Preparando copia temporal...
mkdir "%TEMP_DIR%"

robocopy "%PROJECT_DIR%" "%TEMP_DIR%" /E /XD .git .dart_tool build .idea .vscode >nul

if errorlevel 8 (
    echo ERROR: fallo robocopy.
    rmdir /s /q "%TEMP_DIR%"
    exit /b 1
)

if exist "%OUTPUT_FILE%" del /f /q "%OUTPUT_FILE%"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Compress-Archive -Path '%TEMP_DIR%\*' -DestinationPath '%OUTPUT_FILE%' -Force"

if errorlevel 1 (
    echo ERROR: no se pudo generar el zip.
    rmdir /s /q "%TEMP_DIR%"
    exit /b 1
)

rmdir /s /q "%TEMP_DIR%"

echo.
echo ZIP generado correctamente:
echo %OUTPUT_FILE%
echo.

endlocal