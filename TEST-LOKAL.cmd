@echo off
REM Startet beide Seiten lokal als echten Webserver.
REM TMS-Web-Core-Apps laufen NICHT per Doppelklick (file:///) - Chrome blockiert das.

start "ftmanager.de (8099)" /min python -m http.server 8099 --directory "%~dp0_deploy_ftmanager"
start "rwwertec.de (8098)"  /min python -m http.server 8098 --directory "%~dp0_deploy_rwwertec"

ping -n 3 127.0.0.1 >nul

start "" http://localhost:8099/
start "" http://localhost:8098/

echo.
echo   ftmanager.de  ---^>  http://localhost:8099/
echo   rwwertec.de   ---^>  http://localhost:8098/
echo.
echo   Zum Beenden: die beiden minimierten Server-Fenster schliessen.
echo.
pause
