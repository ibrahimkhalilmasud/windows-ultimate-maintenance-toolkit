@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Temp_Auto_Cleaner
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Automatically removes stale temporary files older than one day.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Temp_Auto_Cleaner" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Temp_Auto_Cleaner"

forfiles /p "%TEMP%" /s /m * /d -1 /c "cmd /c del /q @path" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Purge old user temp files" %errorlevel%
forfiles /p "%SystemRoot%\Temp" /s /m * /d -1 /c "cmd /c del /q @path" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Purge old system temp files" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
