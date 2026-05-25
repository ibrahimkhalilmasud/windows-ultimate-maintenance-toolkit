@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Windows Ultimate Maintenance Toolkit
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Central launcher dashboard for maintenance, repair, diagnostics,
REM              optimization, security, backup, and networking tools.
REM Usage: Run this file from an elevated command prompt or double click.
REM Warning: Run only validated operations for your environment and backup first.
REM Safety: Review menu choices and run only actions appropriate for your system.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Main_Toolkit" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

:menu
cls
call "%COMMON_LIB%" :Print INFO "Windows Ultimate Maintenance Toolkit - Dashboard"
call :ShowSystemInfo

echo.
echo ===================== CATEGORY MENU =====================
echo [1] Cleanup
echo [2] Repair
echo [3] Optimization
echo [4] Diagnostics
echo [5] Security
echo [6] Backup
echo [7] Network
echo [0] Exit
echo ==========================================================
set /p "CHOICE=Select a category: "

if "%CHOICE%"=="1" goto :category_cleanup
if "%CHOICE%"=="2" goto :category_repair
if "%CHOICE%"=="3" goto :category_optimization
if "%CHOICE%"=="4" goto :category_diagnostics
if "%CHOICE%"=="5" goto :category_security
if "%CHOICE%"=="6" goto :category_backup
if "%CHOICE%"=="7" goto :category_network
if "%CHOICE%"=="0" goto :safe_exit

call "%COMMON_LIB%" :Print WARN "Invalid selection. Please try again."
timeout /t 2 >nul
goto :menu

:ShowSystemInfo
for /f "tokens=2 delims=[]" %%v in ('ver') do set "WINVER=%%v"
for /f "tokens=* delims=" %%i in ('wmic os get Caption ^| findstr /r /v "^$" ^| findstr /v "Caption"') do set "OSNAME=%%i"
if not defined OSNAME set "OSNAME=Windows"
set "INTERNET=Disconnected"
ping 8.8.8.8 -n 1 >nul 2>&1 && set "INTERNET=Connected"
echo Hostname: %COMPUTERNAME%
echo User: %USERNAME%
echo OS: %OSNAME% %WINVER%
echo Architecture: %PROCESSOR_ARCHITECTURE%
echo Internet: %INTERNET%
exit /b 0

:category_cleanup
cls
echo ====================== CLEANUP =======================
echo [1] Clean_System_Trash
echo [2] Temp_Auto_Cleaner
echo [3] Event_Log_Cleaner
echo [0] Back
set /p "C=Select tool: "
if "%C%"=="1" call :RunTool "cleanup\Clean_System_Trash.bat"
if "%C%"=="2" call :RunTool "cleanup\Temp_Auto_Cleaner.bat"
if "%C%"=="3" call :RunTool "cleanup\Event_Log_Cleaner.bat"
if "%C%"=="0" goto :menu
goto :category_cleanup

:category_repair
cls
echo ======================= REPAIR =======================
echo [1] Windows_Update_Reset
echo [2] System_Repair_Toolkit
echo [3] Audio_Repair
echo [4] Bluetooth_Fix
echo [5] Explorer_Reset
echo [6] File_Association_Repair
echo [7] Sleep_Hibernate_Fix
echo [8] USB_Device_Reset
echo [0] Back
set /p "C=Select tool: "
if "%C%"=="1" call :RunTool "repair\Windows_Update_Reset.bat"
if "%C%"=="2" call :RunTool "repair\System_Repair_Toolkit.bat"
if "%C%"=="3" call :RunTool "repair\Audio_Repair.bat"
if "%C%"=="4" call :RunTool "repair\Bluetooth_Fix.bat"
if "%C%"=="5" call :RunTool "repair\Explorer_Reset.bat"
if "%C%"=="6" call :RunTool "repair\File_Association_Repair.bat"
if "%C%"=="7" call :RunTool "repair\Sleep_Hibernate_Fix.bat"
if "%C%"=="8" call :RunTool "repair\USB_Device_Reset.bat"
if "%C%"=="0" goto :menu
goto :category_repair

:category_optimization
cls
echo ==================== OPTIMIZATION ====================
echo [1] Ultimate_PC_Optimizer
echo [2] SSD_Optimizer
echo [3] HDD_Optimizer
echo [4] Startup_Manager
echo [5] Power_Plan_Optimizer
echo [0] Back
set /p "C=Select tool: "
if "%C%"=="1" call :RunTool "optimization\Ultimate_PC_Optimizer.bat"
if "%C%"=="2" call :RunTool "optimization\SSD_Optimizer.bat"
if "%C%"=="3" call :RunTool "optimization\HDD_Optimizer.bat"
if "%C%"=="4" call :RunTool "optimization\Startup_Manager.bat"
if "%C%"=="5" call :RunTool "optimization\Power_Plan_Optimizer.bat"
if "%C%"=="0" goto :menu
goto :category_optimization

:category_diagnostics
cls
echo ==================== DIAGNOSTICS =====================
echo [1] Full_PC_Diagnostics
echo [2] GPU_Diagnostics
echo [3] RAM_Diagnostics
echo [4] Disk_Health_Check
echo [5] BlueScreen_Diagnostics
echo [6] System_Info_Exporter
echo [7] Battery_Health_Report
echo [8] Internet_Diagnostics
echo [0] Back
set /p "C=Select tool: "
if "%C%"=="1" call :RunTool "diagnostics\Full_PC_Diagnostics.bat"
if "%C%"=="2" call :RunTool "diagnostics\GPU_Diagnostics.bat"
if "%C%"=="3" call :RunTool "diagnostics\RAM_Diagnostics.bat"
if "%C%"=="4" call :RunTool "diagnostics\Disk_Health_Check.bat"
if "%C%"=="5" call :RunTool "diagnostics\BlueScreen_Diagnostics.bat"
if "%C%"=="6" call :RunTool "diagnostics\System_Info_Exporter.bat"
if "%C%"=="7" call :RunTool "diagnostics\Battery_Health_Report.bat"
if "%C%"=="8" call :RunTool "diagnostics\Internet_Diagnostics.bat"
if "%C%"=="0" goto :menu
goto :category_diagnostics

:category_security
cls
echo ====================== SECURITY =======================
echo [1] Windows_Defender_Repair
echo [2] Windows_Security_Check
echo [3] Firewall_Reset
echo [4] Malware_Basic_Cleanup
echo [5] Admin_Privilege_Checker
echo [0] Back
set /p "C=Select tool: "
if "%C%"=="1" call :RunTool "security\Windows_Defender_Repair.bat"
if "%C%"=="2" call :RunTool "security\Windows_Security_Check.bat"
if "%C%"=="3" call :RunTool "security\Firewall_Reset.bat"
if "%C%"=="4" call :RunTool "security\Malware_Basic_Cleanup.bat"
if "%C%"=="5" call :RunTool "security\Admin_Privilege_Checker.bat"
if "%C%"=="0" goto :menu
goto :category_security

:category_backup
cls
echo ======================= BACKUP ========================
echo [1] Driver_Backup_Restore
echo [2] Registry_Backup
echo [3] Automatic_Backup
echo [0] Back
set /p "C=Select tool: "
if "%C%"=="1" call :RunTool "backup\Driver_Backup_Restore.bat"
if "%C%"=="2" call :RunTool "backup\Registry_Backup.bat"
if "%C%"=="3" call :RunTool "backup\Automatic_Backup.bat"
if "%C%"=="0" goto :menu
goto :category_backup

:category_network
cls
echo ======================= NETWORK =======================
echo [1] DNS_Reset_Repair
echo [2] Internet_Reset_Complete
echo [3] WiFi_Fix_Repair
echo [4] Proxy_Remover
echo [5] Network_Speed_Optimizer
echo [0] Back
set /p "C=Select tool: "
if "%C%"=="1" call :RunTool "network\DNS_Reset_Repair.bat"
if "%C%"=="2" call :RunTool "network\Internet_Reset_Complete.bat"
if "%C%"=="3" call :RunTool "network\WiFi_Fix_Repair.bat"
if "%C%"=="4" call :RunTool "network\Proxy_Remover.bat"
if "%C%"=="5" call :RunTool "network\Network_Speed_Optimizer.bat"
if "%C%"=="0" goto :menu
goto :category_network

:RunTool
set "TARGET=%TOOLKIT_ROOT%\%~1"
set "TOOL_PATH=%~1"
if not exist "%TARGET%" (
  call "%COMMON_LIB%" :Print ERROR "Tool not found: %TARGET%"
  timeout /t 2 >nul
  exit /b 1
)
set "TOOL_DESC="
for /f "tokens=1* delims=:" %%A in ('findstr /b /c:"REM Description:" "%TARGET%" 2^>nul') do set "TOOL_DESC=%%B"
if defined TOOL_DESC for /f "tokens=* delims= " %%D in ("!TOOL_DESC!") do set "TOOL_DESC=%%D"
echo.
echo ================= EXECUTION CONFIRMATION =================
echo Tool: !TOOL_PATH!
if defined TOOL_DESC (
  echo Purpose: !TOOL_DESC!
) else (
  echo Purpose: Runs the selected maintenance operation.
)
choice /c YN /n /m "Continue? [Y]es / [N]o: "
if errorlevel 2 (
  call "%COMMON_LIB%" :Print WARN "Cancelled !TOOL_PATH! by user choice."
  exit /b 0
)
call "%COMMON_LIB%" :Print INFO "Launching !TOOL_PATH!"
call "%TARGET%"
exit /b 0

:safe_exit
call "%COMMON_LIB%" :Print INFO "Exiting safely."
call "%COMMON_LIB%" :Finalize 0
endlocal
exit /b 0
