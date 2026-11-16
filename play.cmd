@echo off
rem Front Row Seat: opens the theater in your browser at http://localhost:8765/
rem Close this window to stop it. Another port: play.cmd 8766
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1" %*
