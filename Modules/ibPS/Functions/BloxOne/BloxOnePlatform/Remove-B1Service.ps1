function Remove-B1Service {
    <#
    .SYNOPSIS
        Removes an existing BloxOneDDI Service

    .DESCRIPTION
        This function is used to remove an existing BloxOneDDI Service

    .PARAMETER Name
        The name of the BloxOneDDI Service to remove

    .PARAMETER Object
        The BloxOneDDI Service Object(s) to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"

    .FUNCTIONALITY
        Universal DDI

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
              $Object = Get-B1Service -id $($Object.id) -Detailed
              if (-not $Object) {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/service' objects as input"
                return $null
              }
              $ServiceID = $Object.id
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

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($ServiceID))")){
        Write-Host "Removing $($Object.name).." -ForegroundColor Cyan
        Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/infra/v1/services/$($ServiceID)" | Out-Null
        $B1S = Get-B1Service -id $($Object.id) -Detailed
        if ($B1S) {
          Write-Host "Failed to delete service: $($B1S.name)" -ForegroundColor Red
        } else {
          Write-Host "Service deleted successfully: $($Object.name)." -ForegroundColor Green
        }
      }
    }
}