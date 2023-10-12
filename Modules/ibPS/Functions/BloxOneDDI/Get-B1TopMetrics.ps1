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

    .PARAMETER TopClients
        Use this parameter to select Top Clients as the top metric category

    .PARAMETER TopClientLogType
        Use this parameter to specify the top client log type when using -TopClients

    .PARAMETER TopCount
        Use this parameter to return X results for the top metric selected

    .PARAMETER Start
        The start date/time for searching aggregated metrics

    .PARAMETER End
        The end date/time for searching aggregated metrics

    .Example
        Get-B1TopMetrics -TopQueries DFP -TopCount 50 -Start (Get-Date).AddDays(-1)
   
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
        [string][parameter(ParameterSetName="topClients")][ValidateSet("DNS","DFP")] $TopClientLogType,
        [int]$TopCount = "20",
        [datetime]$Start = (Get-Date).AddDays(-1),
        [datetime]$End = (Get-Date)
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartDate = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndDate = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    if ($TopQueries) {
        switch ($QueryType) {
            "NXDOMAIN" {
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "NstarDnsActivity.response"
			                "operator" = "equals"
			                "values" = @(
				                "NXDOMAIN"
			                )
		                }
                     )
	                "limit" = $TopCount
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select-Object @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}} | Sort queryCount
                $DNSClients
                break
            }
            "NXRRSET" {
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "NstarDnsActivity.response"
			                "operator" = "equals"
			                "values" = @(
				                "NXRRSET"
			                )
		                }
                     )
	                "limit" = $TopCount
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select-Object @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}} | Sort queryCount
                $DNSClients
                break
            }
            "DNS" {
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                #"filters" = @(
		                #@{
			                #"member" = "NstarDnsActivity.response"
			                #"operator" = "equals"
			                #"values" = @(
				                #"NXDOMAIN"
			                #)
		                #}
                     #)
	                "limit" = $TopCount
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select-Object @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}} | Sort queryCount
                $DNSClients
                break
            }
            "DFP" {
                $splat = @{
	                "measures" = @(
		                "PortunusDnsLogs.qnameCount"
	                )
	                "dimensions" = @(
		                "PortunusDnsLogs.qname"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "PortunusDnsLogs.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "PortunusDnsLogs.type"
			                "operator" = "equals"
			                "values" = @(
				                "1"
			                )
		                }
	                )
	                "limit" = $TopCount
	                "ungrouped" = $false
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"
                $TopQueriesLog = $Result.result.data | Select-Object @{name="query";Expression={$_.'PortunusDnsLogs.qname'}},`
                                             @{name="queryCount";Expression={$_.'PortunusDnsLogs.qnameCount'}}
                $TopQueriesLog
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
                $splat = @{
	                "measures" = @(
		                "NstarDnsActivity.total_count"
	                )
	                "dimensions" = @(
		                "NstarDnsActivity.device_ip"
	                )
	                "timeDimensions" = @(
		                @{
			                "dimension" = "NstarDnsActivity.timestamp"
			                "dateRange" = @(
				                $StartDate
				                $EndDate
			                )
			                "granularity" = $null
		                }
	                )
	                "filters" = @()
	                "limit" = $TopCount
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"

                $DNSClients = $Result.result.data | Select-Object @{name="device_ip";Expression={$_.'NstarDnsActivity.device_ip'}},`
                                             @{name="queryCount";Expression={$_.'NstarDnsActivity.total_count'}},`
                                             @{name="licenseUsage";Expression={[math]::Round(($_.'NstarDnsActivity.total_count')/9000 + 0.5)}} | Sort queryCount
                $DNSClients
                break
            }
            "DFP" {
                $splat = @{
	                "measures" = @(
		                "PortunusAggUserDevices.deviceCount"
	                )
	                "dimensions" = @(
		                "PortunusAggUserDevices.device_name"
	                )
	                "timeDimensions" = @(
                        @{
			                "dimension" = "PortunusAggUserDevices.timestamp"
			                "dateRange" = @(
				                $StartDate,
				                $EndDate
			                )
		                }
	                )
	                "filters" = @(
		                @{
			                "member" = "PortunusAggUserDevices.type"
			                "operator" = "equals"
			                "values" = @(
				                "1"
			                )
		                }
	                )
	                "limit" = $TopCount
	                "ungrouped" = $false
                }
                $Data = $splat | ConvertTo-Json -Depth 4 -Compress
                $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
                $Result = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"

                $DFPClients = $Result.result.data | Select-Object @{name="device_name";Expression={$_.'PortunusAggUserDevices.device_name'}},`
                                             @{name="count";Expression={$_.'PortunusAggUserDevices.deviceCount'}} | Sort count
                $DFPClients
            }
            default {
                Write-Host "Error. Permitted TopClientLogType options are: DNS, DFP" -ForegroundColor Red
                break
            }
        }
    }
}