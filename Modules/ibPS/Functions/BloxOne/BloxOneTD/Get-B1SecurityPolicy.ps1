function Get-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Threat Defense Security Policies

    .DESCRIPTION
        This function is used to query a list of BloxOne Threat Defense Security Policies

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER id
        Filter the results by id

    .EXAMPLE
        PS> Get-B1SecurityPolicy -Name "Remote Users"

        access_codes          : {}
        created_time          : 4/13/2023 12:03:40PM
        default_action        : action_allow
        default_redirect_name :
        description           : Remote Users Policy
        dfp_services          : {6abcdefghijklmnopqrstuvwxyz123}
        dfps                  : {654321}
        ecs                   : False
        id                    : 123456
        is_default            : False
        name                  : Remote-Users
        net_address_dfps      : {}
        network_lists         : {}
        onprem_resolve        : False
        precedence            : 63
        roaming_device_groups : {}
        rules                 : {@{action=action_redirect; data=Blacklist; redirect_name=; type=custom_list}, @{action=action_block; data=Malicious Domains; type=custom_list}, @{action=action_block; data=Newly Observed Domains; type=custom_list},
                                @{action=action_allow; data=Whitelist; type=custom_list}…}
        safe_search           : False
        scope_expr            :
        scope_tags            : {}
        tags                  :
        updated_time          : 9/6/2023 10:22:29PM
        user_groups           : {}

    .FUNCTIONALITY
        BloxOneDDI

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
      [Parameter(ParameterSetName="Default")]
      [String[]]$Fields,
      [parameter(ParameterSetName="Default")]
      [String]$tfilter,
      [parameter(ParameterSetName="Default")]
      [Switch]$Strict,
      [parameter(ParameterSetName="Default")]
      $CustomFilters,
      [parameter(ParameterSetName="With ID")]
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
    if ($id) {
        $Filters.Add("id==$id") | Out-Null
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
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}