function Initialize-NIOSConfig {
    if (-not $PSEdition -or $PSEdition -eq 'Desktop' -or $IsWindows) {
        $script:NIOSConfigFolder = $env:LOCALAPPDATA
    } elseif ($IsLinux) {
        $script:NIOSConfigFolder = Join-Path $env:HOME '.config'
    } elseif ($IsMacOs) {
        $script:NIOSConfigFolder = Join-Path $env:HOME 'Library/Preferences'
    } else {
        throw "Unable to identify PowerShell Version"
    }
    $Script:NIOSConfigFile = Join-Path $Script:NIOSConfigFolder 'ibPS-NIOS-Contexts.json'
    if (!(Test-Path $Script:NIOSConfigFile)) {
        $ConfigBase = @{
            "CurrentContext" = $null
            "Contexts" = @{}
        } | ConvertTo-Json
        $NewConfigFile = New-Item $Script:NIOSConfigFile -Type File -Value $ConfigBase
    }
}