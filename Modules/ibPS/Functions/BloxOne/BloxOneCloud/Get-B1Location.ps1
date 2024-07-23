function Get-B1Location {
    <#
    .SYNOPSIS
        Retrieves a list of Locations defined within BloxOne Cloud

    .DESCRIPTION
        This function is used to retrieve a list of Locations defined within BloxOne Cloud

    .PARAMETER Name
        Filter the results by the name of the Location

    .PARAMETER Description
        Filter the results by the description of the Location

    .PARAMETER Address
        Filter the results by the location address

    .PARAMETER City
        Filter the results by the location city

    .PARAMETER State
        Filter the results by the location state/county

    .PARAMETER PostCode
        Filter the results by the location zip/postal code

    .PARAMETER Country
        Filter the results by the location country

    .PARAMETER ContactEmail
        Filter the results by the location contact email address

    .PARAMETER ContactName
        Filter the results by the location contact name

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER id
        The id of the Location to filter by

    .EXAMPLE
        PS> Get-B1Location -Name "Madrid"

        address      : @{address=Santiago Bernabeu Stadium, 1, Avenida de Concha Espina, Hispanoamérica, Chamartín; city=Madrid; country=Spain; postal_code=28036; state=Community of Madrid}
        contact_info : @{email=Curator@realmadrid.com; name=Curator}
        created_at   : 2024-05-01T12:22:09.849259517Z
        description  : Real Madrid Museum
        id           : infra/location/fsf44f43g45gh45h4g34tgvgrdh6jtrhbcx
        latitude     : 40.4530225
        longitude    : -3.68742195874704
        name         : Madrid
        updated_at   : 2024-05-01T12:22:09.849259517Z

    .FUNCTIONALITY
        BloxOneDDI
    #>
    [CmdletBinding()]
    param(
        [String]$Name,
        [String]$Description,
        [String]$Address,
        [String]$City,
        [String]$State,
        [String]$PostCode,
        [String]$Country,
        [String]$ContactEmail,
        [String]$ContactName,
        [Int]$Limit = 1000,
        [Int]$Offset = 0,
        [Switch]$Strict,
        [String[]]$Fields,
        [String]$OrderBy,
        [String]$OrderByTag,
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
        $Filters.Add("description$MatchType`"$Description`"") | Out-Null
    }
    if ($Address) {
        $Filters.Add("address.address$MatchType`"$Address`"") | Out-Null
    }
    if ($City) {
        $Filters.Add("address.city$MatchType`"$City`"") | Out-Null
    }
    if ($State) {
        $Filters.Add("address.state$MatchType`"$State`"") | Out-Null
    }
    if ($PostCode) {
        $Filters.Add("address.postal_code$MatchType`"$PostCode`"") | Out-Null
    }
    if ($Country) {
        $Filters.Add("address.country$MatchType`"$Country`"") | Out-Null
    }
    if ($ContactName) {
        $Filters.Add("contact_info.name$MatchType`"$ContactName`"") | Out-Null
    }
    if ($ContactEmail) {
        $Filters.Add("contact_info.email$MatchType`"$ContactEmail`"") | Out-Null
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
    if ($OrderByTag) {
        $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
    }
    $CombinedFilter += ConvertTo-QueryString($QueryFilters)

    Write-DebugMsg -Filters $QueryFilters

    $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/locations$CombinedFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }
}