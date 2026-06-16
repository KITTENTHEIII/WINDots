try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $global:OutputEncoding    = [System.Text.UTF8Encoding]::new($false)

    if ($IsWindows -and $Host.Name -eq 'ConsoleHost') {
        chcp.com 65001 *> $null
    }
}
catch {
    Write-Verbose "UTF-8 configuration failed: $_"
}

Clear-Host

try {
    $fastfetch = Get-Command fastfetch -ErrorAction SilentlyContinue

    if ($fastfetch) {
        $fastfetchConfig = Join-Path $HOME ".config\fastfetch\config.jsonc"

        if (Test-Path $fastfetchConfig) {
            & $fastfetch.Source -c $fastfetchConfig
        }
        else {
            & $fastfetch.Source
        }
    }
}
catch {
    Write-Verbose "Fastfetch failed: $_"
}

try {
    $ohMyPosh = Get-Command oh-my-posh -ErrorAction SilentlyContinue

    if ($ohMyPosh) {
        $ompConfig = Join-Path $HOME ".config\oh-my-posh\atomicBit.omp.json"

        if (Test-Path $ompConfig) {
            & $ohMyPosh.Source init pwsh --config $ompConfig | Invoke-Expression
        }
        else {
            & $ohMyPosh.Source init pwsh | Invoke-Expression
        }
    }
}
catch {
    Write-Verbose "Oh My Posh initialization failed: $_"
}

if (Get-Module -ListAvailable PSReadLine) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue

    Set-PSReadLineOption -PredictionSource History `
                         -PredictionViewStyle ListView `
                         -ErrorAction SilentlyContinue

    Set-PSReadLineKeyHandler -Key Tab -Function Complete `
                             -ErrorAction SilentlyContinue
}

Set-Alias ll Get-ChildItem -ErrorAction SilentlyContinue

function la {
    Get-ChildItem -Force
}

function which {
    param([string]$Command)
    Get-Command $Command -ErrorAction SilentlyContinue
}

$Host.UI.RawUI.WindowTitle = "PowerShell"
