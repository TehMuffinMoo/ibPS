function Get-NIOSConnectionProfile {
    <#
    .SYNOPSIS
        Retrieves the stored NIOS Configuration from the local machine, if available.

    .DESCRIPTION
        This function will retrieve the saved NIOS Configuration from the local user/machine if it has previously been stored.

    .EXAMPLE
        Get-NIOSConnectionProfile

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Authentication
    #>
    $Base64 = $ENV:NIOSConfig
    $APIVersion = "2.12"
    $Server = ""
    if ($Base64) {
        $NIOSConfig = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Base64))
        $NIOSConfigSplit = $NIOSConfig.Split(":")
        
        if ($NIOSConfigSplit[0]) {
          $Server = $NIOSConfigSplit[0]
        }
        if ($NIOSConfigSplit[1]) {
          $APIVersion = $NIOSConfigSplit[1]
        }
    }
    $Results = @{
      "Server" = $Server
      "APIVersion" = $APIVersion
    }
    return $Results
}