@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Internet_Diagnostics
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Checks internet reachability, DNS resolution, and gateway routing.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Internet_Diagnostics" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Internet_Diagnostics"

set "RPT_TXT=%REPORT_DIR%\Internet_Diagnostics_%RUN_ID%.txt"
(
  ping 8.8.8.8 -n 4
  nslookup github.com
  tracert -d 8.8.8.8
) > "%RPT_TXT%" 2>> "%LOG_FILE%" & call "%COMMON_LIB%" :RecordResult "Run internet diagnostics" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
