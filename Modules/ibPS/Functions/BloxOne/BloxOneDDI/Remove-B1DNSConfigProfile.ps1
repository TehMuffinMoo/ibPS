function Remove-B1DNSConfigProfile {
    <#
    .SYNOPSIS
        Removes a DNS Config Profile

    .DESCRIPTION
        This function is used to remove a DNS Config Profile

    .PARAMETER Name
        The name of the DNS Config Profile to remove

    .PARAMETER Object
        The DNS Config Profile Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DNSConfigProfile -Name "My Config Profile"

    .EXAMPLE
        PS> Get-B1DNSConfigProfile -Name "My Config Profile" | Remove-B1DNSConfigProfile

    .FUNCTIONALITY
        BloxOneDDI

    #>
    [CmdletBinding(
      DefaultParameterSetName="Default",
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [parameter(ParameterSetName="Default",Mandatory=$true)]
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
          if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/server") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/server' objects as input"
              return $null
          }
      } else {
          $Object = Get-B1DNSConfigProfile -Name $Name -Strict
          if (!($Object)) {
              Write-Error "Unable to find DNS Config Profile: $($Name)"
              return $null
          }
          if ($Object.count -gt 1) {
              Write-Error "Multiple DNS Config Profiles were found, to remove more than one DNS Config Profile you should pass those objects using pipe instead."
              return $null
          }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        $ConfigProfileCheck = Get-B1DNSConfigProfile -id $Object.id
        if ($ConfigProfileCheck) {
            Write-Error "Failed to delete DNS Config Profile: $($Object.name)"
        } else {
            Write-Host "Successfully deleted DNS Config Profile: $($Object.name)" -ForegroundColor Green
        }
      }
    }
}