function Get-B1Endpoint {
    <#
    .SYNOPSIS
        Retrieves a list of Infoblox Endpoints from Infoblox Threat Defense.

    .DESCRIPTION
        This function is used to retrieve a list of Infoblox Endpoints from Infoblox Threat Defense.

    .PARAMETER Name
        Filter results by Device Name.

    .PARAMETER Status
        Filter results by Device Status.

    .PARAMETER Username
        Filter results by Username.

    .PARAMETER EndpointGroup
        Filter results by the associated Endpoint Group.

    .PARAMETER MACAddress
        Filter devices by MAC Address

    .PARAMETER EndpointVersion
        Filter devices by the endpoint version

    .PARAMETER OSType
        Filter devices by OS Type

    .PARAMETER OSVersion
        Filter devices by the OS version

    .PARAMETER SerialNumber
        Filter devices by the Serial Number

    .PARAMETER LastIPAddress
        Filter devices by the Last Known IP Address.

    .PARAMETER Country
        Filter devices by the associated Country

    .PARAMETER Limit
        Use this parameter to limit the quantity of results.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

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
        PS>

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [String]$Name,
      [ValidateSet('Active','Inactive','Disabled')]
      [String]$Status,
      [String]$Username,
      [String]$EndpointGroup,
      [String]$MACAddress,
      [String]$EndpointVersion,
      [String]$OSVersion,
      [String]$SerialNumber,
      [String]$LastIPAddress,
      [String]$Country,
      [Int]$Limit,
      [Int]$Offset,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      [Switch]$Strict,
      $CustomFilters,
      [Switch]$CaseSensitive,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
        $MatchType = Match-Type $Strict $CaseSensitive

        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($CustomFilters) {
            $Filters.Add($CustomFilters) | Out-Null
        }
        if ($Name) {
            $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
        }
        if ($Status) {
            $Filters.Add("calculated_status:=`"$Status`"") | Out-Null
        }
        if ($Username) {
            $Filters.Add("user_id$($MatchType)`"$Username`"") | Out-Null
        }
        if ($EndpointGroup) {
            $Filters.Add("group_name$($MatchType)`"$EndpointGroup`"") | Out-Null
        }
        if ($MACAddress) {
            $Filters.Add("mac_address$($MatchType)`"$MACAddress`"") | Out-Null
        }
        if ($EndpointVersion) {
            $Filters.Add("version$($MatchType)`"$EndpointVersion`"") | Out-Null
        }
        if ($OSVersion) {
            $Filters.Add("os_platform$($MatchType)`"$OSVersion`"") | Out-Null
        }
        if ($SerialNumber) {
            $Filters.Add("serial_number$($MatchType)`"$SerialNumber`"") | Out-Null
        }
        if ($LastIPAddress) {
            $Filters.Add("ip_address$($MatchType)`"$LastIPAddress`"") | Out-Null
        }
        if ($Country) {
            $Filters.Add("country_name:=`"$Country`"") | Out-Null
        }
        if ($id) {
            $Filters.Add("id==`"$id`"") | Out-Null
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
        if ($tfilter) {
            $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
        }
        if ($Fields) {
            $Fields += "id"
            $QueryFilters += "_fields=$($Fields -join ",")"
        }
        if ($OrderBy) {
            $QueryFilters += "_order_by=$($OrderBy)"
        }
        if ($OrderByTag) {
            $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
        }
        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }
        Write-DebugMsg -Filters $Filters
        if ($QueryString) {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcep/v1/roaming_devices$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/roaming_devices" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }

        if ($Results) {
            return $Results
        }
    }
}