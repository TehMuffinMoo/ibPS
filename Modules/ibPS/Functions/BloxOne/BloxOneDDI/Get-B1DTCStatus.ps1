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

        [LBDN]  email.domain.corp.
          [Policy]  Exchange
            [B1Host]  B102
              [Pool]  HEALTHY: Exchange
                [Server]  HEALTHY: DTC-Exchange - 04/15/2024 21:20:59
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL01 - 04/15/2024 21:20:59
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL02 - 04/15/2024 21:20:59
              [Pool]  HEALTHY: Exchange
                [Server]  HEALTHY: DTC-Exchange - 04/15/2024 21:20:57
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL01 - 04/15/2024 21:20:57
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL02 - 04/15/2024 21:20:37
          [Policy]  Exchange
            [B1Host]  B101
              [Pool]  HEALTHY: Exchange
                [Server]  HEALTHY: DTC-Exchange - 04/15/2024 21:20:59
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL01 - 04/15/2024 21:20:59
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL02 - 04/15/2024 21:20:59
              [Pool]  HEALTHY: Exchange
                [Server]  HEALTHY: DTC-Exchange - 04/15/2024 21:20:57
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL01 - 04/15/2024 21:20:57
                  [HealthCheck]  HEALTHY: EXCHANGE-MAIL02 - 04/15/2024 21:20:37
    
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
            "NOTCONFIGURED" = "Gray"
            "PRESUMEDHEALTHY" = "Gray"
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
                        Write-Colour "    [B1Host]  ","$($B1HostName)" -Colour Magenta,Gray
                        foreach ($PoolReportItem in $($Results.reports.PSObject.Properties.Value)) {
                            Write-Colour "      [Pool]  ","$($PoolReportItem.status): ","$($PoolReportItem.display_name)" -Colour Cyan,$($Colours[$PoolReportItem.status]),'Gray'
                            foreach ($ServerReportItem in $($PoolReportItem.reports.PSObject.Properties.Value)) {
                                Write-Colour "        [Server]  ","$($ServerReportItem.status): ","$($ServerReportItem.display_name)"," - $($ServerReportItem.last_reported)" -Colour DarkBlue,$($Colours[$ServerReportItem.status]),'Gray','Gray'
                                foreach ($HealthCheckReportItem in $($ServerReportItem.reports.PSObject.Properties.Value)) {
                                    Write-Colour "          [HealthCheck]  ","$($HealthCheckReportItem.status): ","$($HealthCheckReportItem.display_name)"," - $($HealthCheckReportItem.last_reported)" -Colour White,$($Colours[$HealthCheckReportItem.status]),'Gray','Gray'
                                }
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