@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM RAM_Diagnostics
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Captures memory inventory and launches memory diagnostics utility.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "RAM_Diagnostics" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting RAM_Diagnostics"

set "RPT_TXT=%REPORT_DIR%\RAM_Diagnostics_%RUN_ID%.txt"
wmic memorychip get BankLabel,Capacity,ConfiguredClockSpeed,Manufacturer > "%RPT_TXT%" 2>> "%LOG_FILE%" & call "%COMMON_LIB%" :RecordResult "Export RAM inventory" %errorlevel%
start mdsched.exe >> "%LOG_FILE%" 2>&1

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
