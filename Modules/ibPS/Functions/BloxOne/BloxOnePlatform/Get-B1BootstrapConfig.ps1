﻿function Get-B1BootstrapConfig {
    <#
    .SYNOPSIS
        Retrieves the bootstrap configuration for a BloxOneDDI Host

    .DESCRIPTION
        This function is used to retrieve the bootstrap configuration for a BloxOneDDI Host

    .PARAMETER B1Host
        The name of the BloxOneDDI host to query the bootstrap config for

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER GetConfig
        Specify the -GetConfig parameter to return only the BloxOne Hosts current config

    .EXAMPLE
        PS> Get-B1BootstrapConfig -B1Host "myonpremhost.corp.domain.com"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Host
    #>
    param(
        [String]$B1Host,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [String[]]$Fields,
        [Switch]$GetConfig,
        [Switch]$Strict = $false
    )

    process {
        $MatchType = Match-Type $Strict
        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($B1Host) {
            $Filters += "display_name$($MatchType)`"$($B1Host)`""
        }
        if ($Filters) {
            $Filter = Combine-Filters $Filters
            $QueryFilters.Add("_filter=$Filter") | Out-Null
        }
        $QueryFilters.Add("_limit=$Limit") | Out-Null
        $QueryFilters.Add("_offset=$Offset") | Out-Null
        if ($Fields) {
            $Fields += "id"
            $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
        }
        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }

        if ($QueryString) {
            $Results = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/atlas-bootstrap-app/v1/hosts$($QueryString)"
        } else {
            $Results = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/atlas-bootstrap-app/v1/hosts"
        }
        if ($GetConfig) {
            return $Results | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue | Select-Object -ExpandProperty current_config -EA SilentlyContinue -WA SilentlyContinue
        } else {
            return $Results | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
        }
    }
}
