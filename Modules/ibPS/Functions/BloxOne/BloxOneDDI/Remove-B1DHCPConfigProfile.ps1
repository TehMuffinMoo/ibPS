function Remove-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Removes a DHCP Config Profile

    .DESCRIPTION
        This function is used to remove a DHCP Config Profile

    .PARAMETER Name
        The name of the DHCP Config Profile to remove

    .PARAMETER id
        The id of the DHCP Config Profile to remove. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1DHCPConfigProfile -Name "My Config Profile"

    .EXAMPLE
        PS> Get-B1DHCPConfigProfile -Name "My Config Profile" | Remove-B1DHCPConfigProfile
   
    .FUNCTIONALITY
        BloxOneDDI

    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($Name) {
        $ConfigProfile = Get-B1DHCPConfigProfile -Name $Name -Strict
      } elseif ($id) {
        $ConfigProfile = Get-B1DHCPConfigProfile -id $id
      } else {
        Write-Error "Neither -Name or -id were specified in the request."
      }

      if ($ConfigProfile) {
        Query-CSP -Method DELETE -Uri "$($ConfigProfile.id)"
        if ($Name) {
            $ConfigProfileCheck = Get-B1DHCPConfigProfile -Name $Name -Strict
        } elseif ($id) {
            $ConfigProfileCheck = Get-B1DHCPConfigProfile -id $id -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 6> $null
        }
        if ($ConfigProfileCheck) {
            Write-Error "Failed to delete DHCP Config Profile: $($ConfigProfile.name)"
        } else {
            Write-Host "Successfully deleted DHCP Config Profile: $($ConfigProfile.name)" -ForegroundColor Green
        }
      } else {
        Write-Error "Unable to find DHCP Config Profile: $id$Name"
      }
    }
}