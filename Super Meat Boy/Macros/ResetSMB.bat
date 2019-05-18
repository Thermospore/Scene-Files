@echo off

set /P id=Enter command: 

if "%id%"=="" (
	xcopy "%~dp0fresh\1" "C:\Program Files (x86)\Steam\steamapps\common\Super Meat Boy\UserData" /v /y /z
) else (
	xcopy "%~dp0fresh\%id%" "C:\Program Files (x86)\Steam\steamapps\common\Super Meat Boy\UserData" /v /y /z
)

start steam://rungameid/40800
timeout 4
wmic process where name="SuperMeatBoy.exe" CALL setpriority "realtime"