@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Ultimate_PC_Optimizer
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Runs safe optimization bundle for temporary files and maintenance.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Ultimate_PC_Optimizer" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Ultimate_PC_Optimizer"

cleanmgr /sagerun:1 >> "%LOG_FILE%" 2>&1
defrag C: /L >> "%LOG_FILE%" 2>&1
powercfg /setactive SCHEME_BALANCED >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Apply balanced optimization profile" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
