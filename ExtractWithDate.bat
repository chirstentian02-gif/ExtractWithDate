@echo off
rem Drag one or more archives onto this file (multiple files supported)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0ExtractWithDate.ps1" %*
