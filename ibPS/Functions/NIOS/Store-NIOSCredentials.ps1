function Store-NIOSCredentials {
    <#
    .SYNOPSIS
        Stores NIOS Credentials to the local user/machine

    .DESCRIPTION
        This function will store NIOS Credentials for the current user on the local machine. If previous NIOS Credentials exist, they will be overwritten.

    .PARAMETER Credentials
        Credentials object for NIOS Username/Password

    .PARAMETER Persist
        Using the -Persist switch will save the NIOS Credentials across powershell sessions. Without using this switch, they will only be stored for the current powershell session.

    .Example
        Store-NIOSCredentials -Credentials ${CredentialObject} -Persist

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Authentication
    #>
    param(
      $Credentials,
      [switch]$Persist
    )
    if (!($Credentials)) {
        $Credentials = Get-Credential
    }
    $Username = $Credentials.GetNetworkCredential().UserName
    $Password = $Credentials.Password | ConvertFrom-SecureString
    $UPCombo = "$Username`:$Password"
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($UPCombo)
    $Base64 =[Convert]::ToBase64String($Bytes)

    if ($Persist) {
        [System.Environment]::SetEnvironmentVariable('NIOSCredentials',$Base64,[System.EnvironmentVariableTarget]::User)
        $ENV:NIOSCredentials = $Base64
        Write-Host "Credentials for $Username have been stored permenantly for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
    } else {
        $ENV:NIOSCredentials = $Base64
        Write-Host "Credentials for $Username have been stored for this session." -ForegroundColor Green
        Write-Host "You can make these credentials persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
    }
}