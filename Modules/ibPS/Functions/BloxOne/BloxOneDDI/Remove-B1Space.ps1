function Remove-B1Space {
    <#
    .SYNOPSIS
        Removes an IP Space from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to remove an IP Space from BloxOneDDI IPAM

    .PARAMETER Name
        The name of the IP Space to remove

    .PARAMETER Object
        The IP Space Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Space -Name "My IP Space"

    .EXAMPLE
        PS> Get-B1Space -Name "My IP Space" | Remove-B1Space

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/ip_space") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/ip_space' objects as input"
            return $null
        }
      } else {
        $Object = Get-B1Space -Name $Name -Strict
        if (!($Object)) {
            Write-Error "Unable to find IP Space: $($Name)."
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        Write-Host "Removing IP Space: $($SpaceInfo.Name).." -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($SpaceInfo.id)" -Data $null | Out-Null
        $SI = Get-B1Space -id $($SpaceInfo.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove IP Space: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed IP Space: $($SpaceInfo.Name)" -ForegroundColor Green
        }
      }
    }
}