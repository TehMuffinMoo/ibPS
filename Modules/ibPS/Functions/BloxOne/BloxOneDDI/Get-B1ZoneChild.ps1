function Get-B1ZoneChild {
    <#
    .SYNOPSIS
        Retrieves a list of child objects from a DNS View or Zone

    .DESCRIPTION
        This function is used to query a list of child objects from a DNS View or Zone.

        This accepts pipeline input from Get-B1DNSView, Get-B1AuthoritativeZone & Get-B1ForwardZone

    .PARAMETER Type
        Filter results by the object type

    .PARAMETER Name
        Filter results by the object name

    .PARAMETER Description
        Filter results by the object description

    .PARAMETER Object
        The parent object DNS View or Zone to list child objects for

    .PARAMETER Flat
        Specify the -Flat parameter to return the children as a recursive flat list

    .PARAMETER Limit
        Limits the number of results returned, the default is 100

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

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
        [String]$Type,
        [String]$Name,
        [String]$Description,
        [Switch]$Flat,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [Switch]$Strict = $false,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag,
        [String]$tfilter,
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory=$true
        )]
        [System.Object]$Object
    )

    process {
        $MatchType = Match-Type $Strict
        $PermittedInputs = "view","auth_zone","forward_zone"
        if (($Object.id.split('/')[1]) -notin $PermittedInputs) {
            Write-Error "Error. Unsupported pipeline object. Supported inputs are view, auth_zone & forward_zone"
            return $null
        }

        if ($Flat) {
            $FlatVar = "true"
        } else {
            $FlatVar = "false"
        }

        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($Type) {
            $Filters.Add("type$($MatchType)`"$($Type)`"") | Out-Null
        }
        if ($Name) {
            $Filters.Add("absolute_name$($MatchType)`"$($Name)`"") | Out-Null
        }
        if ($Description) {
            $Filters.Add("comment$($MatchType)`"$($Description)`"") | Out-Null
        }
        if ($Flat) {
            $Filters.Add("flat==`"$($FlatVar)`"") | Out-Null
        }
        $Filters.Add("parent==`"$($Object.id)`"") | Out-Null
        if ($Filters) {
            $Filter = Combine-Filters $Filters
            $QueryFilters.Add("_filter=$Filter") | Out-Null
        }
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