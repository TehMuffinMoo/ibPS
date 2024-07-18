function Remove-B1DNSView {
    <#
    .SYNOPSIS
        Removes a DNS View from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a DNS View from BloxOneDDI

    .PARAMETER Name
        The name of the DNS View to remove

    .PARAMETER Object
        The DNS View Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DNSView -Name "My DNS View"

    .EXAMPLE
        PS> Get-B1DNSView -Name "My DNS View" | Remove-B1DNSView

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DNS
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
          if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/view") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/view' objects as input"
              return $null
          }
      } else {
          $Object = Get-B1DNSView -Name $Name -Strict
          if (!($Object)) {
              Write-Error "Unable to find DNS View: $($Name)"
              return $null
          }
          if ($Object.count -gt 1) {
              Write-Error "Multiple DNS Views were found, to remove more than one DNS View you should pass those objects using pipe instead."
              return $null
          }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        Write-Host "Removing DNS View: $($Object.Name).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" | Out-Null
        $SI = Get-B1DNSView -id $($Object.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove DNS View: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed DNS View: $($Object.Name)" -ForegroundColor Green
        }
      }
    }
}