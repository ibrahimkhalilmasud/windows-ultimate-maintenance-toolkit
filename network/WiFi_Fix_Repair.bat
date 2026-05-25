@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM WiFi_Fix_Repair
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Refreshes WLAN stack and reconnect logic for wireless recovery.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "WiFi_Fix_Repair" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting WiFi_Fix_Repair"

netsh wlan show interfaces >> "%LOG_FILE%" 2>&1
netsh wlan delete profile name=* i=* >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Clear Wi-Fi profiles" %errorlevel%
netsh int ip reset >> "%LOG_FILE%" 2>&1

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
