function Remove-B1DNSConfigProfile {
    <#
    .SYNOPSIS
        Removes a DNS Config Profile

    .DESCRIPTION
        This function is used to remove a DNS Config Profile

    .PARAMETER Name
        The name of the DNS Config Profile to remove

    .PARAMETER id
        The id of the DNS Config Profile to remove. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1DNSConfigProfile -Name "My Config Profile"

    .EXAMPLE
        PS> Get-B1DNSConfigProfile -Name "My Config Profile" | Remove-B1DNSConfigProfile

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
        $ConfigProfile = Get-B1DNSConfigProfile -Name $Name -Strict
      } elseif ($id) {
        $ConfigProfile = Get-B1DNSConfigProfile -id $id
      } else {
        Write-Error "Neither -Name or -id were specified in the request."
      }

      if ($ConfigProfile) {
        Invoke-CSP -Method DELETE -Uri "$($ConfigProfile.id)"
        if ($Name) {
            $ConfigProfileCheck = Get-B1DNSConfigProfile -Name $Name -Strict
        } elseif ($id) {
            $ConfigProfileCheck = Get-B1DNSConfigProfile -id $id -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 6> $null
        }
        if ($ConfigProfileCheck) {
            Write-Error "Failed to delete DNS Config Profile: $($ConfigProfile.name)"
        } else {
            Write-Host "Successfully deleted DNS Config Profile: $($ConfigProfile.name)" -ForegroundColor Green
        }
      } else {
        Write-Error "Unable to find DNS Config Profile: $id$Name"
      }
    }
}