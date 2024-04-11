function Search-B1 {
    <#
    .SYNOPSIS
        Query the BloxOneDDI CSP Global Search

    .DESCRIPTION
        This function is used to query the BloxOneDDI CSP Global Search

    .PARAMETER Query
        Search query

    .PARAMETER IncludeQueryDetails
        Use this parameter to include the query shard, aggregation, state, and duration data.
        By default, the hits property is auto-expanded

    .EXAMPLE
        PS> Search-B1 "10.10.100.1"

    .EXAMPLE
        PS> Search-B1 "mysubzone.corp.com"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Search
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String]$Query,
        [Switch]$IncludeQueryDetails
    )

    $Body = @{
      "query"=$Query
    } | ConvertTo-Json | % { [System.Text.RegularExpressions.Regex]::Unescape($_)}
    $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/atlas-search-api/v1/search" -Method "POST" -Data $Body
    if ($IncludeQueryDetails) {
        $Results        
    } else {
        $Results.hits | Select-Object -ExpandProperty hits
    }
}