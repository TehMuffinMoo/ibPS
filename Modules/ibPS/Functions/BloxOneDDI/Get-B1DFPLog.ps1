function Get-B1DFPLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI DFP Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI DFP (DNS Forwarding Proxy) Logs. This is the log which contains all DNS Security related events.

    .PARAMETER Query
        Use this parameter to filter the DFP Logs by hostname or FQDN

    .PARAMETER IP
        Used to filter the DFP Log by IP Address

    .PARAMETER Type
        Used to filter the DFP Log by query type, such as "A" or "CNAME"

    .PARAMETER Response
        Use this parameter to filter the DFP Log by the response, i.e "NXDOMAIN"

    .PARAMETER Source
        Filter the DFP Logs by one or more DFP Servers, External Networks & BloxOne Endpoints (i.e "mybloxoneddihost.mydomain.corp (DFP)" or "mybloxoneddihost1.mydomain.corp (DFP)","mybloxoneddihost2.mydomain.corp (DFP)","BloxOne Endpoint"

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .EXAMPLE
          PS> Get-B1DFPLog -IP "10.10.132.10" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0

    .EXAMPLE
          PS> Get-B1DFPLog -Source "MyB1Host (DFP)" -Start (Get-Date).AddHours(-6) Limit 10
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    param(
      [string]$Query,
      [string]$IP,
      [string]$Type,
      [string]$Response,
      [string[]]$Source,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [int]$Limit = 100,
      [int]$Offset = 0
    )
    
    $DFPServices = Get-B1DFP

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    $splat = @{
    	"measures" = @()
	    "dimensions" = @(
		    "PortunusDnsLogs.timestamp"
		    "PortunusDnsLogs.qname"
		    "PortunusDnsLogs.device_name"
		    "PortunusDnsLogs.qip"
		    "PortunusDnsLogs.network"
		    "PortunusDnsLogs.response"
		    "PortunusDnsLogs.dns_view"
		    "PortunusDnsLogs.query_type"
		    "PortunusDnsLogs.mac_address"
		    "PortunusDnsLogs.dhcp_fingerprint"
		    "PortunusDnsLogs.user"
		    "PortunusDnsLogs.os_version"
		    "PortunusDnsLogs.response_region"
		    "PortunusDnsLogs.response_country"
		    "PortunusDnsLogs.device_region"
		    "PortunusDnsLogs.device_country"
	    )
	    "timeDimensions" = @(
		    @{
			    "dimension" = "PortunusDnsLogs.timestamp"
			    "dateRange" = @(
				    $StartTime
				    $EndTime
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
	    "limit" = $Limit
	    "offset" = $Offset
	    "order" = @{
		    "PortunusDnsLogs.timestamp" = "desc"
	    }
	    "ungrouped" = $true
    }

    if ($Query) {
        $QuerySplat = @{
            "member" = "PortunusDnsLogs.qname"
            "operator" = "contains"
            "values" = @(
                $Query
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Type) {
        $QuerySplat = @{
            "member" = "PortunusDnsLogs.query_type"
            "operator" = "equals"
            "values" = @(
                $Type
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Response) {
        $ResponseSplat = @{
            "member" = "PortunusDnsLogs.response"
            "operator" = "contains"
            "values" = @(
                $Response
            )
		}
        $splat.filters += $ResponseSplat
    }

    if ($IP) {
        $IPSplat = @{
            "member" = "PortunusDnsLogs.qip"
            "operator" = "contains"
            "values" = @(
                $IP
            )
		}
        $splat.filters += $IPSplat
    }
    
    if ($Source) {
        $SourceSplat = @{
            "member" = "PortunusDnsLogs.network"
            "operator" = "contains"
            "values" = $Source
        }
        $splat.filters += $SourceSplat
    }

    $Data = $splat | ConvertTo-Json -Depth 4 -Compress

    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    $Result = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"
    if ($Result.result.data) {
        $Result.result.data | Select-Object @{name="timestamp";Expression={$_.'PortunusDnsLogs.timestamp'}},`
                                     @{name="query";Expression={$_.'PortunusDnsLogs.qname'}},`
                                     @{name="device_name";Expression={$_.'PortunusDnsLogs.device_name'}},`
                                     @{name="device_ip";Expression={$_.'PortunusDnsLogs.qip'}},`
                                     @{name="network";Expression={$_.'PortunusDnsLogs.network'}},`
                                     @{name="response";Expression={$_.'PortunusDnsLogs.response'}},`
                                     @{name="dns_view";Expression={$_.'PortunusDnsLogs.dns_view'}},`
                                     @{name="query_type";Expression={$_.'PortunusDnsLogs.query_type'}},`
                                     @{name="mac_address";Expression={$_.'PortunusDnsLogs.mac_address'}},`
                                     @{name="dhcp_fingerprint";Expression={$_.'PortunusDnsLogs.dhcp_fingerprint'}},`
                                     @{name="user";Expression={$_.'PortunusDnsLogs.user'}},`
                                     @{name="os_version";Expression={$_.'PortunusDnsLogs.os_version'}},`
                                     @{name="response_region";Expression={$_.'PortunusDnsLogs.response_region'}},`
                                     @{name="response_country";Expression={$_.'PortunusDnsLogs.response_country'}},`
                                     @{name="device_region";Expression={$_.'PortunusDnsLogs.device_region'}},`
                                     @{name="device_country";Expression={$_.'PortunusDnsLogs.device_country'}}
    } else {
        Write-Host "Error: No DNS logs returned." -ForegroundColor Red
    }

}