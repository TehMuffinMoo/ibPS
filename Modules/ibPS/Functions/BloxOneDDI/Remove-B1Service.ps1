function Remove-B1Service {
    <#
    .SYNOPSIS
        Removes an existing BloxOneDDI Service

    .DESCRIPTION
        This function is used to remove an existing BloxOneDDI Service

    .PARAMETER Name
        The name of the BloxOneDDI Service to remove

    .PARAMETER id
        The id of the BloxOneDDI Host. Accepts pipeline input

    .PARAMETER NoWarning
        Using -NoWarning will stop warnings prior to deleting a host

    .Example
        Remove-B1Service -Name "dns_bloxoneddihost1.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Service
    #>
    param(
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id,
      [Switch]$NoWarning
    )

    process {
      if ($id) {
        if ($id -like "infra/service/*") {
          $idshort = $id.replace("infra/service/","")
        } else {
          $idshort = $id
        }
        $B1Service = Get-B1Service -id $idshort -Detailed
      } else {
        $B1Service = Get-B1Service -Name $Name -Strict -Detailed
      }
  
      if ($B1Service.count -gt 1) {
        Write-Host "More than one service returned. Check the name/id or pipe Get-B1Service into Remove-B1Service when removing multiple objects." -ForegroundColor Red
        $B1Service | Format-Table name,service_type,@{label='host_id';e={$_.configs.host_id}} -AutoSize
      } elseif ($B1Service) {

        if (!$NoWarning) {
          Write-Warning "Are you sure you want to delete: $($B1Service.name)?" -WarningAction Inquire
        }

        Write-Host "Removing $($B1Service.name).." -ForegroundColor Cyan
        Query-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/infra/v1/services/$($B1Service.id)" | Out-Null
        $B1S = Get-B1Service -id $($B1Service.id) -Detailed
        if ($B1S) {
          Write-Host "Failed to delete service: $($B1S.name)" -ForegroundColor Red
        } else {
          Write-Host "Service deleted successfully: $($B1Service.name)." -ForegroundColor Green
        }
      }
    }
}