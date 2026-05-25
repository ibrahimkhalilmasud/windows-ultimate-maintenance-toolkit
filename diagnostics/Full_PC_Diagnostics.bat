@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Full_PC_Diagnostics
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Generates full diagnostics snapshot including hardware, network, and security.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Full_PC_Diagnostics" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Full_PC_Diagnostics"

set "RPT_TXT=%REPORT_DIR%\Full_PC_Diagnostics_%RUN_ID%.txt"
(
  echo ==== FULL PC DIAGNOSTICS ====
  systeminfo
  ipconfig /all
  wmic diskdrive get model,status,size
  wmic path SoftwareLicensingProduct where "PartialProductKey is not null" get Name,LicenseStatus
) > "%RPT_TXT%" 2>> "%LOG_FILE%"
powershell -NoProfile -Command "Get-ComputerInfo | ConvertTo-Html -Title 'Full PC Diagnostics' | Out-File '%REPORT_DIR%\Full_PC_Diagnostics_%RUN_ID%.html'" >> "%LOG_FILE%" 2>&1 & call "%COMMON_LIB%" :RecordResult "Generate diagnostics reports" %errorlevel%

set "EXIT_CODE=0"
if errorlevel 1 set "EXIT_CODE=1"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
