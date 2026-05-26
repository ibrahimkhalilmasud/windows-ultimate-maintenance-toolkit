# Windows_100_Shortcuts_Hub

## Purpose
Provides a centralized quick-launch menu for **100 built-in Windows shortcut tools**.

## Features
- Automatic admin elevation flow
- Timestamped centralized logging in `logs/`
- Result summary entry generation in `reports/`
- Input validation for safe menu selection
- One-menu access to Windows utilities, Control Panel applets, CLI diagnostics, and Settings pages

## Requirements
- Windows 10/11
- Administrator privileges
- Native Windows command-line utilities

## How to Run
1. Open `cmd.exe` as Administrator.
2. Navigate to the repository root.
3. Run `shortcuts\Windows_100_Shortcuts_Hub.bat` or open from `launcher\Main_Toolkit.bat`.

## Expected Outputs
- Console success/failure indicators
- Script-specific `.log` file in `logs/`
- Summary entry in `reports/`
- Selected utility or settings page opens

## Warnings
- This tool launches utilities only; review each utility before making changes.
- Some launched utilities can modify system configuration when used manually.
- Test first in a non-production machine when possible.

## Troubleshooting
- If elevation fails, manually run as Administrator.
- If a shortcut does not open, verify the utility is available on your Windows edition.
- If a Settings URI fails, ensure you are on a supported Windows build.

## Screenshot Placeholder
![Windows_100_Shortcuts_Hub Screenshot Placeholder](../../assets/Windows_100_Shortcuts_Hub.png)

## FAQ
### Does this script perform maintenance actions directly?
No. It only launches built-in tools and settings pages.

### Where are logs stored?
In the repository `logs/` directory with timestamps.

### Can I add or replace shortcuts?
Yes, edit the `:LoadShortcuts` list in `shortcuts\Windows_100_Shortcuts_Hub.bat`.
