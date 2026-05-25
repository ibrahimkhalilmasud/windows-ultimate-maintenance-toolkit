@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Event_Log_Cleaner
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Clears Windows event logs after export for troubleshooting hygiene.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Event_Log_Cleaner" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Event_Log_Cleaner"

set "EXPORT=%REPORT_DIR%\EventLog_Backup_%RUN_ID%.evtx"
wevtutil epl Application "%EXPORT%" >> "%LOG_FILE%" 2>&1
wevtutil cl Application >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Clear Application log" %errorlevel%
wevtutil cl System >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Clear System log" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
