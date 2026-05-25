# Troubleshooting Guide

## Launcher does not open as administrator
- Right click `launcher/Main_Toolkit.bat` and choose **Run as administrator**.
- Ensure UAC prompts are not blocked by policy.

## Tool exits immediately
- Run from `cmd.exe` instead of double-clicking from restricted locations.
- Confirm script file was not blocked by SmartScreen.

## No logs generated
- Verify write permissions to the repository `logs/` folder.
- Check antivirus policy exceptions for script-controlled output paths.

## Reports are missing sections
- Some report sections are conditional (battery/network/internet availability).
- Re-run diagnostics while connected to required hardware/network components.
