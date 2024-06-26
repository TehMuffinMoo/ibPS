﻿function Grant-B1DNSConfigProfile {
    <#
    .SYNOPSIS
        Applies a DNS Config Profile to one or most BloxOneDDI Hosts

    .DESCRIPTION
        This function is used to apply a DNS Config Profile to one or most BloxOneDDI Hosts

    .PARAMETER Name
        The name of the new DNS Config Profile

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to apply the DNS Config Profile to

    .EXAMPLE
        PS> Grant-B1DNSConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    [Alias("Apply-B1HostDNSConfigProfile")]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [System.Object]$Hosts
    )

    $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $Name -Strict).id
    if (!$DNSConfigProfileId) {
        Write-Host "Failed to get DNS Config Profile." -ForegroundColor Red
    }
    
    foreach ($DNSHost in $Hosts) {
        $DNSHostId = (Get-B1DNSHost -Name $DNSHost).id

        $splat = @{
            "server" = $DNSConfigProfileId
        }

        $splat = $splat | ConvertTo-Json

        $Result = Invoke-CSP -Method "PATCH" -Uri "$DNSHostId" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $DNSConfigProfileId) {
            Write-Host "DNS Config Profile `"$Name`" has been successfully applied to $DNSHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to apply DNS Config Profile `"$Name`" to $DNSHost" -ForegroundColor Red
        }
    }
}