#Requires -RunAsAdministrator

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step { param([string]$Message); Write-Host "`n==> $Message" -ForegroundColor Cyan }
function Write-OK   { param([string]$Message); Write-Host "    [OK] $Message" -ForegroundColor Green }
function Write-Warn { param([string]$Message); Write-Host "    [!!] $Message" -ForegroundColor Yellow }

$RepoRoot             = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }
$RepoPowerShellFolder = Join-Path $RepoRoot "PowerShell"
$RepoFastfetchFolder  = Join-Path $RepoRoot "fastfetch"
$RepoOhMyPoshFolder   = Join-Path $RepoRoot "oh-my-posh"

# Flow Launcher
Write-Step "Installing Flow Launcher"
if ((winget list --id FlowLauncher.FlowLauncher 2>&1) | Select-String "Flow Launcher") {
    Write-Warn "Flow Launcher already installed - skipping."
} else {
    winget install --id FlowLauncher.FlowLauncher -e --accept-source-agreements --accept-package-agreements
    Write-OK "Flow Launcher installed."
}

# GlazeWM (without Zebar)
Write-Step "Installing GlazeWM"
if ((winget list --id glzr.GlazeWM 2>&1) | Select-String "GlazeWM") {
    Write-Warn "GlazeWM already installed - skipping."
} else {
    winget install --id glzr.GlazeWM -e --accept-source-agreements --accept-package-agreements
    Write-OK "GlazeWM installed."
}

# 1. fastfetch
Write-Step "Step 1 - Installing fastfetch"
if ((winget list --id Fastfetch-cli.Fastfetch 2>&1) | Select-String "Fastfetch") {
    Write-Warn "fastfetch already installed - skipping."
} else {
    winget install --id Fastfetch-cli.Fastfetch -e --accept-source-agreements --accept-package-agreements
    Write-OK "fastfetch installed."
}

# 2. Nerd Font
Write-Step "Step 2 - Installing JetBrainsMono Nerd Font"
$FontName   = "JetBrainsMono"
$ZipPath    = Join-Path $env:TEMP "$FontName.zip"
$TempDir    = Join-Path $env:TEMP "NerdFonts_$FontName"
$FontsDir   = "$env:SystemRoot\Fonts"
$FontReg    = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

if (-not (Test-Path $TempDir)) { New-Item -ItemType Directory -Path $TempDir | Out-Null }
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FontName.zip" -OutFile $ZipPath -UseBasicParsing
Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

foreach ($Font in (Get-ChildItem -Path $TempDir -Filter "*.ttf" -Recurse)) {
    $Dest = Join-Path $FontsDir $Font.Name
    if (-not (Test-Path $Dest)) {
        Copy-Item -Path $Font.FullName -Destination $Dest -Force
        Set-ItemProperty -Path $FontReg -Name ([IO.Path]::GetFileNameWithoutExtension($Font.Name) + " (TrueType)") -Value $Font.Name -Type String
    }
}
Remove-Item $ZipPath -Force
Write-OK "JetBrainsMono Nerd Font installed."

# 3. PowerShell 7
Write-Step "Step 3 - Installing PowerShell 7"
if ((winget list --id Microsoft.PowerShell 2>&1) | Select-String "Microsoft.PowerShell") {
    Write-Warn "PowerShell 7 already installed - skipping."
} else {
    winget install --id Microsoft.PowerShell -e --accept-source-agreements --accept-package-agreements
    Write-OK "PowerShell 7 installed."
}

# 4 & 5. Manual step
Write-Step "Steps 4 & 5 - Windows Terminal (manual)"
Write-Host @"
    Please do this manually:
      a) Open Windows Terminal > Settings (arrow next to tabs).
      b) Set "Default profile" to PowerShell 7.
      c) Set "Default terminal application" to Windows Terminal.
      d) Save & close.
"@ -ForegroundColor Yellow

# 6. Create PS7 profile file
Write-Step "Step 6 - Creating PowerShell profile"
$PS7ProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path (Split-Path $PS7ProfilePath))) {
    New-Item -ItemType Directory -Path (Split-Path $PS7ProfilePath) -Force | Out-Null
}
if (-not (Test-Path $PS7ProfilePath)) {
    New-Item -ItemType File -Path $PS7ProfilePath -Force | Out-Null
    Write-OK "Profile created: $PS7ProfilePath"
} else {
    Write-Warn "Profile already exists: $PS7ProfilePath"
}

# 7 & 8. Copy profile from repo
Write-Step "Steps 7 & 8 - Copying PowerShell profile from repo"
if (Test-Path $RepoPowerShellFolder) {
    $SourceProfile = Get-ChildItem -Path $RepoPowerShellFolder -Filter "*.ps1" | Select-Object -First 1
    if ($SourceProfile) {
        Set-Content -Path $PS7ProfilePath -Value (Get-Content $SourceProfile.FullName -Raw) -Encoding UTF8
        Write-OK "Profile copied from '$($SourceProfile.FullName)'."
    } else {
        Write-Warn "No .ps1 found in '$RepoPowerShellFolder'. Skipping."
    }
} else {
    Write-Warn "'$RepoPowerShellFolder' not found. Skipping."
}

# 9. Create .config\fastfetch
Write-Step "Step 9 - Creating .config\fastfetch"
$ConfigDir    = Join-Path $env:USERPROFILE ".config"
$FastfetchDir = Join-Path $ConfigDir "fastfetch"
foreach ($Dir in @($ConfigDir, $FastfetchDir)) {
    if (-not (Test-Path $Dir)) { New-Item -ItemType Directory -Path $Dir | Out-Null; Write-OK "Created: $Dir" }
    else { Write-Warn "Already exists: $Dir" }
}

# 10. Copy fastfetch config
Write-Step "Step 10 - Copying fastfetch config from repo"
if (Test-Path $RepoFastfetchFolder) {
    Copy-Item -Path "$RepoFastfetchFolder\*" -Destination $FastfetchDir -Recurse -Force
    Write-OK "fastfetch config copied to '$FastfetchDir'."
} else {
    Write-Warn "'$RepoFastfetchFolder' not found. Skipping."
}

# 11. Patch config.jsonc
Write-Step "Step 11 - Patching config.jsonc with username"
$ConfigJsonc = Join-Path $FastfetchDir "config.jsonc"
if (Test-Path $ConfigJsonc) {
    $Content = Get-Content -Path $ConfigJsonc -Raw
    $Patched = $Content -replace '(?i)(C:/Users/)[^/]+(/.config/fastfetch/ascii\.txt)', "`${1}$env:USERNAME`${2}"
    if ($Patched -ne $Content) {
        Set-Content -Path $ConfigJsonc -Value $Patched -Encoding UTF8
        Write-OK "Patched username to '$env:USERNAME' in config.jsonc."
    } else {
        Write-Warn "Pattern not found - edit manually: $ConfigJsonc"
    }
} else {
    Write-Warn "config.jsonc not found. Skipping."
}

# 12. oh-my-posh
Write-Step "Step 12 - Installing oh-my-posh"
if ((winget list --id JanDeDobbeleer.OhMyPosh 2>&1) | Select-String "OhMyPosh") {
    Write-Warn "oh-my-posh already installed - skipping."
} else {
    winget install --id JanDeDobbeleer.OhMyPosh -e --accept-source-agreements --accept-package-agreements
    Write-OK "oh-my-posh installed."
}

# Refresh PATH so oh-my-posh is available in this session without a restart
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

# 13. Copy oh-my-posh theme from repo
# The profile (copied in steps 7-8) already calls:
#   oh-my-posh init pwsh --config ~/.config/oh-my-posh/atomicBit.omp.json | Invoke-Expression
# This step just puts the theme file in the right place.
Write-Step "Step 13 - Copying oh-my-posh theme from repo"
$OmpConfigDir = Join-Path $env:USERPROFILE ".config\oh-my-posh"
if (-not (Test-Path $OmpConfigDir)) {
    New-Item -ItemType Directory -Path $OmpConfigDir -Force | Out-Null
    Write-OK "Created: $OmpConfigDir"
} else {
    Write-Warn "Already exists: $OmpConfigDir"
}

if (Test-Path $RepoOhMyPoshFolder) {
    Copy-Item -Path "$RepoOhMyPoshFolder\*" -Destination $OmpConfigDir -Recurse -Force
    Write-OK "oh-my-posh config copied to '$OmpConfigDir'."
} else {
    Write-Warn "'$RepoOhMyPoshFolder' not found. Skipping theme copy."
}

# 14. Verify oh-my-posh theme is in place (idempotent check)
Write-Step "Step 14 - Verifying oh-my-posh theme"
$OmpThemePath = Join-Path $OmpConfigDir "atomicBit.omp.json"
if (Test-Path $OmpThemePath) {
    Write-OK "Theme found: $OmpThemePath"
} else {
    Write-Warn "atomicBit.omp.json not found at '$OmpThemePath'."
    Write-Warn "Ensure your repo's oh-my-posh\ folder contains atomicBit.omp.json."
}

# 15. Copy yasb to .config\yasb
Write-Step "Copying YASB config"
$YasbDir = Join-Path $env:USERPROFILE ".config\yasb"

if (-not (Test-Path $YasbDir)) {
    New-Item -ItemType Directory -Path $YasbDir -Force | Out-Null
    Write-OK "Created: $YasbDir"
}

$RepoYasbFolder = Join-Path $RepoRoot "yasb"
if (Test-Path $RepoYasbFolder) {
    Copy-Item -Path "$RepoYasbFolder\*" -Destination $YasbDir -Recurse -Force
    Write-OK "YASB config copied."
} else {
    Write-Warn "YASB folder not found in repo."
}

# 16. Copy glazewm to .glzr\glazewm
Write-Step "Step 16 - Copying glazewm config from repo"
$GlzrDir    = Join-Path $env:USERPROFILE ".glzr"
$GlazewmDir = Join-Path $GlzrDir "glazewm"
foreach ($Dir in @($GlzrDir, $GlazewmDir)) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
        Write-OK "Created: $Dir"
    } else {
        Write-Warn "Already exists: $Dir"
    }
}

$RepoGlazewmFolder = Join-Path $RepoRoot "glazewm"
if (Test-Path $RepoGlazewmFolder) {
    Copy-Item -Path "$RepoGlazewmFolder\*" -Destination $GlazewmDir -Recurse -Force
    Write-OK "glazewm config copied to '$GlazewmDir'."
} else {
    Write-Warn "'$RepoGlazewmFolder' not found. Skipping."
}

Write-Host "`nSetup complete!" -ForegroundColor Green
