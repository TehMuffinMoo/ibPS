function Get-B1Licenses {
    <#
    .SYNOPSIS
        Retrieves a list of licenses associated with the BloxOne Account

    .DESCRIPTION
        This function is used query a list of licenses associated with the BloxOne Account

    .EXAMPLE
        PS> Get-B1Licenses -State all
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        Licenses
    #>
    param(
        [ValidateSet('all','active','expired')]
        [String]$State = "all"
    )
    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/licensing/v1/licenses?state=$($State)" | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
    
    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No BloxOne Licenses found." -ForegroundColor Red
    }
}