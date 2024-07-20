function Get-B1CSPAPIKey {
    <#
    .SYNOPSIS
        Retrieves the stored BloxOneDDI API Key from the local machine, if available.

    .DESCRIPTION
        This function will retrieve the saved BloxOneDDI API Key from the local user/machine if it has previously been stored.

    .EXAMPLE
        PS> Get-B1CSPAPIKey

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    [CmdletBinding()]
    param(
        [String]$Profile,
        [Switch]$DefaultProfile

    )
    if ($Profile -or $DefaultProfile) {
        $Configs = Get-B1Context
        if ($DefaultProfile) {
            $Profile = $Configs.CurrentContext
        }
        if ($Configs.Contexts."$($Profile)") {
            $ApiKey = ($Configs.Contexts | Select-Object -ExpandProperty $Profile).'API Key'
        } else {
            Write-Error "Unable to find BloxOne Connection Profile: $($Profile)"
            Write-Colour "See the following link for more information: ","`nhttps://ibps.readthedocs.io/en/latest/#authentication-api-key" -Colour Cyan,Magenta
            return $null
        }
    } else {
        $ApiKey = $ENV:B1APIKey
    }
    if (!$ApiKey) {
        Write-Error "No BloxOne Connection Profiles or Global CSP API Key has been configured."
        Write-Colour "See the following link for more information: ","`nhttps://ibps.readthedocs.io/en/latest/#authentication-api-key" -Colour Cyan,Magenta
        break
    } else {
        try {
            $Bytes = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($ApiKey)) | ConvertTo-SecureString
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Bytes)
            $B1APIKey = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
            if ($B1APIKey) {
                return $B1APIKey
            }
        } catch {
            Write-Colour 'Error. Unable to decode the API Key. Please set the Global API Key again using: ','Set-ibPSConfiguration -CSPAPIKey <apikey>', ' or create a new connection profile.' -Colour Red,Green,Red
            Write-Colour 'If you have recently upgraded from a version older than ','v1.9.5.0',', you will need to update your API Key.' -Colour Yellow,Red,Yellow
            Write-Colour "See the following link for more information: ","`nhttps://ibps.readthedocs.io/en/latest/#authentication-api-key" -Colour Cyan,Magenta
            break
        }
    }
}