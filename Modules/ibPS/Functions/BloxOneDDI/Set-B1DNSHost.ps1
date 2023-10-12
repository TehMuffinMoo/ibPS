function Set-B1DNSHost {
    <#
    .SYNOPSIS
        Updates an existing DNS Host

    .DESCRIPTION
        This function is used to updates an existing DNS Host

    .PARAMETER Name
        The name of the BloxOneDDI DNS Host

    .PARAMETER DNSConfigProfile
        The name of the DNS Config Profile to apply to the DNS Host. This will overwrite the existing value.

    .PARAMETER DNSName
        The DNS FQDN to use for this DNS Server. This will overwrite the existing value.

    .Example
        Set-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -DNSConfigProfile "Data Centre" -DNSName "bloxoneddihost1.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [String]$DNSConfigProfile,
        [String]$DNSName
    )
    $DNSHost = Get-B1DNSHost -Name $Name -Strict
    if ($DNSHost) {
      $splat = @{}
        
      if ($DNSConfigProfile) {
        $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $DNSConfigProfile -Strict).id
        $splat.inheritance_sources = @{
          "kerberos_keys" = @{
  	        "action" = "inherit"
          }
	    }
        $splat.type = "bloxone_ddi"
        $splat.associated_server = @{
          "id" = $DNSConfigProfileId
        }
      }

      if ($DNSName) {
        $splat.absolute_name = $DNSName
      }

      $splat = $splat | ConvertTo-Json
      if ($debug) {$splat}
      $Results = Query-CSP -Method PATCH -Uri $($DNSHost.id) -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue

      if ($($Results.id) -eq $($DNSHost.id)) {
          Write-Host "DNS Host: $($DNSHost.absolute_name) updated successfully." -ForegroundColor Green
      } else {
          Write-Host "Failed to update DNS Host: $($DNSHost.absolute_name)." -ForegroundColor Red
      }
    }
}