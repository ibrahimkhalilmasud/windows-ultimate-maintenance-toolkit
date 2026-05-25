@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Windows_Defender_Repair
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Repairs Defender service state and update signatures.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Windows_Defender_Repair" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Windows_Defender_Repair"

sc start WinDefend >> "%LOG_FILE%" 2>&1
powershell -NoProfile -Command "Update-MpSignature" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Update Defender signatures" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
