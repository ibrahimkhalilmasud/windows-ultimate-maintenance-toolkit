# Contributing Guide

Thank you for contributing to **Windows Ultimate Maintenance Toolkit**.

## Development Standards
- Keep scripts safe, auditable, and reversible where possible.
- Do not add unsafe registry edits, destructive deletes, or permanent security disablement.
- Use semantic versioning for release-impacting changes.
- Update documentation for any behavior change.

## Local Validation
There is no formal automated test suite yet. Before opening a PR:
1. Validate batch syntax and labels for changed scripts.
2. Run changed scripts in a Windows 10/11 test environment.
3. Confirm logs are generated in `logs/` and reports in `reports/`.

## Commit Message Examples
- `feat(launcher): add categorized dashboard and system summary`
- `feat(diagnostics): add html report export for system diagnostics`
- `fix(network): add retry and error logging to dns reset`
- `docs(security): clarify malware cleanup safeguards`
- `chore(repo): add issue and pr templates`

## Pull Requests
- Use the PR template.
- Keep changes focused and minimal.
- Include manual validation steps and results.
