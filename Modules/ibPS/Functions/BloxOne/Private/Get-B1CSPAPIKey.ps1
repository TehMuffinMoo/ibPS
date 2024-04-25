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
    $ApiKey = $ENV:B1APIKey
    if (!$ApiKey) {
        Write-Host "Error. Missing API Key. Store your API Key first using 'Set-ibPSConfiguration -CSPAPIKey apikey' and re-run this script." -ForegroundColor Red
        Write-Colour "See the following link for more information: ","https://ibps.readthedocs.io/en/latest/General/Set-ibPSConfiguration/" -Colour Gray,Magenta
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
            Write-Colour 'Error. Unable to decode the API Key. Please set the API Key again using: ','Set-ibPSConfiguration -CSPAPIKey <apikey>' -Colour Red,Green
            Write-Colour 'If you have recently upgraded from a version older than ','v1.9.5.0',', you will need to update your API Key.' -Colour Yellow,Red,Yellow
            Write-Colour "See the following link for more information: ","https://ibps.readthedocs.io/en/latest/General/Set-ibPSConfiguration/" -Colour Gray,Magenta
            break
        }
    }
}