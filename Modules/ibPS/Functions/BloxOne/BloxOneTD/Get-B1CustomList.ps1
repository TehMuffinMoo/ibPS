function Get-B1CustomList {
    <#
    .SYNOPSIS
        Retrieves a Custom List from BloxOne Threat Defense

    .DESCRIPTION
        This function is used to retrieve named lists from BloxOne Threat Defense. These are referred to and displayed as Custom Lists within the CSP.

    .PARAMETER Name
        Filter results by Name. Whilst this is here, the API does not currently support filtering by name. (01/04/24)

    .PARAMETER Description
        Filter results by Description. Whilst this is here, the API does not currently support filtering by description. (01/04/24)

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

    .PARAMETER id
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists/$($id)$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
    
        if ($ReturnItems) {
            $Results = $Results | Get-B1CustomList
        }
    
        if ($Results) {
            return $Results
        }
    }
}