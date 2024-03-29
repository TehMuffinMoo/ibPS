function Get-B1Host {
    <#
    .SYNOPSIS
        Queries a list of BloxOneDDI Hosts

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI Hosts

    .PARAMETER Name
        The name of the host to filter by
    
    .PARAMETER IP
        The IP of the host to filter by

    .PARAMETER OPHID
        The On Prem Host ID of the host to filter by

    .PARAMETER Space
        The IPAM Space of the host to filter by

    .PARAMETER Limit
        Used to limit the number of results. The default is 10001

    .PARAMETER Status
        Return results based on host status

    .PARAMETER Detailed
        Include service information with host details

    .PARAMETER BreakOnError
        Whether to break out of the script/function if a host does not exist

    .PARAMETER Reduced
        Return minimal details relating to the host. This includes display name, ip_address, description, host_subtype, host_version, mac_address, nat_ip, last_seen & updated_at fields.

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER NoIPSpace
        Filter by hosts which do not have an IPAM space assigned

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 10001.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.
        
    .PARAMETER id
        Use the id parameter to filter the results by ID

    .EXAMPLE
        PS> Get-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10" -OPHID "OnPremHostID" -Space "Global" -Limit "100" -Status "degraded" -Detailed
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
    [CmdletBinding(DefaultParameterSetName="default")]
    param(
      [String]$Name,
      [String]$IP,
      [String]$OPHID,
      [String]$Space,
      [Int]$Limit = "10001",
      [ValidateSet("online","pending","degraded","error")]
      [String]$Status,
      [switch]$Detailed,
      [switch]$BreakOnError,
      [switch]$Reduced,
      [switch]$Strict,
      [switch]$NoIPSpace,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    if ($Space) {$IPSpace = (Get-B1Space -Name $Space -Strict).id}

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($IP) {
        $Filters.Add("ip_address$MatchType`"$IP`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("display_name$MatchType`"$Name`"") | Out-Null
    }
    if ($OPHID) {
        $Filters.Add("ophid$MatchType`"$OPHID`"") | Out-Null
    }
    if ($Space) {
        $Filters.Add("ip_space==`"$IPSpace`"") | Out-Null
    }
    if ($Status) {
      $Filters.Add("composite_status==`"$Status`"") | Out-Null
      $Detailed = $true
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Detailed) {
      $APIEndpoint = "detail_hosts"
    } else {
      $APIEndpoint = "hosts"
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
    if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    if ($QueryString) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($APIEndpoint)$($QueryString)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/$($APIEndpoint)?_limit=$($Limit)" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        if ($NoIPSpace) {
            $Results = $Results | Where-Object {!($_.ip_space)}
        }
        if ($Reduced) {
            return $Results | Select-Object display_name,ip_address,description,host_subtype,host_version,mac_address,nat_ip,last_seen,updated_at
        } else {            
            return $Results
        }
    } else {
        Write-Verbose "No On-Prem Host(s) found."
        if ($BreakOnError) {
          if ($Name) {
            Write-Host "Error. No On-Prem Host(s) found matching $Name." -ForegroundColor Red
          }
          break
        }
    }
}