# Installation

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

### 1. Install fastfetch
```powershell
winget install fastfetch
```

### 2. Install a Nerd Font
Download and install a compatible Nerd Font from [nerdfonts.com](https://www.nerdfonts.com/font-downloads).  
This config uses **JetBrainsMono Nerd Font**.

### 3. Install PowerShell 7
```powershell
winget install Microsoft.PowerShell
```
Or follow the [official guide](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows).

### 4. Install oh-my-posh
```powershell
winget install JanDeDobbeleer.OhMyPosh
```

### 5. Configure Windows Terminal
Open **Windows Terminal**, click the **˅** arrow next to the tabs and select **Settings**.

- Under **Startup**, set **Default profile** to `PowerShell 7`
- Under **Startup**, set **Default terminal application** to `Windows Terminal`

<img width="986" alt="Terminal settings – default profile" src="https://github.com/user-attachments/assets/fde57bcb-8835-435f-bbba-e26a7da56bcd" />
<img width="991" alt="Terminal settings – default terminal application" src="https://github.com/user-attachments/assets/227d2051-f93b-4d50-8aae-b90957715245" />

### 6. Create the PowerShell profile
Open a PowerShell 7 terminal and run:
```powershell
New-Item -ItemType File -Path $PROFILE -Force
```
Then run `$PROFILE` to print the path — it will look something like:
```
C:\Users\YourUser\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

### 7. Copy the PowerShell profile
Open the `PowerShell/` folder from this repository, copy the entire contents of the `.ps1` file, and paste them into the file at the path printed above.

### 8. Set up fastfetch config
Create the config directory if it does not already exist:
```powershell
New-Item -ItemType Directory -Path "$HOME\.config\fastfetch" -Force
```
Then copy everything from the `fastfetch/` folder in this repository into that directory.

### 9. Patch the fastfetch config
Open `~/.config/fastfetch/config.jsonc` and find the line:
```
"source": "C:/Users/YourUser/.config/fastfetch/ascii.txt",
```
Replace `YourUser` with your actual Windows username.

### 10. Set up oh-my-posh theme
Create the config directory:
```powershell
New-Item -ItemType Directory -Path "$HOME\.config\oh-my-posh" -Force
```
Copy everything from the `oh-my-posh/` folder in this repository into that directory.  
The profile is already configured to load `atomicBit.omp.json` from that location automatically.

### 11. Restart the terminal
Close and reopen Windows Terminal. Everything should now be active.
