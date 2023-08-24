function Remove-B1HostDNSConfigProfile {
    <#
    .SYNOPSIS
        Removes a DNS Config Profile from one or more BloxOneDDI hosts

    .DESCRIPTION
        This function is used to remove a DNS Config Profile from one or more BloxOneDDI hosts

    .PARAMETER Name
        The name of the DNS Config Profile to remove

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to remove the DNS Config Profile from

    .Example
        Remove-B1HostDNSConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
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
            "server" = $null
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method "PATCH" -Uri "$DNSHostId" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $null) {
            Write-Host "DNS Config Profiles have been successfully removed from $DNSHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to remove DNS Config Profiles from $DNSHost" -ForegroundColor Red
        }
    }
}