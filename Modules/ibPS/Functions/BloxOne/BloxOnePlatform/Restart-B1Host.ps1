function Restart-B1Host {
    <#
    .SYNOPSIS
        Restarts a BloxOneDDI Host

    .DESCRIPTION
        This function is used to initiate a reboot of a BloxOneDDI Host

    .PARAMETER B1Host
        The FQDN of the host to reboot

    .PARAMETER NoWarning
        If this parameter is used, there will be no prompt for confirmation before rebooting

    .PARAMETER id
        The id of the BloxOneDDI Host. Accepts pipeline input

    .EXAMPLE
        PS> Restart-B1Host -B1Host "bloxoneddihost1.mydomain.corp" -NoWarning

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
  param(
    [Parameter(ParameterSetName="Default",Mandatory=$true)]
    [Alias('OnPremHost')]
    [String]$B1Host,
    [Switch]$NoWarning,
    [Parameter(
      ValueFromPipelineByPropertyName = $true,
      ParameterSetName="With ID",
      Mandatory=$true
    )]
    [String]$id
  )

  process {
    if ($id) {
      $OPH = Get-B1Host -id $id
    } else {
      $OPH = Get-B1Host -Name $B1Host
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
      Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/atlas-onprem-diagnostic-service/v1/privilegedtask" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    } else {
      Write-Host "BloxOne Host $B1Host$id not found" -ForegroundColor Red
    }
  }
}