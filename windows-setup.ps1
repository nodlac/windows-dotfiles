# Windows 11 Setup Script - Remove Bloatware & Install Apps
# Run as Administrator: Right-click -> Run with PowerShell

Write-Host "=== Windows Setup Script ===" -ForegroundColor Cyan
Write-Host "This script will remove bloatware and install apps via winget" -ForegroundColor Yellow

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    pause
    exit
}

# Function to remove bloatware apps
function Remove-Bloatware {
    Write-Host "`n[1/3] Removing bloatware apps..." -ForegroundColor Green
    
    # Apps that are still present on your system that you may want to remove
    $bloatwareApps = @(
        # Xbox related (still present)
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.XboxGameCallableUI",
        
        # Microsoft bloatware still present
        "Microsoft.GetHelp",
        "Microsoft.WindowsCamera",
        "Microsoft.ZuneMusic",  # Windows Media Player
        "Microsoft.WidgetsPlatformRuntime",
        
        # Common bloatware that might be pre-installed after reset
        "Microsoft.BingNews",
        "Microsoft.BingWeather",
        "Microsoft.BingSports",
        "Microsoft.BingFinance",
        "Microsoft.Getstarted",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MixedReality.Portal",
        "Microsoft.Office.OneNote",
        "Microsoft.People",
        "Microsoft.Print3D",
        "Microsoft.SkypeApp",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsMaps",
        "Microsoft.WindowsSoundRecorder",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.ZuneVideo",
        
        # Third-party bloatware
        "*CandyCrush*",
        "*Spotify*",
        "*Netflix*",
        "*Disney*",
        "*TikTok*",
        "*Instagram*",
        "*Facebook*",
        "*Twitter*",
        "*LinkedIn*",
        "*AdobePhotoshopExpress*",
        "*Duolingo*",
        "*Pandora*",
        "*Flipboard*"
    )

    foreach ($app in $bloatwareApps) {
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
    
    # Disable Widgets and Bing search
    Write-Host "Disabling Widgets and Bing search..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "Bloatware removal complete!" -ForegroundColor Green
}

# Function to install apps via winget
function Install-Apps {
    Write-Host "`n[2/3] Installing apps via winget..." -ForegroundColor Green
    
    # Check if winget is available
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "winget not found! Installing App Installer..." -ForegroundColor Yellow
        Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
        Write-Host "Please install winget from Microsoft Store and re-run this script." -ForegroundColor Red
        return
    }

    # Your actual apps based on current installation
    $apps = @(
        # Browsers (you have Brave and Chrome)
        "Brave.Brave",
        "Google.Chrome",
        
        # Development tools
        "Microsoft.WindowsTerminal",
        "Microsoft.WSL",  # Windows Subsystem for Linux
        
        # Media & Streaming (you have OBS)
        "OBSProject.OBSStudio",
        "VideoLAN.VLC",
        
        # Communication
        "Discord.Discord",
        
        # Gaming
        "Valve.Steam",
    )

    foreach ($app in $apps) {
        Write-Host "Installing: $app" -ForegroundColor Cyan
        winget install --id $app -e --accept-source-agreements --accept-package-agreements --silent
    }
    
    Write-Host "App installation complete!" -ForegroundColor Green
}

# Function to apply system tweaks
function Set-SystemTweaks {
    Write-Host "`n[3/3] Applying system tweaks..." -ForegroundColor Green
    
    # Disable telemetry
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable Xbox Game Bar
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Show file extensions
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Show hidden files
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1 -ErrorAction SilentlyContinue
    
    # Disable Cortana
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable Bing search in Start Menu
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable Windows Tips and Suggestions
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    # Disable Feedback
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0 -ErrorAction SilentlyContinue
    
    Write-Host "System tweaks applied!" -ForegroundColor Green
}

# Main execution
Write-Host "`nWhat would you like to do?" -ForegroundColor Cyan
Write-Host "  A - Run everything (remove bloatware, install apps, apply tweaks)"
Write-Host "  B - Remove bloatware only"
Write-Host "  I - Install apps only"
Write-Host "  T - Apply system tweaks only"
$choice = Read-Host "`nEnter your choice [A]"

switch ($choice.ToUpper()) {
    "B" { Remove-Bloatware }
    "I" { Install-Apps }
    "T" { Set-SystemTweaks }
    default { 
        Remove-Bloatware
        Install-Apps
        Set-SystemTweaks
    }
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Cyan
Write-Host "Some changes may require a restart to take effect." -ForegroundColor Yellow
$restart = Read-Host "Restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") { Restart-Computer }
