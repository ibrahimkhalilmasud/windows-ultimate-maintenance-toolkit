@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Battery_Health_Report
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Generates battery report when battery hardware exists.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Battery_Health_Report" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Battery_Health_Report"

wmic path Win32_Battery get BatteryStatus >nul 2>&1
if errorlevel 1 (
  call "%COMMON_LIB%" :Print WARN "No battery detected. Skipping battery report."
) else (
  powercfg /batteryreport /output "%REPORT_DIR%\Battery_Report_%RUN_ID%.html" >> "%LOG_FILE%" 2>&1
  call "%COMMON_LIB%" :RecordResult "Generate battery health report" %errorlevel%
)

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
