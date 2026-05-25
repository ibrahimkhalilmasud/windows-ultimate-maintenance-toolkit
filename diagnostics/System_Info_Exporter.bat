@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM System_Info_Exporter
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Exports detailed system profile to TXT and HTML formats.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "System_Info_Exporter" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting System_Info_Exporter"

set "RPT_TXT=%REPORT_DIR%\System_Info_%RUN_ID%.txt"
systeminfo > "%RPT_TXT%" 2>> "%LOG_FILE%"
powershell -NoProfile -Command "Get-ComputerInfo | ConvertTo-Html -Title 'System Information' | Out-File '%REPORT_DIR%\System_Info_%RUN_ID%.html'" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Export system information" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
