function Switch-NIOSConnectionProfile {
    [Alias('Switch-NCP')]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name
    )

    if (Get-NIOSConnectionProfile -Name $Name) {
        $ContextConfig = (Get-NIOSContext)
        if ($ContextConfig.CurrentContext -ne $Name) {
            Write-Host "$($Name) has been set as the active connection profile." -ForegroundColor Green
            $ContextConfig.CurrentContext = $Name
            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:NIOSConfigFile -Force
            break
        } else {
            Write-Host "$($Name) is already the active connection profile." -ForegroundColor Green
            break
        }
    } else {
        Write-Error "Unable to find a connection profile with name: $($Name)"
    }
}