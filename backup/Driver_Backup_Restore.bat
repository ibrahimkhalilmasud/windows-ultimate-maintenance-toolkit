@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Driver_Backup_Restore
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Backs up installed third-party drivers for recovery.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Driver_Backup_Restore" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Driver_Backup_Restore"

set "DRV_BKP=%REPORT_DIR%\DriverBackup_%RUN_ID%"
mkdir "%DRV_BKP%" >nul 2>&1
dism /online /export-driver /destination:"%DRV_BKP%" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Export drivers" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
