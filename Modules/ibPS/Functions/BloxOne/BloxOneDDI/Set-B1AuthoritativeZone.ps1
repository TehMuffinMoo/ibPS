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

    .PARAMETER id
        The id of the authoritative zone to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -AddAuthNSGs "Data Centre"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$FQDN,
      [System.Object]$DNSHosts,
      [System.Object]$AddAuthNSGs,
      [System.Object]$RemoveAuthNSGs,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [System.Object]$View,
      [String]$Description,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {

      if ($id) {
        $AuthZone = Get-B1AuthoritativeZone -id $id
      } else {
        $AuthZone = Get-B1AuthoritativeZone -FQDN $FQDN -View $View -Strict
      }
    
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
                $AuthZonePatch.nsgs += $B1AuthNSGs | Select-Object -Unique
            }

            if ($RemoveAuthNSGs) {
                $B1AuthNSGs = @()
                if ($AuthZone.nsgs -gt 0) {
                    $B1AuthNSGs += $AuthZone.nsgs
                }
                foreach ($AuthNSG in $RemoveAuthNSGs) {
                    $AuthNSGid = (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
                    $B1AuthNSGs = $B1AuthNSGs | Where-Object {$_ -ne $AuthNSGid}
                }
                $AuthZonePatch.nsgs = @()
                $AuthZonePatch.nsgs += $B1AuthNSGs | Select-Object -Unique
            }

        }
        if ($Description) {
            $AuthZonePatch.comment = $Description
        }
        
        if ($AuthZonePatch.Count -eq 0) {
            Write-Host "Nothing to update." -ForegroundColor Gray
        } else {
            $splat = $AuthZonePatch | ConvertTo-Json -Depth 10
            $Result = Invoke-CSP -Method PATCH -Uri "$AuthZoneUri" -Data $splat
            if (($Result | Select-Object -ExpandProperty result).id -eq $($AuthZone.id)) {
              Write-Host "Updated Authoritative DNS Zone: $($AuthZone.fqdn) successfully." -ForegroundColor Green
            } else {
              Write-Host "Failed to update Authoritative DNS Zone: $($AuthZone.fqdn)." -ForegroundColor Red
              break
            }
        }
       
      } else {
        Write-Host "The Authoritative Zone $FQDN$id does not exist." -ForegroundColor Red
      }
    }
}