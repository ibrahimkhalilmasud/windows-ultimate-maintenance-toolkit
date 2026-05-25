@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Windows_Update_Reset
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Resets Windows Update components with service safeguards.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Windows_Update_Reset" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Windows_Update_Reset"

net stop wuauserv >> "%LOG_FILE%" 2>&1
net stop bits >> "%LOG_FILE%" 2>&1
ren "%SystemRoot%\SoftwareDistribution" SoftwareDistribution.bak_%RUN_ID% >> "%LOG_FILE%" 2>&1
net start bits >> "%LOG_FILE%" 2>&1
net start wuauserv >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Reset Windows Update components" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
