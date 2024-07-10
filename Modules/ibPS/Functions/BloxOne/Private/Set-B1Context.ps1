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
        if ($ENV:B1APIKey -or $ENV:B1CSPUrl) {
            $Platform = Detect-OS
            if ($Platform -eq "Windows") {
              [System.Environment]::SetEnvironmentVariable('B1APIKey',$null,[System.EnvironmentVariableTarget]::User)
              [System.Environment]::SetEnvironmentVariable('B1CSPUrl',$null,[System.EnvironmentVariableTarget]::User)
              $ENV:B1APIKey = $null
              $ENV:B1CSPUrl = $null
            }
            if ($Platform -eq "Mac" -or $Platform -eq "Unix") {
                if (Test-Path ~/.zshenv) {
                    sed -i '' -e '/B1APIKey/d' ~/.zshenv
                    sed -i '' -e '/B1CSPUrl/d' ~/.zshenv
                    unset B1APIKey
                    unset B1CSPUrl
                }
                $ENV:B1APIKey = $null
                $ENV:B1CSPUrl = $null
            }
        }
    }

    $Configs | ConvertTo-Json -Depth 5 | Out-File $Script:B1ConfigFile -Force
}