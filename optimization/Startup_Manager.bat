@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Startup_Manager
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Opens startup management interfaces for controlled boot tuning.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Startup_Manager" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Startup_Manager"

wmic startup get Caption,Command >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Export startup entries" %errorlevel%
start ms-settings:startupapps >> "%LOG_FILE%" 2>&1

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
