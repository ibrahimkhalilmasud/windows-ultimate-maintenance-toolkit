@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM DNS_Reset_Repair
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Resets DNS resolver and renews network registration safely.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "DNS_Reset_Repair" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting DNS_Reset_Repair"

ipconfig /flushdns >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Flush DNS" %errorlevel%
ipconfig /registerdns >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Register DNS" %errorlevel%
ipconfig /release >> "%LOG_FILE%" 2>&1
ipconfig /renew >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Renew DHCP lease" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
