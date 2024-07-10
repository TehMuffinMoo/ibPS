function Set-B1Context {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [System.Object]$Config,
        [Switch]$NoSwitchProfile
    )
    Initialize-B1Config
    $Configs = Get-B1Context -Raw
    if ($Configs.Contexts."$($Name)") {
        Write-Warning "Are you sure you want to overwrite the BloxOne connection profile: $($Name)?" -WarningAction Inquire
        Write-Host "Overwriting saved connection profile: $($Name).." -ForegroundColor Green
        $Configs.Contexts."$($Name)" = $Config
    } else {
        Write-Host "Creating new BloxOne connection profile: $($Name).." -ForegroundColor Green
        $Configs.Contexts | Add-Member -MemberType NoteProperty -Name $($Name) -Value $($Config)
    }
    
    if (-not $NoSwitchProfile) {
        Write-Host "Active BloxOne connection profile set to: $($Name)" -ForegroundColor Cyan
        $Configs.CurrentContext = $($Name)
    }

    $Configs | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force
}