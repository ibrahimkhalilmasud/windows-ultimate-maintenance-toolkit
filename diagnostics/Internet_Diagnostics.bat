@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================================
REM Internet_Diagnostics
REM Version: 1.1.0
REM Author: Windows Ultimate Maintenance Toolkit Contributors
REM Description: Checks active-network gateway, DNS, internet routing, and a targeted local subnet scan.
REM Usage: Run as administrator from cmd.exe or launcher/Main_Toolkit.bat
REM Warning: Validate environment and review output logs before repeated usage.
REM ============================================================================

set "COMMON_LIB=%~dp0..\scripts\CommonLib.bat"
set "TOOLKIT_ROOT=%~dp0.."
call "%COMMON_LIB%" :Initialize "Internet_Diagnostics" "1.1.0" "%TOOLKIT_ROOT%"
call "%COMMON_LIB%" :EnsureAdmin "%~f0" %*
if errorlevel 1 exit /b 0

call "%COMMON_LIB%" :Print INFO "Starting Internet_Diagnostics"

set "RPT_TXT=%REPORT_DIR%\Internet_Diagnostics_%RUN_ID%.txt"
set "SCAN_RPT=%REPORT_DIR%\Internet_Diagnostics_LocalScan_%RUN_ID%.txt"
set "ACTIVE_ALIAS="
set "ACTIVE_IP="
set "ACTIVE_GW="
set "ACTIVE_PREFIX="

for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "$cfg=Get-NetIPConfiguration ^| Where-Object { $_.IPv4Address -and $_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up' } ^| Select-Object -First 1; if($cfg){'ALIAS=' + $cfg.InterfaceAlias; 'IP=' + $cfg.IPv4Address.IPAddress; 'GW=' + $cfg.IPv4DefaultGateway.NextHop; 'PREFIX=' + $cfg.IPv4Address.PrefixLength}"`) do (
  for /f "tokens=1* delims==" %%A in ("%%I") do (
    if /I "%%A"=="ALIAS" set "ACTIVE_ALIAS=%%B"
    if /I "%%A"=="IP" set "ACTIVE_IP=%%B"
    if /I "%%A"=="GW" set "ACTIVE_GW=%%B"
    if /I "%%A"=="PREFIX" set "ACTIVE_PREFIX=%%B"
  )
)

set "EXIT_CODE=0"
if not defined ACTIVE_IP (
  call "%COMMON_LIB%" :Print ERROR "No active IPv4 adapter with default gateway found."
  set "EXIT_CODE=1"
) else (
  > "%RPT_TXT%" (
    echo Internet Diagnostics Report
    echo Run ID: %RUN_ID%
    echo Timestamp: %DATE% %TIME%
    echo Interface: %ACTIVE_ALIAS%
    echo Local IPv4: %ACTIVE_IP%
    echo Default Gateway: %ACTIVE_GW%
    echo Prefix Length: %ACTIVE_PREFIX%
    echo.
  )
  call "%COMMON_LIB%" :Print INFO "Using active adapter: %ACTIVE_ALIAS% ^(%ACTIVE_IP%/%ACTIVE_PREFIX%^) via %ACTIVE_GW%"

  (
    echo === Adapter and route summary ===
    ipconfig
    route print -4
    echo.
  ) >> "%RPT_TXT%" 2>> "%LOG_FILE%" & call "%COMMON_LIB%" :RecordResult "Collect adapter and route details" %errorlevel%
  if errorlevel 1 set "EXIT_CODE=1"

  ping "%ACTIVE_GW%" -n 2 -w 1000 >nul 2>&1
  call "%COMMON_LIB%" :RecordResult "Ping active default gateway" %errorlevel%
  if errorlevel 1 set "EXIT_CODE=1"
  (
    echo === Gateway ping (%ACTIVE_GW%) ===
    ping "%ACTIVE_GW%" -n 4
    echo.
  ) >> "%RPT_TXT%" 2>> "%LOG_FILE%"

  nslookup github.com >nul 2>&1
  call "%COMMON_LIB%" :RecordResult "Validate DNS resolution (github.com)" %errorlevel%
  if errorlevel 1 set "EXIT_CODE=1"
  (
    echo === DNS check (github.com) ===
    nslookup github.com
    echo.
  ) >> "%RPT_TXT%" 2>> "%LOG_FILE%"

  ping 1.1.1.1 -n 2 -w 1000 >nul 2>&1
  call "%COMMON_LIB%" :RecordResult "Validate internet reachability (1.1.1.1)" %errorlevel%
  if errorlevel 1 set "EXIT_CODE=1"
  (
    echo === Internet reachability (1.1.1.1) ===
    ping 1.1.1.1 -n 4
    echo.
  ) >> "%RPT_TXT%" 2>> "%LOG_FILE%"

  (
    echo === Trace route to 1.1.1.1 ===
    tracert -d -h 10 1.1.1.1
    echo.
  ) >> "%RPT_TXT%" 2>> "%LOG_FILE%" & call "%COMMON_LIB%" :RecordResult "Trace internet route" %errorlevel%
  if errorlevel 1 set "EXIT_CODE=1"

  powershell -NoProfile -Command "$ip=[System.Net.IPAddress]::Parse('%ACTIVE_IP%');$prefix=[int]'%ACTIVE_PREFIX%';$bytes=$ip.GetAddressBytes();[Array]::Reverse($bytes);$ipInt=[BitConverter]::ToUInt32($bytes,0);$hostBits=32-$prefix;if($hostBits -lt 0){$hostBits=0};$maxHosts=[Math]::Pow(2,$hostBits)-2;if($maxHosts -lt 1){$maxHosts=1};$scanCount=[Math]::Min([int]$maxHosts,64);$mask=if($prefix -eq 0){[uint32]0}else{([uint32]::MaxValue -shl (32-$prefix))};$network=$ipInt -band $mask;'Target subnet: ' + $ip.ToString() + '/' + $prefix;'Host scan limit: ' + $scanCount;for($i=1;$i -le $scanCount;$i++){ $targetInt=$network + [uint32]$i; $targetBytes=[BitConverter]::GetBytes($targetInt); [Array]::Reverse($targetBytes); $target=[System.Net.IPAddress]::new($targetBytes).ToString(); if($target -eq $ip.ToString()){continue}; if(Test-Connection -ComputerName $target -Count 1 -Quiet -TimeoutSeconds 1){'UP  ' + $target} }" > "%SCAN_RPT%" 2>> "%LOG_FILE%" & call "%COMMON_LIB%" :RecordResult "Scan active local subnet (targeted)" %errorlevel%
  if errorlevel 1 set "EXIT_CODE=1"
  (
    echo === Local subnet scan summary ===
    type "%SCAN_RPT%"
    echo.
    echo Local subnet scan report: %SCAN_RPT%
  ) >> "%RPT_TXT%" 2>> "%LOG_FILE%"
)

call "%COMMON_LIB%" :Finalize %EXIT_CODE%
echo.
pause
endlocal
exit /b %EXIT_CODE%
