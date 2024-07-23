function Remove-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Removes a DHCP Config Profile

    .DESCRIPTION
        This function is used to remove a DHCP Config Profile

    .PARAMETER Name
        The name of the DHCP Config Profile to remove

    .PARAMETER Object
        The DHCP Config Profile Object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DHCPConfigProfile -Name "My Config Profile"

    .EXAMPLE
        PS> Get-B1DHCPConfigProfile -Name "My Config Profile" | Remove-B1DHCPConfigProfile

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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/server") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/server' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DHCPConfigProfile -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find DHCP Config Profile: $($Name)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple DHCP Config Profiles were found, to remove more than one DHCP Config Profile you should pass those objects using pipe instead."
                return $null
            }
        }

        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
            $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
            $ConfigProfileCheck = Get-B1DHCPConfigProfile -id $Object.id
            if ($ConfigProfileCheck) {
                Write-Error "Failed to delete DHCP Config Profile: $($Object.name)"
            } else {
                Write-Host "Successfully deleted DHCP Config Profile: $($Object.name)" -ForegroundColor Green
            }
        }
    }
}