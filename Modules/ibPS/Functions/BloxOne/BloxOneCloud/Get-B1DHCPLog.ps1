function Get-B1DHCPLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI DHCP Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI DHCP Logs. This is the log which contains all DHCP request/response information.

    .PARAMETER Hostname
        Use this parameter to filter the DHCP Logs by hostname or FQDN

    .PARAMETER State
        Used to filter the DHCP Log by the request state

    .PARAMETER IP
        Used to filter the DHCP Log by source IP

    .PARAMETER DHCPServer
        Filter the DHCP Logs by one or more DHCP Servers (i.e @("mybloxoneddihost1.mydomain.corp","mybloxoneddihost2.mydomain.corp")

    .PARAMETER Protocol
        Filter the DHCP Logs by IP Protocol (i.e "IPv4 Address")

    .PARAMETER MacAddress
        Filter the DHCP Logs by MAC Address (i.e "ab:cd:ef:12:34:56")

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .EXAMPLE
        PS> Get-B1DHCPLog -Hostname "dhcpclient.mydomain.corp" -State "Assignments" -IP "10.10.10.100" -Protocol "IPv4 Address" -DHCPServer "bloxoneddihost1.mydomain.corp" -Start (Get-Date).AddHours(-24) -End (Get-Date) -Limit 100 -Offset 0
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Logs

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [string]$Hostname,
      [string]$State,
      [string]$IP,
      [System.Object]$DHCPServer,
      [string]$Protocol,
      [string]$MACAddress,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    $DHCPHosts = Get-B1DHCPHost
    function Match-DHCPHost($id) {
        ($DHCPHosts | Where-Object {$_.id -eq $id}).name
    }

    $splat = @{
	    "dimensions" = @(
		    "NstarLeaseActivity.timestamp"
		    "NstarLeaseActivity.host_id"
		    "NstarLeaseActivity.protocol"
		    "NstarLeaseActivity.state"
		    "NstarLeaseActivity.lease_ip"
		    "NstarLeaseActivity.mac_address"
		    "NstarLeaseActivity.client_hostname"
		    "NstarLeaseActivity.lease_start"
		    "NstarLeaseActivity.lease_end"
		    "NstarLeaseActivity.dhcp_fingerprint"
	    )
	    "timeDimensions" = @(
		    @{
			    "dimension" = "NstarLeaseActivity.timestamp"
			    "dateRange" = @(
				    $StartTime
				    $EndTime
			    )
			    "granularity" = $null
		    }
	    )
	    "filters" = @()
	    "ungrouped" = $true
	    "offset" = $Offset
	    "limit" = $Limit
	    "order" = @{
		    "NstarLeaseActivity.lease_start" = "desc"
	    }
    }

    if ($Hostname) {
        $HostnameSplat = @{
            "member" = "NstarLeaseActivity.client_hostname"
            "operator" = "contains"
            "values" = @(
                $Hostname
            )
		}
        $splat.filters += $HostnameSplat
    }

    if ($MacAddress) {
        $MacAddressSplat = @{
            "member" = "NstarLeaseActivity.mac_address"
            "operator" = "equals"
            "values" = @(
                $MacAddress
            )
		}
        $splat.filters += $MacAddressSplat
    }

    if ($State) {
        $StateSplat = @{
            "member" = "NstarLeaseActivity.state"
            "operator" = "contains"
            "values" = @(
                $State
            )
		}
        $splat.filters += $StateSplat
    }

    if ($IP) {
        $IPSplat = @{
            "member" = "NstarLeaseActivity.lease_ip"
            "operator" = "contains"
            "values" = @(
                $IP
            )
		}
        $splat.filters += $IPSplat
    }

    if ($Protocol) {
        $ProtocolSplat = @{
            "member" = "NstarLeaseActivity.protocol"
            "operator" = "equals"
            "values" = @(
                $Protocol
            )
		}
        $splat.filters += $ProtocolSplat
    }

    if ($DHCPServer) {
        $DHCPHostIds = @()
        foreach ($DHCPServ in $DHCPServer) {
            $DHCPHostIds += (Get-B1DHCPHost -Name $DHCPServ).id
        }

        if ($DHCPHostIds) {
            $HostIdSplat = @{
                "member" = "NstarLeaseActivity.host_id"
                "operator" = "equals"
                "values" = @(
                    $DHCPHostIds
                )
		    }
            $splat.filters += $HostIdSplat
        } else {
            Write-Host "Error: Unable to find DHCP Host: $DHCPServer" -ForegroundColor Red
            break
        }
    }
    
    $Data = $splat | ConvertTo-Json -Depth 4 -Compress

    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    Write-DebugMsg -Query ($splat | ConvertTo-Json -Depth 4)
    $Result = Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"
    if ($Result.result.data) {
        $Result.result.data | Select-Object @{name="timestamp";Expression={$_.'NstarLeaseActivity.timestamp'}},`
                                     @{name="dhcp_server";Expression={Match-DHCPHost($_.'NstarLeaseActivity.host_id')}},`
                                     @{name="protocol";Expression={$_.'NstarLeaseActivity.protocol'}},`
                                     @{name="state";Expression={$_.'NstarLeaseActivity.state'}},`
                                     @{name="lease_ip";Expression={$_.'NstarLeaseActivity.lease_ip'}},`
                                     @{name="mac_address";Expression={$_.'NstarLeaseActivity.mac_address'}},`
                                     @{name="client_hostname";Expression={$_.'NstarLeaseActivity.client_hostname'}},`
                                     @{name="lease_start";Expression={$_.'NstarLeaseActivity.lease_start'}},`
                                     @{name="lease_end";Expression={$_.'NstarLeaseActivity.lease_end'}},`
                                     @{name="dhcp_fingerprint";Expression={$_.'NstarLeaseActivity.dhcp_fingerprint'}}
    } else {
        Write-Host "Error: No DHCP logs returned." -ForegroundColor Red
    }

}