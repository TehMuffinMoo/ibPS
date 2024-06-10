function Get-B1CloudProvider {
    <#
    .SYNOPSIS
        Retrieves a list of configured cloud discovery providers

    .DESCRIPTION
        This function is used to query a list of configured cloud discovery providers

    .PARAMETER Name
        The name of the cloud discovery provider to filter by

    .PARAMETER Description
        The description of the cloud discovery provider to filter by

    .PARAMETER Type
        The cloud discovery provider type to filter by (i.e AWS, GCP or Azure)

    .PARAMETER Status
        The cloud discovery provider status to filter by (i.e Disabled, Error, Pending & Synced)

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

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
        Use this parameter to query a particular provider id

    .EXAMPLE
        PS> Get-B1CloudProvider -Name "Azure Discovery"
    
    .EXAMPLE
        PS> Get-B1CloudProvider -Type AWS

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [String]$Name,
        [String]$Description,
        [ValidateSet('Azure','AWS','GCP')]
        [String]$Type,
        [ValidateSet('Synced','Pending','Error','Disabled')]
        [String]$Status,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [String[]]$Fields,
        [String]$OrderBy,
        [Switch]$Strict = $false,
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
        $Filters.Add("description$MatchType$Description") | Out-Null
    }
    if ($Type) {
        Switch($Type) {
            "Azure" {
                $SelectedType = "Microsoft Azure"
            }
            "AWS" {
                $SelectedType = "Amazon Web Services"
            }
            "GCP" {
                $SelectedType = "Google Cloud Platform"
            }
        }
        $Filters.Add("provider_type:=`"$SelectedType`"") | Out-Null
    }
    if ($Status) {
        $Filters.Add("status$MatchType`"$Status`"") | Out-Null
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
    if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($id) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/cloud_discovery/v2/providers/$($id)" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    } elseif ($QueryString) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/cloud_discovery/v2/providers$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/cloud_discovery/v2/providers" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}