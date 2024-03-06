function Get-B1TDContentCategory {
    <#
    .SYNOPSIS
        Retrieves a list of content categories from BloxOne Threat Defense

    .DESCRIPTION
        This function is used to retrieve a list of content categories from BloxOne Threat Defense

    .EXAMPLE
        PS> Get-B1TDContentCategory
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
    )

    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/content_categories" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue

    if ($Results) {
        return $Results
    }
}