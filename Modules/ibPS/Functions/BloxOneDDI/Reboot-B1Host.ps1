function Reboot-B1Host {
    <#
    .SYNOPSIS
        Reboots a BloxOneDDI Host

    .DESCRIPTION
        This function is used to initiate a reboot of a BloxOneDDI Host

    .PARAMETER OnPremHost
        The FQDN of the host to reboot

    .PARAMETER NoWarning
        If this parameter is used, there will be no prompt for confirmation before rebooting

    .Example
        Reboot-B1Host -OnPremHost "bloxoneddihost1.mydomain.corp" -NoWarning
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Host
    #>
  param(
    [parameter(Mandatory=$true)]
               [String]$OnPremHost,
               [Switch]$NoWarning
  )

  $OPH = Get-B1Host -Name $OnPremHost
  if ($OPH.id) {
    $splat = @{
      "ophid" = $OPH.ophid
      "cmd" = @{
        "name" = "reboot"
      }
    }
    if (!($NoWarning)) {
        Write-Warning "WARNING! Are you sure you want to reboot this host? $OnPremHost" -WarningAction Inquire
    }
    Write-Host "Rebooting $OnPremHost.." -ForegroundColor Yellow
    $splat = $splat | ConvertTo-Json
    Query-CSP -Method POST -Uri "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/privilegedtask" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
  } else {
    Write-Host "On Prem Host $OnPremHost not found" -ForegroundColor Red
  }
}