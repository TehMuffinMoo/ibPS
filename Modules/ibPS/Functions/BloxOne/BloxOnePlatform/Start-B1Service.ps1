function Start-B1Service {
    <#
    .SYNOPSIS
        Starts a BloxOneDDI Service

    .DESCRIPTION
        This function is used to start a BloxOneDDI Service

    .PARAMETER Name
        The name of the BloxOneDDI Service to start

    .PARAMETER id
        The id of the BloxOneDDI Service to start. Accepts pipeline input

    .EXAMPLE
        PS> Start-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Service
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($id) {
        $B1Service = Get-B1Service -id $id
      } else {
        $B1Service = Get-B1Service -Name $Name -Strict
      }
      if ($B1Service.count -gt 1) {
          Write-Host "More than one service returned. Check the parameters entered and pipe Get-B1Service to Start-B1Service if multiple actions are required." -ForegroundColor Red
          $B1Service | Format-Table name,service_type,@{label='host_id';e={$_.configs.host_id}} -AutoSize
      } elseif ($B1Service) {
          Write-Host "Starting $($B1Service.name).." -ForegroundColor Cyan
          $B1Service.desired_state = "start"
          $splat = $B1Service | ConvertTo-Json -Depth 3 -Compress
          $ServiceId = $($B1Service.id).replace("infra/service/","") ## ID returned from API doesn't match endpoint? /infra/service not /infra/v1/services
          $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/services/$ServiceId" -Data $splat
          if ($Results.result.desired_state -eq "start") {
            Write-Host "Service started successfully" -ForegroundColor Green
          } else {
            Write-Host "Failed to start service." -ForegroundColor Red
          }
      }
    }
}