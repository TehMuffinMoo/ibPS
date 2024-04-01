function Get-B1IPAMChild {
    <#
    .SYNOPSIS
        Retrieves a list of child objects from IPAM

    .DESCRIPTION
        This function is used to query a list of child objects from IPAM, relating to a specific parent.

        This accepts pipeline input from Get-B1Space, Get-B1AddressBlock, Get-B1Subnet & Get-B1Range

    .PARAMETER Type
        Filter results by the object type

    .PARAMETER Label
        Filter results by the object label

    .PARAMETER Description
        Filter results by the object description

    .PARAMETER Object
        The parent object to list child objects for

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

    .PARAMETER Recurse
        Setting the -Recurse parameter will make the function perform a recursive call and append all child networks to the '.Children' value in returned objects

        This may take a long time on very large network structures.

    .PARAMETER NetworkTopology
        This does the same as: Get-B1IPAMChild | Get-B1NetworkTopology

        This uses the -Recurse parameter and so very large network structures may take a long time to generate.

    .EXAMPLE
        PS> Get-B1Space -Name "my-ipspace" | Get-B1IPAMChild

    .EXAMPLE
        PS> Get-B1AddressBlock -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild -Type 'ipam/subnet'
        
    .EXAMPLE
        PS> Get-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild -Type 'ipam/record'

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param (
        [String]$Type,
        [String]$Label,
        [String]$Description,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [Switch]$Strict = $false,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag,
        [String]$tfilter,
        [Switch]$Recurse,
        [Switch]$NetworkTopology,
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory=$true
        )]
        [System.Object[]]$Object
    )

    process {
        if ($Recurse -or $($NetworkTopology)) {
            if ($Recurse) {
                Write-Host "Performing recursive search. This may take a moment.." -ForegroundColor Magenta
                Build-TopologyChildren($Object)
                return $Object
            } elseif ($NetworkTopology) {
                Get-B1NetworkTopology($Object)
                return $null
            }
        }
        $MatchType = Match-Type $Strict
        $PermittedInputs = "ip_space","address_block","subnet","range"
        if (($Object.id.split('/')[1]) -notin $PermittedInputs) {
            Write-Error "Error. Unsupported pipeline object. Supported inputs are ip_space, address_block, subnet & range"
            return $null
        }

        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($Type) {
            $Filters.Add("type$($MatchType)`"$($Type)`"") | Out-Null
        }
        if ($Label) {
            $Filters.Add("label$($MatchType)`"$($Label)`"") | Out-Null
        }
        if ($Description) {
            $Filters.Add("description$($MatchType)`"$($Description)`"") | Out-Null
        }
        if ($Filters) {
            $Filter = Combine-Filters $Filters
            $QueryFilters.Add("_filter=$Filter") | Out-Null
        }
        $QueryFilters.Add("node=$($Object.id)") | Out-Null
        $QueryFilters.Add("view=SPACE") | Out-Null
        if ($Limit) {
            $QueryFilters.Add("_limit=$Limit") | Out-Null
        }
        if ($Offset) {
            $QueryFilters.Add("_offset=$Offset") | Out-Null
        }
        if ($Fields) {
            $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
        }
        if ($OrderBy) {
            $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
        }
        if ($OrderByTag) {
            $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
        }
        if ($tfilter) {
            $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
        }
        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }

        if ($QueryString) {
            Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/htree$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/htree" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
    }
}