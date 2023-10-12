function New-B1ForwardZone {
    <#
    .SYNOPSIS
        Creates a new Forward Zone in BloxOneDDI

    .DESCRIPTION
        This function is used to create a new Forward Zone in BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to create

    .PARAMETER View
        The DNS View the zone will be created in

    .PARAMETER Forwarders
        A list of IPs/FQDNs to forward requests to

    .PARAMETER DNSHosts
        A list of DNS Hosts to assign to the zone

    .PARAMETER Description
        The description for the new zone

    .Example
        New-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -Description "My Forward Zone"
   
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
      [Parameter(Mandatory=$true)]
      $Forwarders,
      $DNSHosts,
      [String]$Description
    )

    if (Get-B1ForwardZone -FQDN $FQDN -View $View) {
        Write-Host "The $FQDN Zone already exists in DNS." -ForegroundColor Red
    } else {

        $ViewUUID = (Get-B1DNSView -Name $View -Strict).id

        if ($Forwarders.GetType().Name -eq "Object[]") {
            $ExternalHosts = New-Object System.Collections.ArrayList
            foreach ($Forwarder in $Forwarders) {
                $ExternalHosts.Add(@{"address"=$Forwarder;"fqdn"=$Forwarder;}) | Out-Null
            }
        } elseif ($Forwarders.GetType().Name -eq "ArrayList") {
            $ExternalHosts = $Forwarders
        } else {
            Write-Host "Error. Invalid data submitted in -ExternalHosts" -ForegroundColor Red
            break
        }

        $splat = @{
	        "fqdn" = $FQDN
	        "disabled" = $false
            "forward_only" = $true
	        "external_forwarders" = $ExternalHosts
	        "view" = $ViewUUID
        }

        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add((Get-B1DNSHost -Name $DNSHost).id) | Out-Null
            }
            $splat | Add-Member -Name "hosts" -Value $B1Hosts -MemberType NoteProperty
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "dns/forward_zone" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue

        if ($Result) {
            Write-Host "Created Forward DNS Zone $FQDN successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create Forward DNS Zone $FQDN." -ForegroundColor Red
        }
    }
}