function Get-B1EndpointGroup {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Endpoints from BloxOne Threat Defense.

    .DESCRIPTION
        This function is used to retrieve a list of BloxOne Endpoints from BloxOne Threat Defense.

    .PARAMETER Name
        Filter results by Endpoint Group Name

    .PARAMETER Status
        Filter results by Endpoint Group Status.

    .PARAMETER AssociatedPolicy
        Filter results by the associated policy.

    .PARAMETER BypassMode
        Filter Endpoint Groups by Bypass Mode

    .PARAMETER Inactivity
        Filter Endpoint Groups by Inactivity

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. Defaults to 1000

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
      [ValidateSet('Enabled','Disabled')]
      [String]$Status,
      [String]$AssociatedPolicy,
      [ValidateSet('Enabled','Disabled')]
      [String]$BypassMode,
      [Int]$Inactivity,
      [Int]$Limit = 1000,
      [Int]$Offset,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      [Switch]$Strict,
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
        if ($Status) {
            $Filters.Add("administrative_status:=`"$Status`"") | Out-Null
        }
        if ($AssociatedPolicy) {
            $PolicyID = (Get-B1SecurityPolicy -Name $AssociatedPolicy -Strict).id
            if ($PolicyID) {
                $Filters.Add("policy_id$($MatchType)`"$AssociatedPolicy`"") | Out-Null
            } else {
                Write-Error "Unable to find Security Policy: $($AssociatedPolicy)"
                return $null
            }
        }
        if ($BypassMode) {
            $Filters.Add("is_probe_enabled==$(if ($BypassMode -eq "Enabled") { $True } else { $False })") | Out-Null
        }
        if ($Inactivity) {
            $Filters.Add("max_inactive_days==$Inactivity") | Out-Null
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
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcep/v1/roaming_device_groups$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/roaming_device_groups" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
    
        if ($Results) {
            return $Results
        }
    }
}