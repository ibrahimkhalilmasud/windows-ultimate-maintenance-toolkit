@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Automatic_Backup
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Creates timestamped user-profile backup using robust copy settings.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Automatic_Backup" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Automatic_Backup"

set "DEST=%REPORT_DIR%\AutoBackup_%RUN_ID%"
mkdir "%DEST%" >nul 2>&1
robocopy "%USERPROFILE%" "%DEST%" Documents Desktop Downloads /E /R:1 /W:1 >> "%LOG_FILE%" 2>&1
set "RB_CODE=%errorlevel%"
if %RB_CODE% LEQ 3 (set "RB_CODE=0")
call "%COMMON_LIB%" :RecordResult "Run automatic profile backup" %RB_CODE%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
