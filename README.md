# Windows Dotfiles

PowerShell scripts to quickly set up a fresh Windows installation after a reset or migration.

## What this does

- **Removes bloatware** - Uninstalls Xbox components, Microsoft bloatware, and common pre-installed apps
- **Installs your apps** - Automatically installs your essential software via winget
- **Applies system tweaks** - Disables telemetry, shows file extensions, disables Game Bar, etc.

## Your Apps

The script installs:
- Brave Browser
- Google Chrome
- Git
- Windows Terminal
- WSL (Windows Subsystem for Linux)
- OBS Studio
- VLC Media Player
- 7-Zip
- Notepad++
- PowerToys
- Discord
- Steam
- GOG Galaxy
- Adobe Acrobat Reader
- Malwarebytes

## Usage

1. After resetting Windows, run PowerShell as Administrator
2. Install winget if not present (from Microsoft Store)
3. Run the script:

```powershell
.\windows-setup.ps1
```

4. Choose what to do:
   - **A** - Run everything (remove bloatware, install apps, apply tweaks)
   - **B** - Remove bloatware only
   - **I** - Install apps only
   - **T** - Apply system tweaks only

## Note

Some changes require a restart to take effect. The script will ask if you want to restart at the end.
