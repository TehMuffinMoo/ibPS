function Get-B1CustomRedirect {
    <#
    .SYNOPSIS
        Retrieves a Custom Redirects from Infoblox Threat Defense

    .DESCRIPTION
        This function is used to retrieve named redirects from Infoblox Threat Defense.

    .PARAMETER Name
        Filter results by Name.

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

    .PARAMETER id
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1CustomRedirect -Name 'guest-redirect'

        created_time : 6/18/2024 11:59:25 AM
        data         : 2.3.4.5
        id           : 1234
        name         : guest-redirect
        policy_ids   : {123456}
        policy_names : {guest-policy}
        updated_time : 6/18/2024 11:59:25 AM

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Name,
      [Parameter(ParameterSetName="Default")]
      [Int]$Limit,
      [Parameter(ParameterSetName="Default")]
      [Int]$Offset,
      [String[]]$Fields,
      [Parameter(ParameterSetName="Default")]
      [String]$OrderBy,
      [Parameter(ParameterSetName="Default")]
      $CustomFilters,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($CustomFilters) {
            $Filters.Add($CustomFilters) | Out-Null
        }
        if ($Filters) {
            $Filter = Combine-Filters $Filters
            $QueryFilters.Add("_filter=$Filter") | Out-Null
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
        if ($id) {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/custom_redirects/$($id)$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/custom_redirects$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }

        ## Temporary Workaround to API Filtering Limitations. This ensures -Limit & -Offset can still be used, but filtering is performed by Powershell instead of the API.
        if ($Limit) {
            if ($Offset) {
                $Results = $Results | Select-Object -First $Limit -Skip $Offset
            } else {
                $Results = $Results | Select-Object -First $Limit
            }
        } elseif ($Offset) {
            $Results = $Results | Select-Object -Skip $Offset
        }
        if ($Name) {
            $Results = $Results | Where-Object {$_.name -like "*$($Name)*"}
        }

        if ($Results) {
            return $Results
        }
    }
}