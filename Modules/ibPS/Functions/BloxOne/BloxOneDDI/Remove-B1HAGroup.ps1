function Remove-B1HAGroup {
    <#
    .SYNOPSIS
        Removes a DHCP HA Group

    .DESCRIPTION
        This function is used to remove a DHCP HA Group

    .PARAMETER Name
        The name of the HA Group to remove

    .PARAMETER id
        The id of the HA Group to remove. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1HAGroup -Name "My HA Group"

    .EXAMPLE
        PS> Get-B1HAGroup -Name "My HA Group" | Remove-B1HAGroup

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
        $HAGroup = Get-B1HAGroup -Name $Name -Strict
      } elseif ($id) {
        $HAGroup = Get-B1HAGroup -id $id
      } else {
        Write-Error "Neither -Name or -id were specified in the request."
      }

      if ($HAGroup) {
        Invoke-CSP -Method DELETE -Uri "$($HAGroup.id)"
        if ($Name) {
            $HAGroupCheck = Get-B1HAGroup -Name $Name -Strict
        } elseif ($id) {
            $HAGroupCheck = Get-B1HAGroup -id $id -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 6> $null
        }
        if ($HAGroupCheck) {
            Write-Error "Failed to delete HA Group: $($HAGroup.name)"
        } else {
            Write-Host "Successfully deleted HA Group: $($HAGroup.name)" -ForegroundColor Green
        }
      } else {
        Write-Error "Unable to find HA Group: $id$Name"
      }
    }
}