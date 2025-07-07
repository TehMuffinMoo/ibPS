function Get-B1NetworkList {
    <#
    .SYNOPSIS
        Retrieves network lists (External Networks) from Infoblox Threat Defense

    .DESCRIPTION
        This function is used to retrieve network lists from Infoblox Threat Defense. These are referred to and displayed as "External Networks" within the CSP.

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Description
        Filter results by Description

    .PARAMETER PolicyID
        Filter results by policy_id

    .PARAMETER DefaultSecurityPolicy
        Filter results by those assigned to the default security policy

    .PARAMETER Limit
        Use this parameter to limit the quantity of results.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER CaseSensitive
        Use Case Sensitive matching. By default, case-insensitive matching both for -Strict matching and regex matching.

    .PARAMETER id
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1NetworkList -Name "something"

        created_time : 12/23/2021 9:29:20AM
        description  : something
        id           : 123456
        items        : {88.88.88.88/32}
        name         : something
        policy_id    : 654321
        updated_time : 9/6/2023 9:49:10PM

    .EXAMPLE
        PS> Get-B1NetworkList | ft -AutoSize

        created_time          description                                            id items                                                                     name                               policy_id updated_time
        ------------          -----------                                            -- -----                                                                     ----                               --------- ------------
        7/5/2020 5:02:01PM    Site A Network List                                123456 {1.2.3.4/32, 1.0.0.0/29, 134.1.2.3/32…}                                   site-a-network                         12345 1/27/2024 2:23:21PM
        7/21/2020 10:36:16AM  Site B Network List                                234567 {9.4.2.6/32}                                                              site-b-network                         23456 10/13/2023 11:26:51AM
        10/7/2020 6:37:33PM   Site C Network List                                345678 {123.234.123.234}                                                         site-c-network                         34567 9/6/2023 9:53:51PM
        ...

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Name,
      [parameter(ParameterSetName="Default")]
      [String]$Description,
      [parameter(ParameterSetName="Default")]
      [Int]$PolicyID,
      [parameter(ParameterSetName="Default")]
      [Switch]$DefaultSecurityPolicy,
      [Parameter(ParameterSetName="Default")]
      [Int]$Limit,
      [Parameter(ParameterSetName="Default")]
      [Int]$Offset,
      [Parameter(ParameterSetName="Default")]
      [String[]]$Fields,
      [Parameter(ParameterSetName="Default")]
      [String]$OrderBy,
      [parameter(ParameterSetName="With ID")]
      [Int]$id,
      [parameter(ParameterSetName="Default")]
      [Switch]$Strict,
      [parameter(ParameterSetName="Default")]
      $CustomFilters,
      [parameter(ParameterSetName="Default")]
      [Switch]$CaseSensitive
    )

    $MatchType = Match-Type $Strict $CaseSensitive

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("description$($MatchType)`"$Description`"") | Out-Null
    }
    if ($PolicyID) {
        $Filters.Add("policy_id==$PolicyID") | Out-Null
    }
    if ($DefaultSecurityPolicy) {
        $Filters.Add("default_security_policy==`"$DefaultSecurityPolicy`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==$id") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters -CaseSensitive:$CaseSensitive
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
        $QueryFilters += "_fields=$($Fields -join ",")"
    }
    if ($OrderBy) {
        $QueryFilters += "_order_by=$($OrderBy)"
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $Filters
    if ($QueryString) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}