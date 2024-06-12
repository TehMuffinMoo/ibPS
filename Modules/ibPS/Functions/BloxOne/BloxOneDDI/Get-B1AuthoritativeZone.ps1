﻿function Get-B1AuthoritativeZone {
    <#
    .SYNOPSIS
        Retrieves a list of authoritative zones from BloxOneDDI

    .DESCRIPTION
        This function is used to query a list authoritative zones from BloxOneDDI

    .PARAMETER FQDN
        The fqdn of the authoritative zone to filter by

    .PARAMETER Type
        The type of authoritative zone to filter by (Primary / Secondary)

    .PARAMETER Disabled
        Filter results based on if the authoritative zone is disabled or not

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER View
        The DNS View where the authoritative zone(s) are located

    .PARAMETER Compartment
        Filter the results by Compartment Name

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

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
        The id of the authoritative zone to filter by

    .EXAMPLE
        PS> Get-B1AuthoritativeZone -FQDN "prod.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [String]$FQDN,
      [ValidateSet("Primary","Secondary")]
      [String]$Type,
      [bool]$Disabled,
      [Switch]$Strict = $false,
      [String]$View,
      [String]$Compartment,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      $CustomFilters,
      [String]$id
    )
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($View) {$ViewUUID = (Get-B1DNSView -Name $View -Strict).id}
    $MatchType = Match-Type $Strict
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($FQDN) {
        $Filters.Add("fqdn$MatchType`"$FQDN`"") | Out-Null
    }
    if ($Type) {
        switch($Type) {
            "Primary" {
                $PrimaryType = "cloud"
            }
            "Secondary" {
                $PrimaryType = "external"
            }
        }
        $Filters.Add("primary_type==`"$PrimaryType`"") | Out-Null
    }
    if ($Disabled) {
        $Filters.Add("disabled==`"$Disabled`"") | Out-Null
    }
    if ($ViewUUID) {
        $Filters.Add("view==`"$ViewUUID`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Compartment) {
        $CompartmentID = (Get-B1Compartment -Name $Compartment -Strict).id
        if ($CompartmentID) {
            $Filters.Add("compartment_id==`"$CompartmentID`"") | Out-Null
        } else {
            Write-Error "Unable to find compartment with name: $($Compartment)"
            return $null
        }
    }
    $Filter = Combine-Filters $Filters
    if ($Filter) {
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
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
    }
    if ($OrderByTag) {
        $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
    }
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($QueryString) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/auth_zone$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/auth_zone?_limit=$Limit&_offset=$Offset" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}