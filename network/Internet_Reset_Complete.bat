@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Internet_Reset_Complete
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Performs full safe internet stack reset and socket repair.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Internet_Reset_Complete" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Internet_Reset_Complete"

netsh winsock reset >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Reset Winsock" %errorlevel%
netsh int ip reset >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Reset TCP/IP stack" %errorlevel%
ipconfig /flushdns >> "%LOG_FILE%" 2>&1

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
