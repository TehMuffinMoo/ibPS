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

    .PARAMETER id
        Use the id parameter to filter the results by ID

    .Example
        Get-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.10.10" -OPHID "OnPremHostID" -Space "Global" -Limit "100" -Status "degraded" -Detailed
    
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
      [String]$Limit = "10001",
      [ValidateSet("online","pending","degraded","error")]
      [String]$Status,
      [switch]$Detailed,
      [switch]$BreakOnError,
      [switch]$Reduced,
      [switch]$Strict = $false,
      [switch]$NoIPSpace,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    if ($Space) {$IPSpace = (Get-B1Space -Name $Space -Strict).id}

    [System.Collections.ArrayList]$Filters = @()
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
    }

    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($APIEndpoint)?_limit=$($Limit)&_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "https://csp.infoblox.com/api/infra/v1/$($APIEndpoint)?_limit=$($Limit)" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
    
    if ($Results) {
        if ($NoIPSpace) {
            $Results = $Results | where {!($_.ip_space)}
        }
        if ($Reduced) {
            return $Results | Select display_name,ip_address,description,host_subtype,host_version,mac_address,nat_ip,last_seen,updated_at
        } else {            
            return $Results
        }
    } else {
        if ($Name) {
            if ($BreakOnError) {
                Write-Host "Error. No On-Prem Host(s) found matching $Name." -ForegroundColor Red
            }
        } else {
            Write-Host "No On-Prem Host(s) found." -ForegroundColor Gray
        }
        if ($BreakOnError) {
            break
        }
    }
}