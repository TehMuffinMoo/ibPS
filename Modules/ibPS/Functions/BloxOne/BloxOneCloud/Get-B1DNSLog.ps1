function Get-B1DNSLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI DNS Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI DNS Logs. This is the log which contains all generic DNS request information.

    .PARAMETER Query
        Use this parameter to filter the DNS Logs by hostname or FQDN

    .PARAMETER IP
        Used to filter the DNS Log by IP Address. Accepts multiple inputs.

    .PARAMETER Name
        Used to filter the DNS Log by Client Host Name. Accepts multiple inputs.

    .PARAMETER Type
        Used to filter the DNS Log by query type, such as "A" or "CNAME"

    .PARAMETER Response
        Use this parameter to filter the DNS Log by the response, i.e "NXDOMAIN"

    .PARAMETER DNSServers
        Filter the DNS Logs by one or more DNS Servers (i.e "mybloxoneddihost.mydomain.corp" or "mybloxoneddihost1.mydomain.corp","mybloxoneddihost2.mydomain.corp"

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination. Only works if -Limit is less than 10,000 and combined Limit and Offset do not exceed 10,000
        
    .EXAMPLE
        PS> Get-B1DNSLog -IP "10.10.172.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0

    .EXAMPLE
        PS> Get-B1DNSLog -IP "10.10.172.35" -Query "google.com" -Type "A" -Response "216.58.201.110" -Start (Get-Date).AddHours(-6) -End (Get-Date) -Limit 1000 -Offset 0
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Logs
    #>
    param(
      [string]$Query,
      [string[]]$IP,
      [string[]]$Name,
      [string]$Type,
      [string]$Response,
      [string[]]$DNSServers,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [ValidateRange(1,50000)]
      [int]$Limit = 100,
      [int]$Offset = 0
    )

    if ($Limit -ge 10001) {
        $UseExport = $true
    }

    $DNSServices = Get-B1DNSHost

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()
    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ss.000")
    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ss.000")

    $splat = @{
	    "dimensions" = @(
		    "NstarDnsActivity.timestamp",
		    "NstarDnsActivity.qname",
		    "NstarDnsActivity.response",
		    "NstarDnsActivity.query_type",
		    "NstarDnsActivity.dns_view",
		    "NstarDnsActivity.device_ip",
		    "NstarDnsActivity.mac_address",
		    "NstarDnsActivity.dhcp_fingerprint",
		    "NstarDnsActivity.device_name",
		    "NstarDnsActivity.query_nanosec",
            "NstarDnsActivity.site_id"
	    )
	    "timeDimensions" = @(
		    @{
			    "dimension" = "NstarDnsActivity.timestamp"
			    "dateRange" = @(
				    $StartTime,
				    $EndTime
			    )
			    "granularity" = $null
		    }
	    )
	    "filters" = @(
	    )
	    "ungrouped" = $true
	    "offset" = $Offset
	    "limit" = $Limit
    }

    if ($Query) {
        $QuerySplat = @{
            "member" = "NstarDnsActivity.qname"
            "operator" = "contains"
            "values" = @(
                $Query
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Type) {
        $QuerySplat = @{
            "member" = "NstarDnsActivity.query_type"
            "operator" = "equals"
            "values" = @(
                $Type
            )
		}
        $splat.filters += $QuerySplat
    }

    if ($Response) {
        $ResponseSplat = @{
            "member" = "NstarDnsActivity.response"
            "operator" = "contains"
            "values" = @(
                $Response
            )
		}
        $splat.filters += $ResponseSplat
    }

    if ($IP) {
        $IPSplat = @{
            "member" = "NstarDnsActivity.device_ip"
            "operator" = "contains"
            "values" = $IP
		}
        $splat.filters += $IPSplat
    }

    if ($Name) {
        $NameSplat = @{
            "member" = "NstarDnsActivity.device_name"
            "operator" = "contains"
            "values" = $Name
		}
        $splat.filters += $NameSplat
    }

    if ($DNSServers) {
        $DNSServerArr = @()
        foreach ($DNSServer in $DNSServers) {
          $SiteID = ($DNSServices | Where-Object {$_.name -like "*$DNSServer*"}).site_id
          $DNSServerArr += $SiteID
        }
        $DNSServerSplat = @{
            "member" = "NstartDnsActivity.site_id"
            "operator" = "equals"
            "values" = $DNSServerArr
        }
        $splat.filters += $DNSServerSplat
    }

    $Data = $splat | ConvertTo-Json -Depth 4 -Compress
    $Query = [System.Web.HTTPUtility]::UrlEncode($Data)
    if ($UseExport) {
        $Options = '{"output":"csv","header":{"enabled":true,"display":["timestamp","query","response","query_type","dns_view","device_ip","mac_address","dhcp_fingerprint","name","query_nanosec"]}}'
        Write-DebugMsg -Query ($splat | ConvertTo-Json -Depth 4)
        $Result = Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/export?query=$Query&options=$Options"
        $ResultData = ConvertFrom-Csv $Result
        if ($ResultData) {
            $ResultData
        } else {
            Write-Host "Error: No DNS logs returned." -ForegroundColor Red
        }
    } else {
        Write-DebugMsg -Query ($splat | ConvertTo-Json -Depth 4)
        $Result = Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/api/cubejs/v1/query?query=$Query"
        if ($Result.result.data) {
            $Result.result.data | Select-Object @{name="ip";Expression={$_.'NstarDnsActivity.device_ip'}},`
                                         @{name="name";Expression={$_.'NstarDnsActivity.device_name'}},`
                                         @{name="dhcp_fingerprint";Expression={$_.'NstarDnsActivity.dhcp_fingerprint'}},`
                                         @{name="dns_view";Expression={$_.'NstarDnsActivity.dns_view'}},`
                                         @{name="mac_address";Expression={$_.'NstarDnsActivity.mac_address'}},`
                                         @{name="query";Expression={$_.'NstarDnsActivity.qname'}},`
                                         @{name="query_nanosec";Expression={$_.'NstarDnsActivity.query_nanosec'}},`
                                         @{name="query_type";Expression={$_.'NstarDnsActivity.query_type'}},`
                                         @{name="response";Expression={$_.'NstarDnsActivity.response'}},`
                                         @{name="timestamp";Expression={$_.'NstarDnsActivity.timestamp'}},
                                         @{name="dns_server";Expression={$siteId = $_.'NstarDnsActivity.site_id'; (@($DNSServices).where({ $_.site_id -eq $siteId })).name}}
        } else {
            Write-Host "Error: No DNS logs returned." -ForegroundColor Red
        }
    }
}