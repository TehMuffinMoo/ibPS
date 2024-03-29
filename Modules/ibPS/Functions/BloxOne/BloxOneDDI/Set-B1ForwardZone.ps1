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

    .PARAMETER Tags
        Any tags you want to apply to the forward zone

    .PARAMETER id
        The id of the forward zone to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -DNSServerGroups "Data Centre"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$FQDN,
      $Forwarders,
      [System.Object]$DNSHosts,
      [String]$DNSServerGroups,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [System.Object]$View,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id

    )

    process {
      if ($id) {
        $ForwardZone = Get-B1ForwardZone -id $id
      } else {
        $ForwardZone = Get-B1ForwardZone -FQDN $FQDN
      }
 
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
          if ($Tags) {$ForwardZonePatch.tags = $Tags}
          if ($DNSServerGroups) {
              $ForwardZonePatch.nsgs = $B1ForwardNSGs
              $ForwardZonePatch.external_forwarders = @()
              $ForwardZonePatch.hosts = @()
          }

          if ($ForwardZonePatch.Count -eq 0) {
              Write-Host "Nothing to update." -ForegroundColor Gray
          } else {
              $splat = $ForwardZonePatch | ConvertTo-Json -Depth 10
              if ($ENV:IBPSDebug -eq "Enabled") {$splat}

              $Result = Query-CSP -Method PATCH -Uri "$ForwardZoneUri" -Data $splat
          
              if (($Result | Select-Object -ExpandProperty result).id -eq $ForwardZone.id) {
                  Write-Host "Updated Forward DNS Zone successfully: $($ForwardZone.fqdn)" -ForegroundColor Green
                  return $Result | Select-Object -ExpandProperty result
              } else {
                  Write-Host "Failed to update Forward DNS Zone: $($ForwardZone.fqdn)" -ForegroundColor Red
                  break
              }
          }
  
      } else {
          Write-Host "The Forward Zone $FQDN$id does not exist." -ForegroundColor Red
      }
    }
}