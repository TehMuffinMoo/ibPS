function Get-B1Compartment {
    <#
    .SYNOPSIS
        Retrieves a list of Compartments from the BloxOne Cloud

    .DESCRIPTION
        This function is used to retrieve a list of Compartments from the BloxOne Cloud

    .PARAMETER Name
        Filter the results by compartment name

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default and maximum number of results is 101.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER id
        The id of the API Key to filter by

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1APIKey -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
        [String]$Name,
        [Int]$Limit,
        [Int]$Offset,
        [Switch]$Strict,
        [String[]]$Fields,
        [String]$OrderBy,
        $CustomFilters,
        [String]$id,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    $MatchType = Match-Type $Strict
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
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
        $QueryFilters.Add("_fields=$($Fields -join ",")")
    }
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$($OrderBy)") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if($PSCmdlet.ShouldProcess('List Compartments','List Compartments',$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/compartments$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        if ($Results) {
            return $Results
        }
    }
}