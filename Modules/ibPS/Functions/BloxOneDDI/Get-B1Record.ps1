function Get-B1Record {
    <#
    .SYNOPSIS
        Queries DNS records from BloxOneDDI

    .DESCRIPTION
        This function is used to query DNS records from BloxOneDDI

    .PARAMETER Type
        The record type to filter by

    .PARAMETER Name
        The record name to filter by

    .PARAMETER Zone
        The record zone to filter by

    .PARAMETER rdata
        The record data to filter by

    .PARAMETER FQDN
        The record FQDN to filter by

    .PARAMETER Source
        Use this to filter by the IP address of the source making the DNS request

    .PARAMETER View
        The DNS View to filter by

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER IncludeInheritance
        Whether to include inherited properties in the results

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.
        
    .PARAMETER id
        Use the id parameter to filter the results by ID

    .EXAMPLE
        Get-B1Record -Name "myArecord" -Zone "corp.mydomain.com" -View "default" | ft name_in_zone,rdata,type
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [ValidateSet("A","AAAA","CAA","CNAME","HTTPS","MX","NAPTR","NS","PTR","SRV","SVCB","TXT")]
      [String]$Type,
      [String]$Name,
      [String]$Zone,
      [String]$rdata,
      [String]$FQDN,
      [String]$Source,
      [String]$View,
      [Switch]$Strict,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [switch]$IncludeInheritance = $false,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$id
    )

    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Type) {
      $Filters.Add("type==`"$Type`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name_in_zone$MatchType`"$Name`"") | Out-Null
    }
    if ($rdata) {
        $Filters.Add("dns_rdata$MatchType`"$rdata`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($FQDN) {
        if ($Strict) {
            if (!($FQDN.EndsWith("."))) {
                $FQDN = "$FQDN."
            }
        }
        $Filters.Add("absolute_name_spec$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Zone) {
        if ($Strict) {
            if (!($Zone.EndsWith("."))) {
                $Zone = "$Zone."
            }
        }
        $Filters.Add("absolute_zone_name$MatchType`"$Zone`"") | Out-Null
    }
    
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    $QueryFilters.Add("_limit=$Limit") | Out-Null
    $QueryFilters.Add("_offset=$Offset") | Out-Null
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($IncludeInheritance) {
        $QueryFilters.Add('_inherit=full') | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryString) {
        $Result = Query-CSP -Method GET -Uri "dns/record$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Result = Query-CSP -Method GET -Uri "dns/record?_limit=$Limit&_offset=$Offset" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($View) {
        $Result = $Result | Where-Object {$_.view_name -eq $View}
    }
    if ($Source) {
        $Result = $Result | Where-Object {$_.source -contains $Source}
    }
    $Result
}