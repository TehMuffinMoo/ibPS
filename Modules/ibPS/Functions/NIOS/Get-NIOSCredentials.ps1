function Get-NIOSCredentials {
    <#
    .SYNOPSIS
        Retrieves the stored NIOS Credentials from the local machine, if available.

    .DESCRIPTION
        This function will retrieve the saved NIOS Credentials from the local user/machine if it has previously been stored.

    .EXAMPLE
        Get-NIOSCredentials

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Authentication
    #>
    $Base64 = $ENV:NIOSCredentials
    if (!$Base64) {
        Write-Host "Error. Missing NIOS Credentials. Store your Credentials first using the Store-NIOSCredentials Cmdlet and re-run this script." -ForegroundColor Red
        break
    } else {
        $UPCombo = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Base64))
        $UPSplit = $UPCombo.Split(":")
        $Username = $UPSplit[0]
        $Password = $UPSplit[1] | ConvertTo-SecureString
        [pscredential]$Creds = New-Object System.Management.Automation.PSCredential ($Username, $Password)
        return $Creds
    }
}