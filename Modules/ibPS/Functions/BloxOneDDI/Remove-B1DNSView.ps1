function Remove-B1DNSView {
    <#
    .SYNOPSIS
        Removes a DNS View from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a DNS View from BloxOneDDI

    .PARAMETER Name
        The name of the DNS View to remove

    .PARAMETER id
        The id of the DNS View. Accepts pipeline input

    .Example
        Remove-B1DNSView -Name "My DNS View"

    .Example
        Get-B1DNSView -Name "My DNS View" | Remove-B1DNSView
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {

      if ($id) {
        $ViewInfo = Get-B1DNSView -id $id
      } else {
        $ViewInfo = Get-B1DNSView -Name $Name -Strict
      }

      if (($ViewInfo | Measure-Object).Count -gt 1) {
        Write-Host "More than one DNS Views returned. These will not be removed. Please pipe Get-B1DNSView into Remove-B1DNSView to remove multiple objects." -ForegroundColor Red
        $ViewInfo | Format-Table -AutoSize
      } elseif (($ViewInfo | Measure-Object).Count -eq 1) {
        Write-Host "Removing DNS View: $($ViewInfo.Name).." -ForegroundColor Yellow
        Query-CSP -Method "DELETE" -Uri $($ViewInfo.id) -Data $null | Out-Null
        $SI = Get-B1DNSView -id $($ViewInfo.id) 6> $null
        if ($SI) {
          Write-Host "Failed to remove DNS View: $($SI.Name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed DNS View: $($ViewInfo.Name)" -ForegroundColor Green
        }
      } else {
        Write-Host "DNS View does not exist." -ForegroundColor Gray
      }
    }
}