# UTF-8 console setup
try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $global:OutputEncoding    = [System.Text.UTF8Encoding]::new($false)

    if ($IsWindows) {
        chcp.com 65001 *> $null
    }
}
catch {
    Write-Verbose "UTF-8 configuration failed: $_"
}

Clear-Host

# Run Fastfetch with explicit config path
$fastfetch = Get-Command fastfetch -ErrorAction SilentlyContinue

if ($fastfetch) {
    $configPath = Join-Path $HOME ".config\fastfetch\config.jsonc"

    if (Test-Path $configPath) {
        & $fastfetch.Source -c $configPath
    }
    else {
        & $fastfetch.Source
    }
}