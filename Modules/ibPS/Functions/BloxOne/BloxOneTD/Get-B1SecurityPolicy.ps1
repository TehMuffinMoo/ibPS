﻿function Get-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Threat Defense Security Policies

    .DESCRIPTION
        This function is used to query a list of BloxOne Threat Defense Security Policies

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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
    [CmdletBinding(DefaultParameterSetName="notid")]
    param(
      [parameter(ParameterSetName="notid")]
      [String]$Name,
      [parameter(ParameterSetName="notid")]
      [Switch]$Strict,
      [parameter(ParameterSetName="With ID")]
      [String]$id
    )

	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($id) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies/$id" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } elseif ($Filter) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}