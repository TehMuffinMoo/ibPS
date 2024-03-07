function Remove-B1Space {
    <#
    .SYNOPSIS
        Removes an IP Space from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to remove an IP Space from BloxOneDDI IPAM

    .PARAMETER Name
        The name of the IP Space to remove

    .PARAMETER id
        The id of the IP Space. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1Space -Name "My IP Space"

    .EXAMPLE
        PS> Get-B1Space -Name "My IP Space" | Remove-B1Space
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {

      if ($id) {
        $SpaceInfo = Get-B1Space -id $id
      } else {
        $SpaceInfo = Get-B1Space -Name $Name -Strict
      }

      if (($SpaceInfo | Measure-Object).Count -gt 1) {
        Write-Host "More than one IP Spaces returned. These will not be removed. Please pipe Get-B1Space into Remove-B1Space to remove multiple objects." -ForegroundColor Red
        $SpaceInfo | Format-Table -AutoSize
      } elseif (($SpaceInfo | Measure-Object).Count -eq 1) {
        Write-Host "Removing IP Space: $($SpaceInfo.Name).." -ForegroundColor Yellow
        Query-CSP -Method "DELETE" -Uri $($SpaceInfo.id) -Data $null | Out-Null
        $SI = Get-B1Space -id $($SpaceInfo.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove IP Space: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed IP Space: $($SpaceInfo.Name)" -ForegroundColor Green
        }
      } else {
        Write-Host "IP Space does not exist." -ForegroundColor Gray
      }
    }
}