function Get-B1Schema {
    <#
    .SYNOPSIS
        Used for obtaining API Schema information for use with generic wrapper cmdlets

    .DESCRIPTION
        This is used for obtaining API Schema information for use with generic wrapper cmdlets

    .PARAMETER Product
        Specify the product to use

    .PARAMETER App
        Specify the App to use

    .PARAMETER Endpoint
        Specify the API Endpoint to use, such as "/ipam/record".

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
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [String]$Method,
      [Switch]$ListParameters
    )

    ## Get Saved CSP URL
    $B1CSPUrl = Get-B1CSPUrl

    $BasePath = (Query-CSP GET "$($B1CSPUrl)/apidoc/docs/$($PSBoundParameters['App'])").basePath
    if ($BasePath) {
        $BasePath = $BasePath.Substring(0,$BasePath.length-1)
    } else {
        $BasePath = $null
    }

    $Uri = "$(Get-B1CSPUrl)/apidoc/docs/$($PSBoundParameters['App'])"

    $Results = Query-CSP -Method GET -Uri $Uri
    if ($Results) {
        $Return = (($Results.paths.psobject.properties | ForEach-Object -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}).GetEnumerator() | Where-Object {$_.Name -eq $($PSBoundParameters['Endpoint'])}).Value | Select-Object -ExpandProperty $($Method)
        if ($ListParameters) {
            $Return.parameters | ft name,type,description -Wrap
        } else {
            $Return
        }
    }
}