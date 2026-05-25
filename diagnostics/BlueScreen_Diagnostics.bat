@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM BlueScreen_Diagnostics
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Collects bugcheck events and minidump inventory.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "BlueScreen_Diagnostics" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting BlueScreen_Diagnostics"

set "RPT_TXT=%REPORT_DIR%\BlueScreen_Diagnostics_%RUN_ID%.txt"
(
  wevtutil qe System /q:"*[System[(EventID=1001)]]" /f:text /c:20
  dir %SystemRoot%\Minidump
) > "%RPT_TXT%" 2>> "%LOG_FILE%" & call "%COMMON_LIB%" :RecordResult "Collect BSOD diagnostics" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
