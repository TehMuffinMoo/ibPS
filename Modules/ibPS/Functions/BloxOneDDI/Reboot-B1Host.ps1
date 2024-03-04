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

    .PARAMETER id
        The id of the BloxOneDDI Host. Accepts pipeline input

    .EXAMPLE
        PS> Reboot-B1Host -OnPremHost "bloxoneddihost1.mydomain.corp" -NoWarning
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Host
    #>
  param(
    [Parameter(ParameterSetName="noID",Mandatory=$true)]
    [String]$OnPremHost,
    [Switch]$NoWarning,
    [Parameter(
      ValueFromPipelineByPropertyName = $true,
      ParameterSetName="ID",
      Mandatory=$true
    )]
    [String]$id
  )

  if ($id) {
    $OPH = Get-B1Host -id $id
  } else {
    $OPH = Get-B1Host -Name $OnPremHost
  }

  if ($OPH.id) {
    $splat = @{
      "ophid" = $OPH.ophid
      "cmd" = @{
        "name" = "reboot"
      }
    }
    if (!($NoWarning)) {
        Write-Warning "WARNING! Are you sure you want to reboot this host? $($OPH.display_name)" -WarningAction Inquire
    }
    Write-Host "Rebooting $($OPH.display_name).." -ForegroundColor Yellow
    $splat = $splat | ConvertTo-Json
    Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/atlas-onprem-diagnostic-service/v1/privilegedtask" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
  } else {
    Write-Host "BloxOne Host $OnPremHost$id not found" -ForegroundColor Red
  }
}