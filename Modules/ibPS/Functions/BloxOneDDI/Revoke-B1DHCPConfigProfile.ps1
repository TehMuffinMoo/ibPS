function Revoke-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Removes a DHCP Config Profile from one or more BloxOneDDI hosts

    .DESCRIPTION
        This function is used to remove a DHCP Config Profile from one or more BloxOneDDI hosts

    .PARAMETER Name
        The name of the DHCP Config Profile to remove

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to remove the DHCP Config Profile from

    .EXAMPLE
        PS> Revoke-B1DHCPConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    [Alias("Remove-B1HostDHCPConfigProfile")]
    param(
        [Parameter(Mandatory=$true)]
        [System.Object]$Hosts
    )

    $DHCPConfigProfileId = (Get-B1DHCPConfigProfile -Name $Name).id
    if (!$DHCPConfigProfileId) {
        Write-Host "Failed to get DHCP Config Profile: $Name." -ForegroundColor Red
        break
    }
    
    foreach ($DHCPHost in $Hosts) {
        $DHCPHostId = (Get-B1DHCPHost -Name $DHCPHost).id

        $splat = @{
            "server" = $null
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method "PATCH" -Uri "$DHCPHostId" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $null) {
            Write-Host "DHCP Config Profiles have been successfully removed from $DHCPHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to remove DHCP Config Profiles from $DHCPHost" -ForegroundColor Red
        }
    }
}