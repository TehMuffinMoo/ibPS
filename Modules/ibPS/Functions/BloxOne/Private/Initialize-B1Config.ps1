function Initialize-B1Config {
    if (-not $Script:B1ConfigFolder) {
        if (-not $PSEdition -or $PSEdition -eq 'Desktop' -or $IsWindows) {
            $Script:B1ConfigFolder = $env:LOCALAPPDATA
        } elseif ($IsLinux) {
            $Script:B1ConfigFolder = Join-Path $env:HOME '.config'
        } elseif ($IsMacOs) {
            $Script:B1ConfigFolder = Join-Path $env:HOME 'Library/Preferences'
        } else {
            throw "Unable to identify PowerShell Version"
        }
    }
    if (-not $Script:B1ConfigFile) {
        $Script:B1ConfigFile = Join-Path $Script:B1ConfigFolder 'ibPS-B1-Contexts.json'
    }
    if (!(Test-Path $Script:B1ConfigFile)) {
        $ConfigBase = @{
            "CurrentContext" = $null
            "Contexts" = @{}
        } | ConvertTo-Json
        $null = New-Item $Script:B1ConfigFile -Type File -Value $ConfigBase
    }
}