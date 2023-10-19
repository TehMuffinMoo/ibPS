function Get-NIOSConfiguration {
    <#
    .SYNOPSIS
        Retrieves the stored NIOS Configuration from the local machine, if available.

    .DESCRIPTION
        This function will retrieve the saved NIOS Configuration from the local user/machine if it has previously been stored.

    .Example
        Get-NIOSConfiguration

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Authentication
    #>
    $Base64 = $ENV:NIOSConfig
    if ($Base64) {
        $NIOSConfig = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Base64))
        $NIOSConfigSplit = $NIOSConfig.Split(":")
        if (!$NIOSConfigSplit[1]) {
            $APIVersion = "2.12"
        } else {
            $APIVersion = $NIOSConfigSplit[1]
        }
        $Results = @{
            "Server" = $NIOSConfigSplit[0]
            "APIVersion" = $APIVersion
        }
        return $Results
    }
}