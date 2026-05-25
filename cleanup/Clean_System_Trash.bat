@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Clean_System_Trash
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Safely cleans common user and system temporary files.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Clean_System_Trash" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Clean_System_Trash"

if exist "%TEMP%" del /q /f /s "%TEMP%\*" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Clear user temp" %errorlevel%
if exist "%SystemRoot%\Temp" del /q /f /s "%SystemRoot%\Temp\*" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Clear system temp" %errorlevel%
cleanmgr /sagerun:1 >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Run disk cleanup profile" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
