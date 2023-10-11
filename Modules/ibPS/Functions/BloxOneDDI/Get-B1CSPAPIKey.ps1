function Get-B1CSPAPIKey {
    <#
    .SYNOPSIS
        Retrieves the stored BloxOneDDI API Key from the local machine, if available.

    .DESCRIPTION
        This function will retrieve the saved BloxOneDDI API Key from the local user/machine if it has previously been stored.

    .PARAMETER NoBreak
        If this is set, the function will not break if the API Key is not found

    .Example
        Get-B1CSPAPIKey

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
      [switch]$NoBreak = $false
    )
    $ApiKey = $ENV:B1APIKey
    if (!$ApiKey) {
        Write-Host "Error. Missing API Key. Store your API Key first using the Store-B1CSPAPIKey Cmdlet and re-run this script." -ForegroundColor Red
        if (!($NoBreak)) {
            break
        }
    }
    return $ApiKey
}