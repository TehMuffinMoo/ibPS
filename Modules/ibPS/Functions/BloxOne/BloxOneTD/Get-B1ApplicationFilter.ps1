function Get-B1ApplicationFilter {
    <#
    .SYNOPSIS
        Retrieves an Application Filter from BloxOne Threat Defense

    .DESCRIPTION
        This function is used to retrieve application filter(s) from BloxOne Threat Defense. These are referred to and displayed as 'App Filters' within the CSP.

    .PARAMETER Name
        Filter results by Name.

    .PARAMETER Description
        Filter results by Description.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

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
      [parameter(ParameterSetName="Default")]
      [String]$Name,
      [parameter(ParameterSetName="Default")]
      [String]$Description,
      [Parameter(ParameterSetName="Default")]
      [Int]$Limit,
      [Parameter(ParameterSetName="Default")]
      [Int]$Offset,
      [String[]]$Fields,
      [Parameter(ParameterSetName="Default")]
      [String]$OrderBy,
      [Parameter(ParameterSetName="Default")]
      [String]$OrderByTag,
      [parameter(ParameterSetName="Default")]
      [Switch]$Strict,
      [parameter(ParameterSetName="Default")]
      $CustomFilters,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
        $MatchType = Match-Type $Strict

        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($CustomFilters) {
            $Filters.Add($CustomFilters)
        }
        if ($Name) {
            $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
        }
        if ($Description) {
            $Filters.Add("description$($MatchType)`"$Description`"") | Out-Null
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
        if ($id) {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/application_filters/$($id)$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/application_filters$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
    
        if ($Results) {
            return $Results
        }
    }
}