function Get-B1ForwardLookingDelegation {
    <#
    .SYNOPSIS
        Queries a list of Forward Looking Delegations from the Universal DDI IPAM

    .DESCRIPTION
        This function is used to query a list of Forward Looking Delegations from the Universal DDI IPAM

    .PARAMETER Subnet
        Use this parameter to filter the list of Forward Looking Delegations by network address

    .PARAMETER CIDR
        Use this parameter to filter the list of Forward Looking Delegations by CIDR suffix

    .PARAMETER Protocol
        Use this parameter to filter the list of Forward Looking Delegations by protocol

    .PARAMETER Name
        Use this parameter to filter the list of Forward Looking Delegations by name

    .PARAMETER Description
        Use this parameter to filter the list of Forward Looking Delegations by description

    # .PARAMETER Realm
    #     Use this parameter to filter the list of Forward Looking Delegations by federated realm

    .PARAMETER Pool
        Use this parameter to filter the list of Forward Looking Delegations by federated pool

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
        Use this parameter to query using a particular forward looking delegation id

    .EXAMPLE
        PS> Get-B1ForwardLookingDelegation -Name "AZ_2_FLD" -Strict

        id                : federation/forward_looking_delegation/c178b92f-63eb-4c87-943e-98befa1e1772
        created_at        : 30/06/2026 16:16:26
        updated_at        : 30/06/2026 16:16:26
        name              : AZ_2_FLD
        comment           : Azure Landing Zone #2 - Forward Looking Delegation
        protocol          : ip4
        address           : 10.20.0.0
        cidr              : 16
        tags              :
        federated_realms  : {federation/federated_realm/2bff55cf-9bb9-441f-bf06-df53e9358aa3}
        federated_pool_id :
        network_compliant : True

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
    # if ($RealmID) {
    #     $Filters.Add("federated_realm==`"$($RealmID.split('/')[-1])`"") | Out-Null
    # } elseif ($Realm) {
    #     $RealmObject = Get-B1FederatedRealm -Name $Realm -Strict
    #     if ($RealmObject -eq $null) {
    #         Write-Warning "No Federated Realm found with name '$Realm'. No results will be returned."
    #         return
    #     }
    #     $RealmID = $RealmObject.id.split('/')[-1]
    #     $Filters.Add("federated_realm==`"$RealmID`"") | Out-Null
    # }
    if ($PoolID) {
        $Filters.Add("federated_pool_id==`"$($PoolID.split('/')[-1])`"") | Out-Null
    } elseif ($Pool) {
        $PoolID = (Get-B1FederatedPool -Name $Pool -Strict | Select-Object -ExpandProperty id).split('/')[-1]
        if ($PoolID -eq $null) {
            Write-Warning "No Federated Pool found with name '$Pool'. No results will be returned."
            return
        }
        $Filters.Add("federated_pool_id==`"$PoolID`"") | Out-Null
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
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/forward_looking_delegation$($QueryString)" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/forward_looking_delegation?_limit=$Limit&_offset=$Offset" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
}