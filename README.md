# Automatic Installation [Recommended]

## Automatic

1. Clone or download this repository.
2. Right-click `install.ps1` and select **Run as Administrator** (or run it from an elevated PowerShell session).
3. Follow any on-screen prompts. If the script warns you to manually edit something, refer to the [Manual Installation](#manual-installation) section below.
4. When the script finishes, open **Windows Terminal → Settings** and:
   - Set **Default profile** to `PowerShell 7`
   - Set **Default terminal application** to `Windows Terminal`

> The script handles everything else — fastfetch, JetBrainsMono Nerd Font, oh-my-posh, and all config files.

---

## Manual Installation

### 1. Install requirements

```powershell
winget install fastfetch
winget install Microsoft.PowerShell
winget install JanDeDobbeleer.OhMyPosh
```

### 2. Configure Windows Terminal
- Set Default profile → PowerShell 7
- Set Default terminal application → Windows Terminal

### 3. Create PowerShell profile
New-Item -ItemType File -Path $PROFILE -Force
$PROFILE

Open the printed file path and paste the provided PowerShell profile from this repo.

### 4. Fastfetch setup
New-Item -ItemType Directory -Path "$HOME\.config\fastfetch" -Force

Copy the fastfetch/ folder from this repo into:

~/.config/fastfetch/

Then edit:

~/.config/fastfetch/config.jsonc

Replace YourUser with your Windows username.

### 5. Oh My Posh setup
New-Item -ItemType Directory -Path "$HOME\.config\oh-my-posh" -Force

Copy the oh-my-posh/ folder from this repo into:

~/.config/oh-my-posh/

### 6. GlazeWM setup

Install:

winget install GlazeWM

Copy your config into:

$HOME\.glzr\glazewm\config.yaml

Restart GlazeWM after changes.

### 7. YASB setup

Install:

winget install AmN.yasb

Copy config into:

$HOME\.glzr\yasb\config.yaml

Make sure GlazeWM + YASB are both running.

### 8. Restart terminal

Close and reopen Windows Terminal. Everything should now be active.
