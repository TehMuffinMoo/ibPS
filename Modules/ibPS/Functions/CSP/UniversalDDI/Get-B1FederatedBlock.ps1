function Get-B1FederatedBlock {
    <#
    .SYNOPSIS
        Queries a list of Federated Blocks from the Universal DDI IPAM

    .DESCRIPTION
        This function is used to query a list of Federated Blocks from the Universal DDI IPAM

    .PARAMETER Subnet
        Use this parameter to filter the list of Federated Blocks by network address

    .PARAMETER CIDR
        Use this parameter to filter the list of Federated Blocks by CIDR suffix

    .PARAMETER Protocol
        Use this parameter to filter the list of Federated Blocks by protocol

    .PARAMETER Name
        Use this parameter to filter the list of Federated Blocks by name

    .PARAMETER Description
        Use this parameter to filter the list of Federated Blocks by description

    .PARAMETER Realm
        Use this parameter to filter the list of Federated Blocks by federated realm

    .PARAMETER Pool
        Use this parameter to filter the list of Federated Blocks by federated pool

    # .PARAMETER UtilizationLow
    #     Use this parameter to filter the list of Federated Blocks with a utilization above the low utilization threshold

    # .PARAMETER UtilizationHigh
    #     Use this parameter to filter the list of Federated Blocks with a utilization below the high utilization threshold

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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
        Use this parameter to query a particular federated block id

    .EXAMPLE
        PS> Get-B1FederatedBlock -Protocol ip4 -CIDR 24 | ft address,cidr,name,protocol

            address      cidr name                         protocol
            -------      ---- ----                         --------
            10.0.0.0       24 block_a                      ip4
            10.0.1.0       24 block_b                      ip4
            10.0.2.0       24 block_c                      ip4
            10.0.3.0       24 block_d                      ip4
            10.0.4.0       24 block_e                      ip4

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding()]
    param(
      [String]$Subnet,
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [ValidateSet("ip4", "ip6")]
      [String]$Protocol,
      [String]$Name,
      [String]$Description,
      [String]$Realm,
      [String]$Pool,
    #   [ValidateRange(0,100)] - Currently broken on backend API
    #   [Int]$UtilizationLow = 0,
    #   [ValidateRange(0,100)]
    #   [Int]$UtilizationHigh = 100,
      [Switch]$Strict,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      $CustomFilters,
      [String]$id
    )
	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
    }
    if ($Subnet) {
        if ($Subnet -match '/\d') {
            $IPandMask = $Subnet -Split '/'
            $Subnet = $IPandMask[0]
            $CIDR = $IPandMask[1]
        }
        $Filters.Add("address==`"$Subnet`"") | Out-Null
    }
    if ($CIDR) {
        $Filters.Add("cidr==$CIDR") | Out-Null
    }
    if ($Protocol) {
        $Filters.Add("protocol==`"$Protocol`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("comment$MatchType`"$Description`"") | Out-Null
    }
    if ($Realm) {
        $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict | Select-Object -ExpandProperty id).split('/')[-1]
        if ($RealmID -eq $null) {
            Write-Warning "No Federated Realm found with name '$Realm'. No results will be returned."
            return
        }
        $Filters.Add("federated_realm==`"$RealmID`"") | Out-Null
    }
    if ($Pool) {
        $PoolID = (Get-B1FederatedPool -Name $Pool -Strict | Select-Object -ExpandProperty id).split('/')[-1]
        if ($PoolID -eq $null) {
            Write-Warning "No Federated Pool found with name '$Pool'. No results will be returned."
            return
        }
        $Filters.Add("federated_pool_id==`"$PoolID`"") | Out-Null
    }
    # Currently broken on backend API. Works via htree which is used in the UI, but official APIs should be used where possible
    # if ($UtilizationLow -or $UtilizationHigh) {
    #     $Filters.Add("utilization>=$UtilizationLow and utilization<=$UtilizationHigh") | Out-Null
    # }
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
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/federated_block$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/federated_block?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}