function Set-NIOSConfiguration {
    <#
    .SYNOPSIS
        Stores NIOS Server Address & API Version to the local user/machine

    .DESCRIPTION
        This function will store NIOS Server Address & API Version for the current user on the local machine. If previous configuration exists, it will be overwritten.

    .PARAMETER Server
        The FQDN of the Grid Master

    .PARAMETER APIVersion
        The WAPI API Version. Defaults to v2.12

    .PARAMETER Persist
        Using the -Persist switch will save the NIOS Credentials across powershell sessions. Without using this switch, they will only be stored for the current powershell session.

    .EXAMPLE
        Set-NIOSConfiguration -Server gm.mydomain.corp -APIVersion 2.13 -Persist

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Authentication
    #>
    param(
      [String]$Server,
      [String]$APIVersion,
      [switch]$Persist
    )

    $NIOSConfig = "$Server`:$APIVersion"
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($NIOSConfig)
    $Base64 =[Convert]::ToBase64String($Bytes)

    if ($Persist) {
        $Platform = Detect-OS
        if ($Platform -eq "Windows") {
          [System.Environment]::SetEnvironmentVariable('NIOSConfig',$Base64,[System.EnvironmentVariableTarget]::User)
          $ENV:NIOSConfig = $Base64
          Write-Host "Configuration has been stored permanently for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
        } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
            [System.Environment]::SetEnvironmentVariable('NIOSConfig',$Base64,[System.EnvironmentVariableTarget]::User)
            $ENV:NIOSConfig = $Base64
            if (!(Test-Path ~/.zshenv)) {
              touch ~/.zshenv
            }
            sed -i '' -e '/NIOSConfig/d' ~/.zshenv
            echo "export NIOSConfig=$Base64" >> ~/.zshenv
            Write-Host "NIOS configuration has been stored permanently for $env:USER on $(scutil --get LocalHostName)." -ForegroundColor Green
        }
    } else {
        $ENV:NIOSConfig = $Base64
        Write-Host "NIOS configuration has been stored for this session." -ForegroundColor Green
        Write-Host "You can make this configuration persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
    }
}