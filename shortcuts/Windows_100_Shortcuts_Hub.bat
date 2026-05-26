@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Windows_100_Shortcuts_Hub
REM Version: 1.0.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Launches 100 built-in Windows shortcut utilities from one menu.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Launches system tools and settings pages; no destructive actions.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Windows_100_Shortcuts_Hub" "1.0.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Windows_100_Shortcuts_Hub"
call :LoadShortcuts

:menu
cls
echo ================= WINDOWS 100 SHORTCUTS HUB =================
echo Enter a number from 1-100 to open a shortcut tool.
echo Enter 0 to return.
echo.
for /l %%I in (1,1,100) do (
  for /f "tokens=1* delims=|" %%A in ("!SHORTCUT_%%I!") do (
    set "PAD=   %%I"
    echo [!PAD:~-3!] %%A
  )
)
echo.
set "SEL="
set /p "SEL=Select shortcut: "

if "%SEL%"=="0" goto :done
REM findstr treats space-separated patterns as OR: ^[1-9][0-9]?$ (1-99) OR ^100$.
echo(%SEL%| findstr /r "^[1-9][0-9]?$ ^100$" >nul || goto :invalid
set /a "NUM=%SEL%+0"

call :LaunchShortcut %NUM%
echo.
pause
goto :menu

:invalid
call "%COMMON_LIB%" :Print WARN "Invalid selection. Choose 1-100 or 0."
timeout /t 2 >nul
goto :menu

:LaunchShortcut
set "ENTRY=!SHORTCUT_%~1!"
if not defined ENTRY (
  call "%COMMON_LIB%" :Print ERROR "Shortcut %~1 is not configured."
  exit /b 1
)
for /f "tokens=1* delims=|" %%A in ("!ENTRY!") do (
  set "SC_NAME=%%A"
  set "SC_CMD=%%B"
)
call "%COMMON_LIB%" :Print INFO "Opening !SC_NAME!"
REM Security assumption: SC_CMD values are trusted and hardcoded in :LoadShortcuts.
if not "!SC_CMD:&=!"=="!SC_CMD!" goto :unsafe_shortcut
if not "!SC_CMD:|=!"=="!SC_CMD!" goto :unsafe_shortcut
if not "!SC_CMD:<=!"=="!SC_CMD!" goto :unsafe_shortcut
if not "!SC_CMD:>=!"=="!SC_CMD!" goto :unsafe_shortcut
powershell -NoProfile -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','!SC_CMD!'" >nul 2>&1
call "%COMMON_LIB%" :Print INFO "Launch command issued for !SC_NAME!."
exit /b 0

:unsafe_shortcut
  call "%COMMON_LIB%" :Print ERROR "Unsafe shortcut command blocked for !SC_NAME!."
exit /b 1

:LoadShortcuts
set "SHORTCUT_1=Task Manager|taskmgr"
set "SHORTCUT_2=Registry Editor|regedit"
set "SHORTCUT_3=System Configuration|msconfig"
set "SHORTCUT_4=Services|services.msc"
set "SHORTCUT_5=Device Manager|devmgmt.msc"
set "SHORTCUT_6=Disk Management|diskmgmt.msc"
set "SHORTCUT_7=Computer Management|compmgmt.msc"
set "SHORTCUT_8=Event Viewer|eventvwr.msc"
set "SHORTCUT_9=Resource Monitor|resmon"
set "SHORTCUT_10=Performance Monitor|perfmon"
set "SHORTCUT_11=Reliability Monitor|perfmon /rel"
set "SHORTCUT_12=Local Users and Groups|lusrmgr.msc"
set "SHORTCUT_13=Shared Folders|fsmgmt.msc"
set "SHORTCUT_14=Group Policy Editor|gpedit.msc"
set "SHORTCUT_15=Local Security Policy|secpol.msc"
set "SHORTCUT_16=Windows Defender Firewall|wf.msc"
set "SHORTCUT_17=Certificate Manager|certmgr.msc"
set "SHORTCUT_18=Component Services|dcomcnfg"
set "SHORTCUT_19=System Properties|sysdm.cpl"
set "SHORTCUT_20=Programs and Features|appwiz.cpl"
set "SHORTCUT_21=Power Options|powercfg.cpl"
set "SHORTCUT_22=Network Connections|ncpa.cpl"
set "SHORTCUT_23=Internet Options|inetcpl.cpl"
set "SHORTCUT_24=Date and Time|timedate.cpl"
set "SHORTCUT_25=Region Settings|intl.cpl"
set "SHORTCUT_26=Sound|mmsys.cpl"
set "SHORTCUT_27=Mouse Properties|main.cpl"
set "SHORTCUT_28=Keyboard Properties|control keyboard"
set "SHORTCUT_29=System Information|msinfo32"
set "SHORTCUT_30=DirectX Diagnostic Tool|dxdiag"
set "SHORTCUT_31=Disk Cleanup|cleanmgr"
set "SHORTCUT_32=Character Map|charmap"
set "SHORTCUT_33=On-Screen Keyboard|osk"
set "SHORTCUT_34=Magnifier|magnify"
set "SHORTCUT_35=Narrator|narrator"
set "SHORTCUT_36=Snipping Tool|snippingtool"
set "SHORTCUT_37=Steps Recorder|psr"
set "SHORTCUT_38=Remote Desktop Connection|mstsc"
set "SHORTCUT_39=Windows Memory Diagnostic|mdsched"
set "SHORTCUT_40=System Restore|rstrui"
set "SHORTCUT_41=Windows Version|winver"
set "SHORTCUT_42=Control Panel|control"
set "SHORTCUT_43=Fonts|control fonts"
set "SHORTCUT_44=User Accounts|control userpasswords2"
set "SHORTCUT_45=Credential Manager|control /name Microsoft.CredentialManager"
set "SHORTCUT_46=Backup and Restore|control /name Microsoft.BackupAndRestore"
set "SHORTCUT_47=BitLocker Drive Encryption|control /name Microsoft.BitLockerDriveEncryption"
set "SHORTCUT_48=Troubleshooting|control /name Microsoft.Troubleshooting"
set "SHORTCUT_49=Default Programs|control /name Microsoft.DefaultPrograms"
set "SHORTCUT_50=Devices and Printers|control printers"
set "SHORTCUT_51=Administrative Tools|control admintools"
set "SHORTCUT_52=Indexing Options|control /name Microsoft.IndexingOptions"
set "SHORTCUT_53=Storage Spaces|control /name Microsoft.StorageSpaces"
set "SHORTCUT_54=Windows Tools|control /name Microsoft.AdministrativeTools"
set "SHORTCUT_55=Network and Sharing Center|control /name Microsoft.NetworkAndSharingCenter"
set "SHORTCUT_56=File Explorer|explorer"
set "SHORTCUT_57=This PC|explorer shell:MyComputerFolder"
set "SHORTCUT_58=Startup Folder (Current User)|explorer shell:startup"
set "SHORTCUT_59=Startup Folder (All Users)|explorer shell:common startup"
set "SHORTCUT_60=Downloads Folder|explorer shell:Downloads"
set "SHORTCUT_61=Documents Folder|explorer shell:Personal"
set "SHORTCUT_62=Pictures Folder|explorer shell:My Pictures"
set "SHORTCUT_63=Videos Folder|explorer shell:My Video"
set "SHORTCUT_64=Music Folder|explorer shell:My Music"
set "SHORTCUT_65=Recycle Bin|explorer shell:RecycleBinFolder"
set "SHORTCUT_66=Apps Folder|explorer shell:AppsFolder"
set "SHORTCUT_67=ProgramData|explorer shell:Common AppData"
set "SHORTCUT_68=AppData (Roaming)|explorer shell:AppData"
set "SHORTCUT_69=Windows Temp Folder|explorer %SystemRoot%\Temp"
set "SHORTCUT_70=User Temp Folder|explorer %TEMP%"
set "SHORTCUT_71=Task Scheduler|taskschd.msc"
set "SHORTCUT_72=Windows Terminal|wt"
set "SHORTCUT_73=Command Prompt|cmd"
set "SHORTCUT_74=PowerShell|powershell"
set "SHORTCUT_75=PowerShell ISE|powershell_ise"
set "SHORTCUT_76=DiskPart (CLI)|cmd /k diskpart"
set "SHORTCUT_77=System File Checker (CLI)|cmd /k sfc /scannow"
set "SHORTCUT_78=DISM Health Scan (CLI)|cmd /k dism /online /cleanup-image /scanhealth"
set "SHORTCUT_79=CHKDSK C: (CLI)|cmd /k chkdsk C: /scan"
set "SHORTCUT_80=IP Configuration (CLI)|cmd /k ipconfig /all"
set "SHORTCUT_81=Route Table (CLI)|cmd /k route print"
set "SHORTCUT_82=Ping Test 8.8.8.8 (CLI)|cmd /k ping 8.8.8.8 -t"
set "SHORTCUT_83=Netstat (CLI)|cmd /k netstat -ano"
set "SHORTCUT_84=ARP Table (CLI)|cmd /k arp -a"
set "SHORTCUT_85=NSLookup (CLI)|cmd /k nslookup"
set "SHORTCUT_86=Resource Kit PathPing (CLI)|cmd /k pathping 8.8.8.8"
set "SHORTCUT_87=Computer Certificates (MMC)|mmc"
set "SHORTCUT_88=Bluetooth Settings|ms-settings:bluetooth"
set "SHORTCUT_89=Display Settings|ms-settings:display"
set "SHORTCUT_90=Windows Update Settings|ms-settings:windowsupdate"
set "SHORTCUT_91=Windows Security Settings|ms-settings:windowsdefender"
set "SHORTCUT_92=Activation Settings|ms-settings:activation"
set "SHORTCUT_93=Storage Settings|ms-settings:storagesense"
set "SHORTCUT_94=Battery Settings|ms-settings:batterysaver"
set "SHORTCUT_95=Apps and Features|ms-settings:appsfeatures"
set "SHORTCUT_96=Startup Apps|ms-settings:startupapps"
set "SHORTCUT_97=Default Apps|ms-settings:defaultapps"
set "SHORTCUT_98=Recovery Settings|ms-settings:recovery"
set "SHORTCUT_99=Troubleshoot Settings|ms-settings:troubleshoot"
set "SHORTCUT_100=Windows Features|optionalfeatures"
exit /b 0

:done
set "EXIT_CODE=0"
call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
