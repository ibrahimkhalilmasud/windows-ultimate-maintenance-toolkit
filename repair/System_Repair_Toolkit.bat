@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM System_Repair_Toolkit
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Runs DISM and SFC health validation and repair commands.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "System_Repair_Toolkit" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting System_Repair_Toolkit"

DISM /Online /Cleanup-Image /RestoreHealth >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "DISM restore health" %errorlevel%
sfc /scannow >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "SFC scan" %errorlevel%
chkdsk C: /scan >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "CHKDSK online scan" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
