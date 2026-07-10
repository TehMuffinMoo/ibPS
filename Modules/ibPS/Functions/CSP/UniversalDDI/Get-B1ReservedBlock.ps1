function Get-B1ReservedBlock {
    <#
    .SYNOPSIS
        Queries a list of Reserved Blocks from the Universal DDI IPAM

    .DESCRIPTION
        This function is used to query a list of Reserved Blocks from the Universal DDI IPAM

    .PARAMETER Subnet
        Use this parameter to filter the list of Reserved Blocks by network address

    .PARAMETER CIDR
        Use this parameter to filter the list of Reserved Blocks by CIDR suffix

    .PARAMETER Protocol
        Use this parameter to filter the list of Reserved Blocks by protocol

    .PARAMETER Name
        Use this parameter to filter the list of Reserved Blocks by name

    .PARAMETER Description
        Use this parameter to filter the list of Reserved Blocks by description

    # .PARAMETER Realm
    #     Use this parameter to filter the list of Reserved Blocks by federated realm

    .PARAMETER Pool
        Use this parameter to filter the list of Reserved Blocks by federated pool

    # .PARAMETER UtilizationLow
    #     Use this parameter to filter the list of Reserved Blocks with a utilization above the low utilization threshold

    # .PARAMETER UtilizationHigh
    #     Use this parameter to filter the list of Reserved Blocks with a utilization below the high utilization threshold

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

    # .PARAMETER RealmID
    #     Use this parameter to query using a particular federated realm id, without looking up the realm by name first.

    .PARAMETER PoolID
        Use this parameter to query using a particular federated pool id, without looking up the pool by name first.

    .PARAMETER id
        Use this parameter to query a particular reserved block id

    .EXAMPLE
        PS> Get-B1ReservedBlock -Subnet '10.10.10.0/24'

        address           : 10.10.10.0
        cidr              : 24
        comment           : Reserved for future use in the Data Center
        created_at        : 22/10/2024 06:29:18
        federated_pool_id :
        federated_realm   : federation/federated_realm/a0ebec5f-ea98-41c1-8033-47b05d1f04fc
        id                : federation/reserved_block/ff23ff93-2188-406f-9b1f-79153cf3b07b
        metadata          :
        name              : reserved-for-dc
        network_compliant : True
        parent            : federation/federated_block/bdb62c57-0c19-4cef-88c9-464e816bebc0
        protocol          : ip4
        region            :
        tags              :
        updated_at        : 26/04/2025 01:50:58

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
    #   [String]$Realm,
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
    #   [String]$RealmID,
      [String]$PoolID,
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
            # $Subnet = $IPandMask[0] - Temporarily disabled to allow for filtering by CIDR in the Subnet parameter. This will be re-enabled when the backend API is updated to support this functionality.
            $CIDR = $IPandMask[1]
        } else { ## Temporary validation until backend API is updated to support filtering by CIDR and Subnet (address) parameter independently.
            Write-Error "The Subnet parameter must be in CIDR notation (e.g. 192.168.1.0/24)."
            return
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
    if ($RealmID) {
        $Filters.Add("federated_realm==`"$($RealmID.split('/')[-1])`"") | Out-Null
    } elseif ($Realm) {
        $RealmObject = Get-B1FederatedRealm -Name $Realm -Strict
        if ($RealmObject -eq $null) {
            Write-Warning "No Federated Realm found with name '$Realm'. No results will be returned."
            return
        }
        $RealmID = $RealmObject.id.split('/')[-1]
        $Filters.Add("federated_realm==`"$RealmID`"") | Out-Null
    }
    if ($PoolID) {
        $Filters.Add("federated_pool_id==`"$($PoolID.split('/')[-1])`"") | Out-Null
    } elseif ($Pool) {
        $PoolObject = Get-B1FederatedPool -Name $Pool -Strict
        if ($PoolObject -eq $null) {
            Write-Warning "No Federated Pool found with name '$Pool'. No results will be returned."
            return
        }
        $PoolID = $PoolObject.id.split('/')[-1]
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
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/reserved_block$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/reserved_block?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}