@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Windows_Security_Check
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Validates firewall, Defender, and UAC baseline status.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Windows_Security_Check" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Windows_Security_Check"

set "RPT_TXT=%REPORT_DIR%\Windows_Security_Check_%RUN_ID%.txt"
(
  powershell -NoProfile -Command "Get-MpComputerStatus"
  netsh advfirewall show allprofiles
  reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA
) > "%RPT_TXT%" 2>> "%LOG_FILE%" & call "%COMMON_LIB%" :RecordResult "Export security baseline report" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
