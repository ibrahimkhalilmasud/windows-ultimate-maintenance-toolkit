# Windows Ultimate Maintenance Toolkit

![Project Banner Placeholder](assets/banner.png)

All-in-one Windows maintenance, repair, optimization, diagnostics, cleanup, and recovery toolkit for laptops and desktop PCs.

## Overview
This repository provides a modular, production-grade toolkit for Windows 10/11 administrators, technicians, and enterprise support teams.

## Features
- Central launcher dashboard with category navigation
- Per-tool confirmation prompt showing what the selected script does
- Admin auto-elevation and safety-focused script design
- Centralized timestamped logging in `logs/`
- Automated TXT/HTML report generation in `reports/`
- Modular scripts for cleanup, repair, network, diagnostics, optimization, security, and backup
- Per-tool documentation with troubleshooting and FAQ

## Toolkit Categories
- Cleanup
- Repair
- Optimization
- Diagnostics
- Security
- Backup
- Network

## Installation
1. Clone or download the repository.
2. Ensure execution from a local writable path.
3. Launch `launcher/Main_Toolkit.bat`.

## Quick Start
```bat
cd Windows-Ultimate-Maintenance-Toolkit\launcher
Main_Toolkit.bat
```

## Screenshots
- Launcher: `assets/launcher.png`
- Diagnostics: `assets/diagnostics.png`
- Reports: `assets/reports.png`

## Folder Structure
```text
/Windows-Ultimate-Maintenance-Toolkit
├── launcher/
├── cleanup/
├── repair/
├── network/
├── diagnostics/
├── optimization/
├── security/
├── drivers/
├── backup/
├── logs/
├── reports/
├── assets/
├── docs/
└── scripts/
```

## Usage Examples
- Run DNS repair: `network\DNS_Reset_Repair.bat`
- Run system repair: `repair\System_Repair_Toolkit.bat`
- Export diagnostics: `diagnostics\Full_PC_Diagnostics.bat`

## Security Notes
- No permanent security disablement operations are included.
- All modules log outcomes for auditing.
- Review `SECURITY.md` for reporting and policy.

## Troubleshooting
See `docs/troubleshooting.md` and tool-specific docs under `docs/tools/`.

## Contribution Guide
See `CONTRIBUTING.md`.

## License
Distributed under the MIT License. See `LICENSE`.

## Roadmap
- Add signed script releases
- Add optional PowerShell GUI wrapper
- Add CI linting for batch/PowerShell syntax checks

## Disclaimer
Use at your own risk. Always test in staging before enterprise deployment.
