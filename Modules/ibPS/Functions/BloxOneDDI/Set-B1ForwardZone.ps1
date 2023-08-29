﻿function Set-B1ForwardZone {
    <#
    .SYNOPSIS
        Updates an existing Forward Zone in BloxOneDDI

    .DESCRIPTION
        This function is used to an existing Forward Zone in BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to update

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER Forwarders
        A list of IPs/FQDNs to forward requests to. This will overwrite existing values

    .PARAMETER DNSHosts
        A list of DNS Hosts to assign to the zone. This will overwrite existing values

    .PARAMETER DNSServerGroups
        A list of Forward DNS Server Groups to assign to the zone. This will overwrite existing values

    .Example
        Set-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -DNSServerGroups "Data Centre"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View,
      [String]$Forwarders,
      [System.Object]$DNSHosts,
      [String]$DNSServerGroups
    )

    $ForwardZone = Get-B1ForwardZone -FQDN $FQDN

    if ($ForwardZone) {
        $ForwardZoneUri = $ForwardZone.id

        $ForwardZonePatch = @{}

        if ($Forwarders) {
            if ($Forwarders.GetType().Name -eq "Object[]") {
                $ExternalHosts = New-Object System.Collections.ArrayList
                foreach ($Forwarder in $Forwarders) {
                    $ExternalHosts.Add(@{"address"=$Forwarder;"fqdn"=$Forwarder;}) | Out-Null
                }
            } elseif ($Forwarders.GetType().Name -eq "ArrayList") {
                $ExternalHosts = $Forwarders
            }
        }
                
        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add((Get-B1DNSHost -Name $DNSHost).id) | Out-Null
            }
        }

        if ($DNSServerGroups) {
            $B1ForwardNSGs = @()
            foreach ($DNSServerGroup in $DNSServerGroups) {
                $B1ForwardNSGs += (Get-B1ForwardNSG -Name $DNSServerGroup).id
            }
        }

        if ($ExternalHosts) {$ForwardZonePatch.external_forwarders = $ExternalHosts}
        if ($B1Hosts) {$ForwardZonePatch.hosts = $B1Hosts}
        if ($DNSServerGroups) {
            $ForwardZonePatch.nsgs = $B1ForwardNSGs
            $ForwardZonePatch.external_forwarders = @()
            $ForwardZonePatch.hosts = @()
        }

        if ($ForwardZonePatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $ForwardZonePatch | ConvertTo-Json -Depth 10
            if ($Debug) {$splat}

            $Result = Query-CSP -Method PATCH -Uri "$ForwardZoneUri" -Data $splat
        
            if (($Result | select -ExpandProperty result).fqdn -like "$FQDN*") {
                Write-Host "Updated Forward DNS Zone successfully." -ForegroundColor Green
            } else {
                Write-Host "Failed to update Forward DNS Zone." -ForegroundColor Red
                break
            }
        }

    } else {
        Write-Host "The Forward Zone $FQDN does not exist." -ForegroundColor Red
    }
}