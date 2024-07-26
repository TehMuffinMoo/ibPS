function Get-B1Object {
    <#
    .SYNOPSIS
        Generic Wrapper for interaction with the CSP (Cloud Services Portal) via GET requests

    .DESCRIPTION
        This is a Generic Wrapper for getting objects from the BloxOne CSP (Cloud Services Portal).

    .PARAMETER Product
        Specify the product to use, such as 'BloxOne DDI'.
        This parameter is auto-populated when using tab

    .PARAMETER App
        Specify the App to use, such as 'DnsConfig'
        This parameter is auto-populated when using tab

    .PARAMETER Endpoint
        Specify the API Endpoint to use, such as "/ipam/record".
        This parameter is auto-populated when using tab

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER Filters
        Specify one or more filters to use. Requires object input

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER CaseSensitive
        Use Case Sensitive matching for the filters

    .EXAMPLE
        PS> Get-B1Object -Product 'BloxOne DDI' -App DnsConfig -Endpoint /dns/record -Filters @('name_in_zone~"webserver" or absolute_zone_name=="mydomain.corp." and type=="caa"') -tfilter '("Site"=="New York")' -Limit 100

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Product,
      [Parameter(Mandatory=$true)]
      [String]$App,
      [Parameter(Mandatory=$true)]
      [String]$Endpoint,
      [String[]]$Fields,
      [System.Object]$Filters,
      [String]$tfilter,
      [Int]$Limit,
      [Int]$Offset,
      [Switch]$CaseSensitive
    )

    ## Get Saved CSP URL
    $B1CSPUrl = Get-B1CSPUrl

    $BasePath = Get-B1Schema -Product $Product -App $App -Quiet -GetBasePath

    [System.Collections.ArrayList]$QueryFilters = @()
    [System.Collections.ArrayList]$B1Filters = @()
    if ($Limit) {
        if ($($PSBoundParameters['App'] -eq "BloxOne Threat Defense")) {
            $QueryFilters.Add("rlimit=$Limit") | Out-Null
        } else {
            $QueryFilters.Add("_limit=$Limit") | Out-Null
        }
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($Filters) {
        foreach ($Filter in $Filters) {
            $B1Filters.Add("$($Filter)") | Out-Null
        }
        $QueryFilters.Add("_filter="+(Combine-Filters $B1Filters -CaseSensitive:$CaseSensitive)) | Out-Null
    }

    if ($tfilter) {
      $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }

    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }

    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    $Uri = "$($B1CSPUrl)$($BasePath)$($Endpoint)$($QueryString)" -replace "\*","``*"
    $Results = Invoke-CSP -Method GET -Uri $Uri
    if ($Results.results -ne $null) {
        $Results = $Results | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
    } elseif ($Results.result -ne $null) {
        $Results = $Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
    }
    $Results | Add-Member -MemberType NoteProperty "_ref" -Value "$($B1CSPUrl)$($BasePath)"
    $Results
}