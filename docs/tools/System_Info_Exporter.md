# System_Info_Exporter

## Purpose
Provides a focused maintenance operation for the **System_Info_Exporter** workflow.

## Features
- Automatic admin elevation flow
- Timestamped centralized logging in `logs/`
- Result summary entry generation in `reports/`
- Safety-first command execution with status output

## Requirements
- Windows 10/11
- Administrator privileges
- Native Windows command-line utilities

## How to Run
1. Open `cmd.exe` as Administrator.
2. Navigate to the repository root.
3. Run the script from its category folder.

## Expected Outputs
- Console success/failure indicators
- Script-specific `.log` file in `logs/`
- Optional diagnostic/backup report outputs in `reports/`

## Warnings
- Review logs after execution.
- Validate production impact before enterprise-wide rollout.
- Test first in a non-production machine when possible.

## Troubleshooting
- If elevation fails, manually run as Administrator.
- If a command is unavailable, verify Windows edition/features.
- If paths fail, clone repository to a local non-restricted folder.

## Screenshot Placeholder
![System_Info_Exporter Screenshot Placeholder](../../assets/System_Info_Exporter.png)

## FAQ
### Is this tool safe for enterprise use?
Yes, when run with change-control process and pre-validation.

### Where are logs stored?
In the repository `logs/` directory with timestamps.

### Can I automate execution?
Yes, invoke scripts through scheduled tasks or management tooling.
