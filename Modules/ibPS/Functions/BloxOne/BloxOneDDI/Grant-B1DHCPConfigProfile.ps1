function Grant-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Applies a DHCP Config Profile to one or most BloxOneDDI Hosts

    .DESCRIPTION
        This function is used to apply a DHCP Config Profile to one or most BloxOneDDI Hosts

    .PARAMETER Name
        The name of the new DHCP Config Profile

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to apply the DHCP Config Profile to

    .EXAMPLE
        PS> Grant-B1DHCPConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    [Alias("Apply-B1HostDHCPConfigProfile")]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [System.Object]$Hosts,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {

      $LoopHosts = @()

      if ($id) {
        ## Not Implemented
      } else {
        foreach ($DHCPHost in $Hosts) {
          $LoopHosts += Get-B1DHCPHost -Name $DHCPHost -Strict
        }
      }

      $DHCPConfigProfileId = (Get-B1DHCPConfigProfile -Name $Name -Strict).id
      if (!$DHCPConfigProfileId) {
        Write-Host "Failed to get DHCP Config Profile." -ForegroundColor Red
        break
      }
    
      foreach ($LH in $LoopHosts) {
        $splat = @{
            "server" = $DHCPConfigProfileId
        }

        $splat = $splat | ConvertTo-Json

        $Result = Query-CSP -Method "PATCH" -Uri $($LH.id) -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.server -eq $DHCPConfigProfileId) {
            Write-Host "DHCP Config Profile `"$Name`" has been successfully applied to $($LH.name)" -ForegroundColor Green
        } else {
            Write-Host "Failed to apply DHCP Config Profile `"$Name`" to $($LH.name)" -ForegroundColor Red
        }
      }
    }
}