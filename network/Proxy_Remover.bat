@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Proxy_Remover
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Removes WinHTTP and user proxy settings when misconfigured.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Proxy_Remover" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Proxy_Remover"

netsh winhttp reset proxy >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Reset WinHTTP proxy" %errorlevel%
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Disable user proxy" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
