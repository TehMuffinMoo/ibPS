function Get-B1ThirdPartyProvider {
    <#
    .SYNOPSIS
        Retrieves a list of configured third party DNS & IPAM providers

    .DESCRIPTION
        This function is used to query a list of configured third party DNS & IPAM providers.

    .PARAMETER Name
        The name of the provider to filter by

    .PARAMETER Description
        The description of the provider to filter by

    .PARAMETER Type
        The provider type to filter by (i.e DNS or IPAM)

    .PARAMETER Vendor
        The vendor of the provider to filter by (i.e Microsoft Active Directory)

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER id
        Use this parameter to query a particular provider id

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1ThirdPartyProvider -Name "corp.domain"

    .EXAMPLE
        PS> Get-B1ThirdPartyProvider -Type IPAM/DHCP

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
        [String]$Name,
        [String]$Description,
        [ValidateSet('DNS','IPAM/DHCP')]
        [String]$Type,
        [String]$Vendor,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [String[]]$Fields,
        [String]$OrderBy,
        [Switch]$Strict = $false,
        $CustomFilters,
        [String]$id
    )
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("description$MatchType$Description") | Out-Null
    }
    if ($Type) {
        $Filters.Add("service_type==`"$Type`"") | Out-Null
    }
    if ($Vendor) {
        $Filters.Add("provider_type$MatchType`"$Vendor`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
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
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($id) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/dns/v1/provider_integration/$($id)" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    } elseif ($QueryString) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/dns/v1/provider_integration$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/dns/v1/provider_integration" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}