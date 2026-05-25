@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Network_Speed_Optimizer
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Applies safe network tuning defaults for reliable throughput.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Network_Speed_Optimizer" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Network_Speed_Optimizer"

netsh interface tcp set global autotuninglevel=normal >> "%LOG_FILE%" 2>&1
netsh interface tcp set global chimney=enabled >> "%LOG_FILE%" 2>&1
netsh interface tcp set global rss=enabled >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Apply TCP optimizations" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
