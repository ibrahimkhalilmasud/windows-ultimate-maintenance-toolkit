@echo off
setlocal EnableExtensions EnableDelayedExpansion
if /I "%~1"=="" exit /b 0
goto %~1

:Initialize
set "TOOL_NAME=%~2"
set "TOOL_VERSION=%~3"
set "TOOLKIT_ROOT=%~f4"
if not defined TOOLKIT_ROOT set "TOOLKIT_ROOT=%~dp0.."
for %%I in ("%TOOLKIT_ROOT%") do set "TOOLKIT_ROOT=%%~fI"
set "LOG_DIR=%TOOLKIT_ROOT%\logs"
set "REPORT_DIR=%TOOLKIT_ROOT%\reports"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%" >nul 2>&1
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set "RUN_ID=%%I"
set "LOG_FILE=%LOG_DIR%\%TOOL_NAME%_%RUN_ID%.log"
set "SUMMARY_FILE=%REPORT_DIR%\Toolkit_Summary_%RUN_ID%.txt"
set "COLOR_OK=0"
for /f "tokens=4-5 delims=. []" %%a in ('ver') do set "WIN_VER=%%a.%%b"
if defined WIN_VER set "COLOR_OK=1"
for /f %%E in ('echo prompt $E ^| cmd') do set "ESC=%%E"
call :Log INFO "Initialized %TOOL_NAME% v%TOOL_VERSION%"
endlocal & (
  set "TOOL_NAME=%TOOL_NAME%"
  set "TOOL_VERSION=%TOOL_VERSION%"
  set "TOOLKIT_ROOT=%TOOLKIT_ROOT%"
  set "LOG_DIR=%LOG_DIR%"
  set "REPORT_DIR=%REPORT_DIR%"
  set "RUN_ID=%RUN_ID%"
  set "LOG_FILE=%LOG_FILE%"
  set "SUMMARY_FILE=%SUMMARY_FILE%"
  set "COLOR_OK=%COLOR_OK%"
  set "ESC=%ESC%"
)
exit /b 0

:EnsureAdmin
set "CALLER_PATH=%~f2"
shift
shift
set "CALLER_ARGS=%*"
net session >nul 2>&1
if %errorlevel%==0 exit /b 0
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%CALLER_PATH%' -ArgumentList '%CALLER_ARGS%' -Verb RunAs" >nul 2>&1
exit /b 1

:Log
setlocal EnableDelayedExpansion
set "LEVEL=%~2"
set "MESSAGE=%~3"
for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH:mm:ss"') do set "NOW=%%I"
>> "%LOG_FILE%" echo [!NOW!] [!LEVEL!] !MESSAGE!
endlocal
exit /b 0

:Print
setlocal EnableDelayedExpansion
set "LEVEL=%~2"
set "MESSAGE=%~3"
set "PREFIX=[!LEVEL!]"
if "%COLOR_OK%"=="1" (
  set "COLOR=37"
  if /I "!LEVEL!"=="SUCCESS" set "COLOR=92"
  if /I "!LEVEL!"=="WARN" set "COLOR=93"
  if /I "!LEVEL!"=="ERROR" set "COLOR=91"
  if /I "!LEVEL!"=="INFO" set "COLOR=96"
  echo !ESC![!COLOR!m!PREFIX! !MESSAGE!!ESC![0m
) else (
  echo !PREFIX! !MESSAGE!
)
call "%~f0" :Log !LEVEL! "!MESSAGE!"
endlocal
exit /b 0

:RecordResult
set "STEP_NAME=%~2"
set "STEP_CODE=%~3"
if "%STEP_CODE%"=="0" (
  call "%~f0" :Print SUCCESS "%STEP_NAME% completed successfully."
) else (
  call "%~f0" :Print ERROR "%STEP_NAME% failed with code %STEP_CODE%."
)
exit /b %STEP_CODE%

:Finalize
set "RESULT=%~2"
if "%RESULT%"=="0" (
  call "%~f0" :Print SUCCESS "%TOOL_NAME% completed."
) else (
  call "%~f0" :Print ERROR "%TOOL_NAME% completed with errors."
)
>> "%SUMMARY_FILE%" echo %TOOL_NAME%|%RUN_ID%|%RESULT%|%LOG_FILE%
exit /b %RESULT%
