function Get-B1Object {
    <#
    .SYNOPSIS
        Generic Wrapper for interaction with the CSP (Cloud Services Portal) via GET requests

    .DESCRIPTION
        This is a Generic Wrapper for getting objects from the BloxOne CSP (Cloud Services Portal).

    .PARAMETER Product
        Specify the product to use

    .PARAMETER App
        Specify the App to use

    .PARAMETER Endpoint
        Specify the API Endpoint to use, such as "/ipam/record".

    .PARAMETER Filters
        Specify one or more filters to use. Requires object input

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .EXAMPLE
        Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('name_in_zone~"webserver" or absolute_zone_name=="mydomain.corp." and type=="caa"') -tfilter '("Site"=="New York")' -Limit 100

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Product,
      [Parameter(Mandatory=$true)]
      [String]$App,
      [Parameter(Mandatory=$true)]
      [String]$Endpoint,
      [System.Object]$Filters,
      [String]$tfilter,
      [Int]$Limit,
      [Int]$Offset
    )

    ## Get Saved CSP URL
    $B1CSPUrl = Get-B1CSPUrl

    $BasePath = (Query-CSP GET "https://csp.infoblox.com/apidoc/docs/$($PSBoundParameters['App'])").basePath
    $BasePath = $BasePath.Substring(0,$BasePath.length-1)

    [System.Collections.ArrayList]$QueryFilters = @()
    [System.Collections.ArrayList]$B1Filters = @()
    if ($Limit) {
        $QueryFilters.Add("_limit=$Limit") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($Filters) {
        foreach ($Filter in $Filters) {
            $B1Filters.Add("$($Filter)") | Out-Null
        }
        $QueryFilters.Add("_filter="+(Combine-Filters $B1Filters)) | Out-Null
    }
    
    if ($tfilter) {
      $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    $QueryString = ConvertTo-QueryString $QueryFilters
    $Uri = "$($B1CSPUrl)$($BasePath)$($Endpoint)$($QueryString)" -replace "\*","``*"

    Query-CSP -Method GET -Uri $Uri | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
}