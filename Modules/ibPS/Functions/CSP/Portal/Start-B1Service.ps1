function Start-B1Service {
    <#
    .SYNOPSIS
        Starts a Infoblox Portal service

    .DESCRIPTION
        This function is used to start an Infoblox Portal service

    .PARAMETER Name
        The name of the service to start

    .PARAMETER Object
        The Infoblox Portal Service Object(s) to start. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Start-B1Service -Name "dns_ddihost1.mydomain.corp"

    .FUNCTIONALITY
        NIOS-X

    .FUNCTIONALITY
        Service
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Medium'
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
              Write-Error "Unable to find Service: $($Name)"
              return $null
          }
          $ServiceID = $Object.id
      }

      if($PSCmdlet.ShouldProcess("Start Service: $($Object.name)","Start Service: $($Object.name)",$MyInvocation.MyCommand)){
        Write-Host "Starting $($Object.name).." -ForegroundColor Cyan
        $Object.desired_state = "start"
        $JSON = $Object | ConvertTo-Json -Depth 3 -Compress
        $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/services/$ServiceID" -Data $JSON
        if ($Results.result.desired_state -eq "start") {
          Write-Host "Service started successfully" -ForegroundColor Green
        } else {
          Write-Host "Failed to start service." -ForegroundColor Red
        }
      }
    }
}