function Search-B1 {
    <#
    .SYNOPSIS
        Query the BloxOneDDI CSP Global Search

    .DESCRIPTION
        This function is used to query the BloxOneDDI CSP Global Search

    .PARAMETER query
        Search query

    .Example
        Search-B1 "10.10.100.1"

    .Example
        Search-B1 "mysubzone.corp.com"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Search
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$query
    )
    ## Get Stored API Key
    $B1ApiKey = Get-B1CSPAPIKey

    ## Set Headers
    $CSPHeaders = @{
        'Authorization' = "Token $B1ApiKey"
        'Content-Type' = 'application/json'
    }

    $Body = @{
      "query"=$query
    } | ConvertTo-Json | % { [System.Text.RegularExpressions.Regex]::Unescape($_)}
    $Results = Invoke-WebRequest -Uri "$(Get-B1CSPUrl)/atlas-search-api/v1/search" -Method "POST" -Headers $CSPHeaders -Body $Body -UseBasicParsing
    $Results | ConvertFrom-Json
}