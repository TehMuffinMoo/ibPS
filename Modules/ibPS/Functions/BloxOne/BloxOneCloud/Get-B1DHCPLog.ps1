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

    .PARAMETER OrderBy
        The field in which to order the results by. This field supports auto-complete, and defaults to timestamp.

    .PARAMETER Order
        The direction to order results in. This defaults to ascending.

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
      [String]$OrderBy = 'timestamp',
      [ValidateSet('asc','desc')]
      [String]$Order = 'asc',
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    $Cube = 'NstarLeaseActivity'

    ## Replace with CubeJS Query
    $DHCPHostQuery = Get-B1DHCPHost -Limit 2500 -Fields id,name
    $DHCPHosts += $DHCPHostQuery
    if ($DHCPHostQuery.count -eq 2500) {
        $Offset = 2500
        while ($DHCPHostQuery.count -gt 0) {
            $DHCPHostQuery = Get-B1DHCPHost -Limit 2500 -Offset $Offset -Fields id,name
            $DHCPHosts += $DHCPHostQuery
            $Offset += 2500
        }
    }

    function Match-DHCPHost($id,$name) {
        if ($id) {
            ($DHCPHosts | Where-Object {$_.id -eq $id}).name
        }
        if ($name) {
            ($DHCPHosts | Where-Object {$_.name -eq $name}).id
        }
    }

    $Dimensions = @(
        "timestamp"
        "host_id"
        "protocol"
        "state"
        "lease_ip"
        "mac_address"
        "client_hostname"
        "lease_start"
        "lease_end"
        "dhcp_fingerprint"
    )
    $Filters = @()

    if ($Hostname) {
        $Filters += @{
            "member" = "NstarLeaseActivity.client_hostname"
            "operator" = "contains"
            "values" = @(
                $Hostname
            )
		}
    }

    if ($MacAddress) {
        $Filters += @{
            "member" = "NstarLeaseActivity.mac_address"
            "operator" = "equals"
            "values" = @(
                $MacAddress
            )
		}
    }

    if ($State) {
        $Filters += @{
            "member" = "NstarLeaseActivity.state"
            "operator" = "contains"
            "values" = @(
                $State
            )
		}
    }

    if ($IP) {
        $Filters += @{
            "member" = "NstarLeaseActivity.lease_ip"
            "operator" = "contains"
            "values" = @(
                $IP
            )
		}
    }

    if ($Protocol) {
        $Filters += @{
            "member" = "NstarLeaseActivity.protocol"
            "operator" = "equals"
            "values" = @(
                $Protocol
            )
		}
    }

    if ($DHCPServer) {
        $DHCPHostIds = @()
        foreach ($DHCPServ in $DHCPServer) {
            $DHCPHostIds += Match-DHCPHost -Name $DHCPServ
        }

        if ($DHCPHostIds) {
            $Filters += @{
                "member" = "NstarLeaseActivity.host_id"
                "operator" = "equals"
                "values" = @(
                    $DHCPHostIds
                )
		    }
        } else {
            Write-Host "Error: Unable to find DHCP Host: $DHCPServer" -ForegroundColor Red
            break
        }
    }
    
    $Result = Invoke-B1CubeJS -Cube $($Cube) -Dimensions $Dimensions -TimeDimension timestamp -Start $Start -End $End -Limit $Limit -Filters $Filters -OrderBy $OrderBy -Order $Order
    if ($Result) {
        return $Result | Select-Object @{name="dhcp_server";Expression={Match-DHCPHost -id $_.'host_id'}},*
    } else {
        Write-Host "Error: No DHCP logs returned." -ForegroundColor Red
    }
}