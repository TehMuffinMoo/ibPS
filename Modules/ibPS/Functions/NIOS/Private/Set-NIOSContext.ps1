function Set-NIOSContext {
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [System.Object]$Config,
        [Switch]$NoSwitchProfile
    )

    $Configs = Get-NIOSContext -Raw
    if ($Configs.Contexts."$($Name)") {
        Write-Warning "Are you sure you want to overwrite the NIOS connection profile: $($Name)?" -WarningAction Inquire
        Write-Host "Overwriting saved NIOS connection profile: $($Name).." -ForegroundColor Green
        $Configs.Contexts."$($Name)" = $Config
    } else {
        Write-Host "Creating new NIOS connection profile: $($Name).." -ForegroundColor Green
        $Configs.Contexts | Add-Member -MemberType NoteProperty -Name $($Name) -Value $($Config)
    }

    if (-not $NoSwitchProfile) {
        Write-Host "Active NIOS connection profile set to: $($Name)" -ForegroundColor Cyan
        $Configs.CurrentContext = $($Name)
    }

    $Configs | ConvertTo-Json -Depth 5 | Out-File $Script:NIOSConfigFile -Force
}