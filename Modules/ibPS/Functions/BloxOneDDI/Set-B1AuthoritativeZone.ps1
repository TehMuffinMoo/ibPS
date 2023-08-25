function Set-B1AuthoritativeZone {
    <#
    .SYNOPSIS
        Updates an existing Authoritative Zone in BloxOneDDI

    .DESCRIPTION
        This function is used to an existing Authoritative Zone in BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to update

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER DNSHosts
        A list of DNS Hosts to assign to the zone. This will overwrite existing values

    .PARAMETER AddAuthNSGs
        A list of Authoritative DNS Server Groups to add to the zone.

    .PARAMETER RemoveAuthNSGs
        A list of Authoritative DNS Server Groups to remove from the zone.

    .PARAMETER Description
        The description for the zone to be updated to

    .Example
        Set-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -AddAuthNSGs "Data Centre"
   
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
      [System.Object]$DNSHosts,
      [System.Object]$AddAuthNSGs,
      [System.Object]$RemoveAuthNSGs,
      [String]$Description
    )

    $AuthZone = Get-B1AuthoritativeZone -FQDN $FQDN -View $View -Strict
    
    if ($AuthZone) {
        $AuthZoneUri = $AuthZone.id
        $AuthZonePatch = @{}

        if ($DNSHosts -or $AddAuthNSGs -or $RemoveAuthNSGs) {
            if ($DNSHosts) {
                $B1Hosts = New-Object System.Collections.ArrayList
                foreach ($DNSHost in $DNSHosts) {
                    $B1Hosts.Add(@{"host"=(Get-B1DNSHost -Name $DNSHost).id;}) | Out-Null
                }
                $AuthZonePatch.internal_secondaries = $B1Hosts
            }

            if ($AddAuthNSGs) {
                $B1AuthNSGs = @()
                if ($AuthZone.nsgs -gt 0) {
                    $B1AuthNSGs += $AuthZone.nsgs
                }
                foreach ($AuthNSG in $AddAuthNSGs) {
                    $B1AuthNSGs += (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
                }
                $AuthZonePatch.nsgs = @()
                $AuthZonePatch.nsgs += $B1AuthNSGs | select -Unique
            }

            if ($RemoveAuthNSGs) {
                $B1AuthNSGs = @()
                if ($AuthZone.nsgs -gt 0) {
                    $B1AuthNSGs += $AuthZone.nsgs
                }
                foreach ($AuthNSG in $RemoveAuthNSGs) {
                    $AuthNSGid = (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
                    $B1AuthNSGs = $B1AuthNSGs | where {$_ -ne $AuthNSGid}
                }
                $AuthZonePatch.nsgs = @()
                $AuthZonePatch.nsgs += $B1AuthNSGs | select -Unique
            }

        }
        if ($Description) {
            $AuthZonePatch.comment = $Description
        }
        
        if ($AuthZonePatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $AuthZonePatch | ConvertTo-Json -Depth 10
            $Result = Query-CSP -Method PATCH -Uri "$AuthZoneUri" -Data $splat
            if (($Result | select -ExpandProperty result).fqdn -like "$FQDN*") {
              Write-Host "Updated Authoritative DNS Zone: $FQDN successfully." -ForegroundColor Green
            } else {
              Write-Host "Failed to update Authoritative DNS Zone: $FQDN." -ForegroundColor Red
              break
            }
        }
        if ($Debug) {$splat}
       
    } else {
        Write-Host "The Authoritative Zone $FQDN does not exist." -ForegroundColor Red
    }
}