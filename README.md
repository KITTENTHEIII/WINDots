# Automatic installation

1. Run `install.ps1` as a administrator.

2. In case it tells you to manually edit something it is recommended to read the manual installation guide.

3. Open the terminal settings and select `Powershell 7` as the default profile and select `Terminal` for the default terminal application.

# Manual installation

1. Install fastfetch: `winget install fastfetch`

2. Download and install compatible nerd font: `https://www.nerdfonts.com/font-downloads`

3. Install Powershell 7: `https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6`

4. Open a terminal and then click on the arrow and select the "Settings" option.

5. Select Powershell 7 as the default profile & Select Terminal as the default terminal application.

<img width="986" height="435" alt="Step1" src="https://github.com/user-attachments/assets/fde57bcb-8835-435f-bbba-e26a7da56bcd" />
<img width="991" height="430" alt="Step2" src="https://github.com/user-attachments/assets/227d2051-f93b-4d50-8aae-b90957715245" />

6. Open a terminal and run the following command: `New-Item -ItemType File -Path $PROFILE -Force` 

7. Also run the command `$PROFILE` and then copy the path it will give you into file explorer, the will will normally be at `C:\Users\YourUser\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

8. Download the repository, open the "PowerShell" folder and click to edit the `.ps1` file and copy everything from it, and then paste it inside the path that was given to you when you ran the `$PROFILE` command.

9. Go to `C:\Users\YourUser` and create a directory named `.config`, open the ".config" directory and then create another directory called `fastfetch`

10. Open again the downloaded repository and then copy and paste everything that is inside the "fastfetch" folder into the other fastfetch folder that you created.

11. Open `config.jsonc` and edit the line that says `"source": "C:/Users/YourUser/.config/fastfetch/ascii.txt",` changing the username in the path to your windows username.
