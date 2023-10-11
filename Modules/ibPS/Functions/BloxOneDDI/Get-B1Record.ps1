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

    .PARAMETER id
        Use the id parameter to filter the results by ID

    .Example
        Get-B1Record -Name "myArecord" -Zone "corp.mydomain.com" -View "default" | ft name_in_zone,rdata,type
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
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
      [String]$id
    )

    $SupportedRecords = "A","CNAME","PTR","NS","TXT","SOA","SRV"
    $MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Type) {
        if ($Type -in $SupportedRecords) {
            $Filters.Add("type==`"$Type`"") | Out-Null
        } else {
            Write-Host "Invalid type specified. The following record types are supported: $SupportedRecords" -ForegroundColor Red
            break
        }
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
        if ($IncludeInheritance) {
            $Query = "?_filter=$Filter&_inherit=full"
        } else {
            $Query = "?_filter=$Filter"
        }
    } else {
        if ($IncludeInheritance) {
            $Query = "?_inherit=full"
        }
    }

    if ($Query) {
        $Result = Query-CSP -Method GET -Uri "dns/record$Query&_limit=$Limit&_offset=$Offset" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Result = Query-CSP -Method GET -Uri "dns/record?_limit=$Limit&_offset=$Offset" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($View) {
        $Result = $Result | where {$_.view_name -eq $View}
    }
    if ($Source) {
        $Result = $Result | where {$_.source -contains $Source}
    }
    $Result
}