function Get-B1DTCStatus {
    <#
    .SYNOPSIS
        Retrieves a list BloxOne DTC LBDNs

    .DESCRIPTION
        This function is used to query a list BloxOne DTC LBDNs

    .PARAMETER LBDN
        The name of the DTC LBDN to get the status for

    .PARAMETER Raw
        This switch indicates whether to return raw or parsed results. The default is parsed (-Raw:$false)

    .PARAMETER id
        The id of the DTC LBDN to get the status for. Accepts pipeline input from Get-B1DTCLBDN

    .EXAMPLE
        PS> Get-B1DTCLBDN -Name 'email.domain.corp' | Get-B1DTCStatus

        [LBDN]  email.domain.corp
          [Policy]  Exchange
            [B1Host]  B1-1
              [Pool]  HEALTHY: Exchange
                [Server]  HEALTHY: EXCHANGE-MAIL01
                  [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:15
                  [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:24:45
                [Server]  HEALTHY: EXCHANGE-MAIL02
                  [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:10
                  [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:24:38
          [Policy]  Exchange
            [B1Host]  B1-2
              [Pool]  HEALTHY: Exchange
                [Server]  HEALTHY: EXCHANGE-MAIL01
                  [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:08
                  [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:25:16
                [Server]  HEALTHY: EXCHANGE-MAIL02
                  [HealthCheck]  HEALTHY: Exchange-HTTPS - 04/16/2024 08:25:13
                  [HealthCheck]  HEALTHY: ICMP Health Check - 04/16/2024 08:25:08
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [Parameter(
            ParameterSetName='None',
            Mandatory=$true
        )]
        [String]$LBDN,
        [Switch]$Raw,
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'With ID',
            Mandatory=$true
        )]
        [String[]]$id
    )
    process {
        $Colours = @{
            "HEALTHY" = "Green"
            "ERROR" = "Red"
            "NOT_CONFIGURED" = "Gray"
            "PRESUMED_HEALTHY" = "DarkYellow"
            "PENDING" = "Gray"
            "UNHEALTHY" = "Yellow"
            "WARNING" = "Yellow"
        }
        if ($LBDN) {
            $LBDNItem = Get-B1DTCLBDN -Name $LBDN -Strict
            if (!($LBDNItem)) {
                Write-Error "Could not find LBDN with name: $($LBDN)"
                return $null
            } else {
                $LBDNID = $LBDNItem.id
            }
        }
        if ($id) {
            if (($id.split('/')[1]) -ne "lbdn") {
                Write-Error "Error. Unsupported pipeline object. Input is only supported from Get-B1DTCLBDN"
                return $null
            }
            $LBDNID = $id
        }

        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($LBDNID)/report"
        if ($Results) {
            if ($Raw) {
                return $Results
            } else {
                if (!($LBDNItem)) {
                    $LBDNItem = Get-B1DTCLBDN -id $LBDNID
                }
                $PolicyItem = Get-B1DTCPolicy -id $Results.policy
                $B1Hosts = @()
                foreach ($OPHID in $Results.ophids) {
                    $B1Hosts += Get-B1Host -OPHID $OPHID
                }
                # $Report = [PSCustomObject]@{
                #     "LBDN" = $LBDNItem.name
                #     "Policy" = $PolicyItem.name
                #     "B1 Hosts" = $B1Hosts.display_name
                # }
                Write-Host "[LBDN]  $($LBDNItem.name)" -ForegroundColor DarkYellow
                $B1HostCount = 0
                foreach ($PolicyReportItem in $($Results.reports.PSObject.Properties.Value)) {
                    Write-Colour "  [Policy]  ","$($PolicyReportItem.display_name)" -Colour DarkMagenta,Gray
                    foreach ($HostReportItem in $($PolicyReportItem.reports.PSObject.Properties.Value)) {
                        $B1HostName = ($B1Hosts | where {$_.ophid -eq $($Results.reports.PSObject.Properties.Name)[$B1HostCount]}).display_name
                        Write-Colour "    [B1Host]  ","$($B1HostName)" -Colour DarkGreen,Gray
                        Write-Colour "      [Pool]  ","$($HostReportItem.status): ","$($HostReportItem.display_name)" -Colour Cyan,$($Colours[$HostReportItem.status]),'Gray'
                        foreach ($ServerReportItem in $($HostReportItem.reports.PSObject.Properties.Value)) {
                            Write-Colour "        [Server]  ","$($ServerReportItem.status): ","$($ServerReportItem.display_name)" -Colour DarkCyan,$($Colours[$ServerReportItem.status]),'Gray'
                            foreach ($HealthCheckReportItem in $($ServerReportItem.reports.PSObject.Properties.Value)) {
                                Write-Colour "          [HealthCheck]  ","$($HealthCheckReportItem.status): ","$($HealthCheckReportItem.display_name)"," - $($HealthCheckReportItem.last_reported)" -Colour DarkBlue,$($Colours[$HealthCheckReportItem.status]),'Gray','Gray'
                            }
                        }
                    }
                    $B1HostCount += 1
                }
                # return $Report
            }
        }
    }
}