function Remove-B1HAGroup {
    <#
    .SYNOPSIS
        Removes a DHCP HA Group

    .DESCRIPTION
        This function is used to remove a DHCP HA Group

    .PARAMETER Name
        The name of the HA Group to remove

    .PARAMETER Object
        The HA Group Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1HAGroup -Name "My HA Group"

    .EXAMPLE
        PS> Get-B1HAGroup -Name "My HA Group" | Remove-B1HAGroup

    .FUNCTIONALITY
        BloxOneDDI
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [parameter(ParameterSetName="Default")]
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/ha_group") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/ha_group' objects as input"
            return $null
        }
      } else {
          $Object = Get-B1HAGroup -Name $Name -Strict
          if (!($Object)) {
              Write-Error "Unable to find HA Group: $($Name)."
              return $null
          }
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        $HAGroupCheck = Get-B1HAGroup -id $Object.id
        if ($HAGroupCheck) {
            Write-Error "Failed to delete HA Group: $($Object.name)"
        } else {
            Write-Host "Successfully deleted HA Group: $($Object.name)" -ForegroundColor Green
        }
      }
    }
}