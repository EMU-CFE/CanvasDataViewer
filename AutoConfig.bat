@echo off
set /p configdir= Node.js Path: 
set /p APIK= Canvas Data API Key: 
set /p APIS= Canvas Data API Secret: 
set /p cdsvr= Server Name:
set /p cdusr= Server User:
set /p cdpw= Server USR PW:
powershell -ExecutionPolicy ByPass -File "%configdir%"/AutoConfig.ps1 "%configdir%" "%APIK%" "%APIS%" "%cdsvr%" "%cdusr%" "%cdpw%"
pause
cd "%configdir%" 
ren *.cdconfig *.js