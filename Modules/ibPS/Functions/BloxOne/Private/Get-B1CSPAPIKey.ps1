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
        Write-Colour "See the following link for more information: ","https://ibps.readthedocs.io/en/latest/General/Set-ibPSConfiguration/" -Colour Black,Magenta
        return $null
    } else {
        $Bytes = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($ApiKey))
        $B1APIKey = $Bytes | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText
        if ($B1APIKey) {
            return $ApiKey
        } else {
            Write-Error 'Unable to decode the API Key. Please set the API Key again using Set-ibPSConfiguration -CSPAPIKey <apikey>'
            Write-Colour "See the following link for more information: ","https://ibps.readthedocs.io/en/latest/General/Set-ibPSConfiguration/" -Colour Black,Magenta
        }
    }
}