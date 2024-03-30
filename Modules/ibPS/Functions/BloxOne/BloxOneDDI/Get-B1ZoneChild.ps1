function Get-B1ZoneChild {
    <#
    .SYNOPSIS
        Retrieves a list of child objects from a DNS View or Zone

    .DESCRIPTION
        This function is used to query a list of child objects from a DNS View or Zone.

        This accepts pipeline input from Get-B1DNSView, Get-B1AuthoritativeZone & Get-B1ForwardZone

    .PARAMETER id
        The ID of the parent DNS View or Zone to list child objects for

    .PARAMETER Flat
        Specify the -Flat parameter to return the children as a recursive flat list

    .PARAMETER Limit
        Limits the number of results returned, the default is 100

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .EXAMPLE
        PS> Get-B1DNSView -Name "my-dnsview" | Get-B1ZoneChild

    .EXAMPLE
        PS> Get-B1AuthoritativeZone -FQDN "my.dns.zone" | Get-B1ZoneChild
        
    .EXAMPLE
        PS> Get-B1ForwardZone -FQDN "my.dns.zone" | Get-B1ZoneChild

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param (
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
        )]
        [String]$ID,
        [Switch]$Flat,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag
    )

    process {
        $PermittedInputs = "view","auth_zone","forward_zone"
        if (($ID.split('/')[1]) -notin $PermittedInputs) {
            Write-Error "Error. Unsupported pipeline object. Supported inputs are view, auth_zone & forward_zone"
            return $null
        }

        if ($Limit) {
        $LimitString = "_limit=$($Limit)&"
        }
        if ($Flat) {
            $FlatVar = "true"
        } else {
            $FlatVar = "false"
        }

        [System.Collections.ArrayList]$QueryFilters = @()
        $QueryFilters.Add("_filter=flat==`"$($FlatVar)`" and parent==`"$($ID)`"") | Out-Null
        $QueryFilters.Add("node=$ID") | Out-Null
        $QueryFilters.Add("view=SPACE") | Out-Null
        if ($Limit) {
            $QueryFilters.Add("_limit=$Limit") | Out-Null
        }
        if ($Offset) {
            $QueryFilters.Add("_offset=$Offset") | Out-Null
        }
        if ($Fields) {
            $Fields += "id"
            $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
        }
        if ($OrderBy) {
            $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
        }
        if ($OrderByTag) {
            $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
        }
        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }

        if ($QueryString) {
            Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/zone_child$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/zone_child" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
    }
}