function Get-B1TopMetrics {
    <#
    .SYNOPSIS
        Retrieves top metrics from BloxOneDDI

    .DESCRIPTION
        This function is used to retrieve top metrics from BloxOneDDI

    .PARAMETER TopQueries
        Use this parameter to select Top Queries as the top metric category

    .PARAMETER QueryType
        Use this parameter to specify the query type when using -TopQueries

		Available options: NXDOMAIN, NXRRSET, DNS & DFP

    .PARAMETER TopClients
        Use this parameter to select Top Clients as the top metric category

    .PARAMETER TopClientLogType
        Use this parameter to specify the top client log type when using -TopClients

		Available options: DNS, DFP & DHCP

    .PARAMETER TopCount
        Use this parameter to return X results for the top metric selected. Default is 20.

	.PARAMETER TopDNSServers
	    Use this parameter to return a list of DNS Servers by query count

	.PARAMETER Granularity
	    Use this parameter to return results based on intervals instead of aggregated across the whole time period

		Available options: Minute, Hour, Day, Week, Month & Year

    .PARAMETER Start
        The start date/time for searching aggregated metrics. Default is 1 day ago.

    .PARAMETER End
        The end date/time for searching aggregated metrics. Default is now.

    .EXAMPLE
        PS> Get-B1TopMetrics -TopQueries DFP -TopCount 50 -Start (Get-Date).AddDays(-1)

	.EXAMPLE
	    PS> Get-B1TopMetrics -TopDNSServers -Start (Get-Date).AddDays(-31)

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Metrics
    #>
	[CmdletBinding(DefaultParameterSetName="default")]
    param (
        [switch][parameter(ParameterSetName="topQueries")] $TopQueries,
        [string][parameter(ParameterSetName="topQueries", Mandatory=$true)][ValidateSet("NXDOMAIN","NXRRSET","DNS","DFP")] $QueryType,
        [switch][parameter(ParameterSetName="topClients")] $TopClients,
        [string][parameter(ParameterSetName="topClients")][ValidateSet("DNS","DFP","DHCP")] $TopClientLogType,
        [switch][parameter(ParameterSetName="topDNSServers")] $TopDNSServers,
		[string][parameter(ParameterSetName="topDNSServers")][ValidateSet("minute","hour","day","week","month","year")] $Granularity,
        [int]$TopCount = "20",
        [datetime]$Start = (Get-Date).AddDays(-1),
        [datetime]$End = (Get-Date)
    )
    if ($TopQueries) {
        switch ($QueryType) {
            "NXDOMAIN" {
				$Filters = @(
					@{
						"member" = "NstarDnsActivity.response"
						"operator" = "equals"
						"values" = @(
							"NXDOMAIN"
						)
					}
				)
				$Result = Invoke-B1CubeJS -Cube NstarDnsActivity -Measures total_query_count -Dimensions qname -TimeDimension timestamp -Start $Start -End $End -Filters $Filters -Limit $TopCount -Grouped
				if ($Result) {
					return $Result
				}
                break
            }
            "NXRRSET" {
				$Filters = @(
					@{
						"member" = "NstarDnsActivity.response"
						"operator" = "equals"
						"values" = @(
							"NXRRSET"
						)
					}
				)
				$Result = Invoke-B1CubeJS -Cube NstarDnsActivity -Measures total_query_count -Dimensions qname -TimeDimension timestamp -Start $Start -End $End -Filters $Filters -Limit $TopCount -Grouped
				if ($Result) {
					return $Result
				}
                break
            }
            "DNS" {
				$Result = Invoke-B1CubeJS -Cube NstarDnsActivity -Measures total_query_count -Dimensions qname -TimeDimension timestamp -Start $Start -End $End -Limit $TopCount -Grouped
				if ($Result) {
					return $Result
				}
                break
            }
            "DFP" {
				$Filters = @(
					@{
						"member" = "PortunusDnsLogs.type"
						"operator" = "equals"
						"values" = @(
							"1"
						)
					}
				)
				$Result = Invoke-B1CubeJS -Cube PortunusDnsLogs -Measures qnameCount -Dimensions qname -TimeDimension timestamp -Start $Start -End $End -Filters $Filters -Limit $TopCount -Grouped
				if ($Result) {
					return $Result
				}
                break
            }
            default {
                Write-Host "Error. Permitted QueryType options are: NXDOMAIN, NXRRSET, DFP" -ForegroundColor Red
                break
            }
        }
    }
    if ($TopClients) {
        switch ($TopClientLogType) {
            "DNS" {
				$DNSHosts = Get-B1DNSHost -Limit 10000 -Fields site_id,name
				$Result = Invoke-B1CubeJS -Cube NstarDnsActivity -Measures total_query_count -Dimensions device_ip,site_id -TimeDimension timestamp -Start $Start -End $End -Limit $TopCount -Grouped
				if ($Result) {
					return $Result | Select-Object @{name="dns_server";Expression={$siteId = $_.'site_id'; (@($DNSHosts).where({ $_.site_id -eq $siteId })).name}},*
				}
                break
            }
            "DFP" {
				$Filters = @(
					@{
						"member" = "PortunusAggUserDevices.type"
						"operator" = "equals"
						"values" = @(
							"1"
						)
					}
				)
				$Result = Invoke-B1CubeJS -Cube PortunusAggUserDevices -Measures deviceCount -Dimensions device_name -TimeDimension timestamp -Start $Start -End $End -Filters $Filters -Limit $TopCount -Grouped
				if ($Result) {
					return $Result
				}
                break
            }
			"DHCP" {
				$DHCPHosts = Get-B1DHCPHost -Limit 10000 -Fields ophid,name
				$Result = Invoke-B1CubeJS -Cube NstarLeaseActivity -Measures total_count -Dimensions lease_ip,host_id -TimeDimension timestamp -Start $Start -End $End -Filters $Filters -Limit $TopCount -Grouped
				if ($Result) {
					return $Result | Select-Object @{Name = 'DHCP-Server'; Expression = {$HostID = $_.'host_id';if ($HostID) {($DHCPHosts | Where-Object {$_.ophid -eq $HostID}).name}}},*
				}
                break
			}
            default {
                Write-Host "Error. Permitted TopClientLogType options are: DNS, DFP" -ForegroundColor Red
                break
            }
        }
    }
	if ($TopDNSServers) {
		$DNSHosts = Get-B1DNSHost -Limit 10000 -Fields site_id,name
		$Result = Invoke-B1CubeJS -Cube NstarDnsActivity -Measures total_query_count -Dimensions site_id -TimeDimension timestamp -Start $Start -End $End -Limit $TopCount -Grouped -Granularity $Granularity
		if ($Result) {
			return $Result | Select-Object @{name="dns_server";Expression={$siteId = $_.'site_id'; (@($DNSHosts).where({ $_.site_id -eq $siteId })).name}},*
		}
		break
	}
}