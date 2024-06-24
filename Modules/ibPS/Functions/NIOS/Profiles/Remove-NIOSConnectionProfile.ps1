function Remove-NIOSConnectionProfile {
    [Alias('Remove-NCP')]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Bool]$Confirm = $true
    )

    if (Get-NIOSConnectionProfile -Name $Name) {
        $ContextConfig = (Get-NIOSContext)
        if ($ContextConfig.CurrentContext -ne $Name) {
            if ($Confirm) {
                Write-Warning "Are you sure you want to delete the connection profile: $($Name)?" -WarningAction Inquire
            }
            $ContextConfig.Contexts.PSObject.Members.Remove($Name)
            $ContextConfig | ConvertTo-Json -Depth 5 | Out-File $Script:NIOSConfigFile -Force
            Write-Host "Removed connection profile: $($Name)" -ForegroundColor Green
            break
        } else {
            Write-Error "Cannot delete $($Name) as it the current active connection profile."
            break
        }
    } else {
        Write-Error "Unable to find a connection profile with name: $($Name)"
    }
}