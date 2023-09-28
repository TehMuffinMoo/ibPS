function Set-B1ForwardNSG {
    <#
    .SYNOPSIS
        Updates a Forward DNS Server Group in BloxOneDDI

    .DESCRIPTION
        This function is used to update a Forward DNS Server Group in BloxOneDDI

    .PARAMETER Name
        The name of the Forward DNS Server Group

    .PARAMETER AddHosts
        This switch indicates you are adding hosts to the Forward NSG using the -Hosts parameter

    .PARAMETER RemoveHosts
        This switch indicates you are removing hosts to the Forward NSG using the -Hosts parameter

    .PARAMETER Hosts
        This is a list of hosts to be added or removed from the Forward NSG, indicated by the -AddHosts & -RemoveHosts parameters

    .PARAMETER id
        The id of the forward DNS server group to update. Accepts pipeline input

    .Example
        Set-B1ForwardNSG -Name "InfoBlox DTC" -AddHosts -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Name,
      [Switch]$AddHosts,
      [Switch]$RemoveHosts,
      [System.Object]$Hosts,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($id) {
        $NSG = Get-B1ForwardNSG -id $id
      } else {
        $NSG = Get-B1ForwardNSG -Name $Name -Strict
      }
      if ($NSG) {
        $Update = $false
        if ($AddHosts -and $RemoveHosts) {
          Write-Host "Error. -AddHosts and -RemoveHosts are mutually exclusive." -ForegroundColor Red
        } else {
          if ($Hosts) {
            if ($AddHosts) {
              foreach ($B1Host in $Hosts) {
                $DNSHostId = (Get-B1DNSHost -Name $B1Host -Strict).id
                if ($DNSHostId) {
                  if ($DNSHostId -notin $NSG.hosts) {
                    $Update = $true
                    Write-Host "Adding $B1Host to $($NSG.name)" -ForegroundColor Cyan
                    $NSG.hosts += $DNSHostId
                  } else {
                    Write-Host "$B1Host is already in forward NSG: $($NSG.name)" -ForegroundColor Yellow
                  }
                } else {
                  Write-Host "Error. DNS Host $B1Host not found." -ForegroundColor Red
                }
              }
              if ($Update) {
                $splat = $NSG | select * -ExcludeProperty id | ConvertTo-Json -Depth 5 -Compress
                $Results = Query-CSP -Method PATCH -Uri $NSG.id -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                if ($Results.id -eq $NSG.id) {
                  Write-Host "Successfully updated Forward NSG: $($NSG.name)" -ForegroundColor Green
                } else {
                  Write-Host "Error. Failed to update Forward NSG: $($NSG.name)" -ForegroundColor Red
                }
              }
            } elseif ($RemoveHosts) {
              foreach ($B1Host in $Hosts) {
                $DNSHostId = (Get-B1DNSHost -Name $B1Host -Strict).id
                if ($DNSHostId) {
                  if ($DNSHostId -in $NSG.hosts) {
                    $Update = $true
                    Write-Host "Removing $B1Host from $($NSG.name)" -ForegroundColor Cyan
                    $NSG.hosts = $NSG.hosts | where {$_ -ne $DNSHostId}
                  } else {
                    Write-Host "$B1Host is not in forward NSG: $($NSG.name)" -ForegroundColor Yellow
                  }
                } else {
                  Write-Host "Error. DNS Host $B1Host not found." -ForegroundColor Red
                }
              }
              if ($Update) {
                $splat = $NSG | select * -ExcludeProperty id | ConvertTo-Json -Depth 5 -Compress
                $Results = Query-CSP -Method PATCH -Uri $NSG.id -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                if ($Results.id -eq $NSG.id) {
                  Write-Host "Successfully updated Forward NSG: $($NSG.name)" -ForegroundColor Green
                } else {
                  Write-Host "Error. Failed to update Forward NSG: $($NSG.name)" -ForegroundColor Red
                }
              }
            } else {
              Write-Host "Error. -AddHosts or -RemoveHosts was not specified." -ForegroundColor Red
            }
          }
        }
      }
    }
}