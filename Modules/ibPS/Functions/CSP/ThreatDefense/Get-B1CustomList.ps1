function Get-B1CustomList {
    <#
    .SYNOPSIS
        Retrieves a Custom List from Infoblox Threat Defense

    .DESCRIPTION
        This function is used to retrieve named lists from Infoblox Threat Defense. These are referred to and displayed as Custom Lists within the CSP.

    .PARAMETER Name
        Filter results by Name.

    .PARAMETER Description
        Filter results by Description.

    .PARAMETER Type
        Filter results by type.

    .PARAMETER ReturnItems
        Optionally return the list of domains contained within the Named List. Only required when -id is not specified.

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
        PS> Get-B1CustomList -Type 'zero_day_dns' -ReturnItems

        confidence_level : HIGH
        created_time     : 4/29/2024 3:45:51 PM
        description      : Auto-generated
        id               : 797118
        item_count       : 3
        items            : {123moviess.mom, auto-bg.info, cap-caps.shop}
        items_described  : {@{description=; item=123moviess.mom}, @{description=; item=auto-bg.info}, @{description=; item=cap-caps.shop}}
        name             : Threat Insight - Zero Day DNS
        policies         : {corporate-policy}
        tags             :
        threat_level     : HIGH
        type             : zero_day_dns
        updated_time     : 6/12/2024 12:05:44 PM

    .EXAMPLE
        PS> Get-B1CustomList -Limit 1 -ReturnItems

        confidence_level : HIGH
        created_time     : 4/13/2023 12:51:56PM
        description      :
        id               : 123456
        item_count       : 14
        items            : {somebaddomain.com,anotherbaddomain.com, andanother...}
        items_described  : {@{description=Added from Dossier; item=somebaddomain.com},@{description=Added from Dossier; item=anotherbaddomain.com}}
        name             : main_blacklist
        policies         : {Main, Corporate}
        tags             :
        threat_level     : HIGH
        type             : custom_list
        updated_time     : 4/3/2024 9:49:28AM

    .EXAMPLE
        PS> Get-B1CustomList -id 123456

        confidence_level : HIGH
        created_time     : 4/13/2023 12:51:56PM
        description      :
        id               : 123456
        item_count       : 14
        items            : {somebaddomain.com,anotherbaddomain.com, andanother...}
        items_described  : {@{description=Added from Dossier; item=somebaddomain.com},@{description=Added from Dossier; item=anotherbaddomain.com}}
        name             : main_blacklist
        policies         : {Main, Corporate}
        tags             :
        threat_level     : HIGH
        type             : custom_list
        updated_time     : 4/3/2024 9:49:28AM

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Name,
      [parameter(ParameterSetName="Default")]
      [String]$Description,
      [parameter(ParameterSetName="Default")]
      [String]$Type,
      [Parameter(ParameterSetName="Default")]
      [Switch]$ReturnItems,
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
        #$MatchType = Match-Type $Strict
        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($CustomFilters) {
            $Filters.Add($CustomFilters) | Out-Null
        }
        ## API Filtering not currently supported on this endpoint - (01/04/24)
        # if ($Name) {
        #     $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
        # }
        # if ($Description) {
        #     $Filters.Add("description$($MatchType)`"$Description`"") | Out-Null
        # }
        if  ($Type) {
            $Filters.Add("type==`"$Type`"") | Out-Null
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
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists/$($id)$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }

        ## Temporary Workaround to API Filtering Limitations. This ensures -Name & -Description can still be used, but filtering is performed by Powershell instead of the API.
        if ($Name) {
            if ($Strict) {
                $Results = $Results | Where-Object {$_.name -eq $Name}
            } else {
                $Results = $Results | Where-Object {$_.name -like "*$($Name)*"}
            }
        }
        if ($Description) {
            if ($Strict) {
                $Results = $Results | Where-Object {$_.description -eq $Description}
            } else {
                $Results = $Results | Where-Object {$_.description -like "*$($Description)*"}
            }
        }

        if ($ReturnItems) {
            $Results = $Results | Get-B1CustomList
        }

        if ($Results) {
            return $Results
        }
    }
}