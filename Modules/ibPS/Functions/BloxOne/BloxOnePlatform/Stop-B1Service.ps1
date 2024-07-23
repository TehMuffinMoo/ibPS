﻿function Stop-B1Service {
    <#
    .SYNOPSIS
        Stops a BloxOneDDI Service

    .DESCRIPTION
        This function is used to stop a BloxOneDDI Service

    .PARAMETER Name
        The name of the BloxOneDDI Service to stop

    .PARAMETER id
        The id of the BloxOneDDI Service to stop. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Stop-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Service
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
        )]
        [System.Object]$Object,
        [Switch]$Force
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      if ($Object) {
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/service") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/service' objects as input"
            break
          } else {
            $ServiceID = $SplitID[2]
          }
      } else {
          $Object = Get-B1Service -Name $Name -Strict -Detailed
          if (!($Object)) {
              Write-Error "Unable to find BloxOne Service: $($Name)"
              return $null
          }
          $ServiceID = $Object.id
      }

      if($PSCmdlet.ShouldProcess("Stop BloxOne Service: $($Object.name)","Stop BloxOne Service: $($Object.name)",$MyInvocation.MyCommand)){
        Write-Host "Stopping $($Object.name).." -ForegroundColor Cyan
        $Object.desired_state = "Stop"
        $JSON = $Object | ConvertTo-Json -Depth 3 -Compress
        $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/services/$ServiceID" -Data $JSON
        if ($Results.result.desired_state -eq "Stop") {
          Write-Host "Service stopped successfully" -ForegroundColor Green
        } else {
          Write-Host "Failed to stop service." -ForegroundColor Red
        }
      }
    }
}