function Get-B1ServiceLog {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI Service Log

    .DESCRIPTION
        This function is used to query the BloxOneDDI Service Log. This log contains information from all containers on all BloxOneDDI Hosts, allowing you to query various types of diagnostic related data.

    .PARAMETER OnPremHost
        Use this parameter to filter the log for events relating to a specific BloxOneDDI Host

    .PARAMETER Container
        A pre-defined list of known containers to filter against.

    .PARAMETER Start
        A date parameter used as the starting date/time of the log search. By default, the search will start from 24hrs ago and returns the latest results first. You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

    .PARAMETER End
        A date parameter used as the end date/time of the log search.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default number of results is 100.

    .Example
        Get-B1ServiceLog -OnPremHost "bloxoneddihost1.mydomain.corp" -Container "DNS" -Start (Get-Date).AddHours(-2)
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Logs
    #>
    param(
      [string]$OnPremHost,
      [ValidateSet("DNS","DHCP","DFP", "NGC", "NTP","Host","Kube","NetworkMonitor","CDC-OUT","CDC-IN")]
      [string]$Container,
      [datetime]$Start = (Get-Date).AddDays(-1),
      [datetime]$End = (Get-Date),
      [Int]$Limit = 100
    )

    $Start = $Start.ToUniversalTime()
    $End = $End.ToUniversalTime()

    $Filters = @()
    if ($OnPremHost) {
        $OPHID = (Get-B1Host -Name $OnPremHost).ophid
        $Filters += "ophid=$OPHID"
    }
    if ($Container) {
        switch ($Container) {
            "DNS" {
                $ContainerName = "ns:dns"
            }
            "DHCP" {
                $ContainerName = "ns-dhcp:dhcp"
            }
            "DFP" {
                $ContainerName = "dfp_coredns_1"
            }
            "NGC" {
                $ContainerName = "ns:niosgridconnector"
            }
            "NTP" {
                $ContainerName = "ntp_ntp"
            }
            "Host" {
                $ContainerName = "host/init.scope"
            }
            "Kube" {
                $ContainerName = "k3s.service"
            }
            "NetworkMonitor" {
                $ContainerName = "host/network-monitor.service"
            }
            "CDC-OUT" {
                $ContainerName = "cdc_siem_out"
            }
            "CDC-IN" {
                $ContainerName = "cdc_rpz_in"
            }
        }
        $Filters += "container_name=$ContainerName"
    }

    if ($Limit) {
        $Filters += "_limit=$Limit"
    }

    $StartTime = $Start.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "start=$StartTime"

    $EndTime = $End.ToString("yyyy-MM-ddTHH:mm:ssZ")
    $Filters += "end=$EndTime"

    $QueryFilters = Combine-Filters2 -Filters $Filters

    $B1OnPremHosts = Get-B1Host -Detailed
    if ($QueryFilters) {
        $Results = Query-CSP -Uri "$(Get-B1CSPUrl)/atlas-logs/v1/logs$QueryFilters" -Method GET | Select -ExpandProperty logs | Select timestamp,@{Name = 'onpremhost'; Expression = {$ophid = $_.ophid; (@($B1OnPremHosts).where({ $_.ophid -eq $ophid })).display_name }},container_name,msg,ophid -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Uri "$(Get-B1CSPUrl)/atlas-logs/v1/logs" -Method GET | Select -ExpandProperty logs | Select timestamp,@{Name = 'onpremhost'; Expression = {$ophid = $_.ophid; (@($B1OnPremHosts).where({ $_.ophid -eq $ophid })).display_name }},container_name,msg,ophid -ErrorAction SilentlyContinue
    }
    if ($Results) {
        return $Results
    } else {
        Write-Host "Error. Unable to find any audit logs." -ForegroundColor Red
        break
    }
}