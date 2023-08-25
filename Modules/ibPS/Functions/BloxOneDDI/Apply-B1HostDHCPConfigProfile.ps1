function Apply-B1HostDHCPConfigProfile {
    <#
    .SYNOPSIS
        Applies a DHCP Config Profile to one or most BloxOneDDI Hosts

    .DESCRIPTION
        This function is used to apply a DHCP Config Profile to one or most BloxOneDDI Hosts

    .PARAMETER Name
        The name of the new DHCP Config Profile

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to apply the DHCP Config Profile to

    .Example
        Apply-B1HostDHCPConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [System.Object]$Hosts
    )

    $DHCPConfigProfileId = (Get-B1DHCPConfigProfile -Name $Name -Strict).id
    if (!$DHCPConfigProfileId) {
        Write-Host "Failed to get DHCP Config Profile." -ForegroundColor Red
    }
    
    foreach ($DHCPHost in $Hosts) {
        $DHCPHostId = (Get-B1DHCPHost -Name $DHCPHost).id

        $splat = @{
            "server" = $DHCPConfigProfileId
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method "PATCH" -Uri "$DHCPHostId" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $DHCPConfigProfileId) {
            Write-Host "DHCP Config Profile `"$Name`" has been successfully applied to $DHCPHost" -ForegroundColor Green
        } else {
            Write-Host "Failed to apply DHCP Config Profile `"$Name`" to $DHCPHost" -ForegroundColor Red
        }
    }
}