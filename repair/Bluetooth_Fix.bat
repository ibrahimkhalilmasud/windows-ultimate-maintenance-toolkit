@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Bluetooth_Fix
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Restarts Bluetooth support services and reinitializes stack.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Bluetooth_Fix" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Bluetooth_Fix"

net stop bthserv >> "%LOG_FILE%" 2>&1
net start bthserv >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Restart Bluetooth service" %errorlevel%
sc query bthserv >> "%LOG_FILE%" 2>&1

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
