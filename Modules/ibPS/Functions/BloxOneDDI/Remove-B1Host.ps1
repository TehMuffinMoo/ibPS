function Remove-B1Host {
    <#
    .SYNOPSIS
        Removes an existing BloxOneDDI Host

    .DESCRIPTION
        This function is used to remove an existing BloxOneDDI Host

    .PARAMETER Name
        The name of the BloxOneDDI host to remove

    .PARAMETER id
        The id of the BloxOneDDI Host. Accepts pipeline input

    .PARAMETER Confirm
        Using -NoWarning will stop warnings prior to deleting a host

    .Example
        Remove-B1Host -Name "bloxoneddihost1.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
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
        if ($id -like "infra/host/*") {
          $idshort = $id.replace("infra/host/","")
        }
        $hostID = Get-B1Host -id $idshort -Detailed
      } else {
        $hostID = Get-B1Host -Name $Name -Strict -Detailed
      }
      if ($hostID) {

        if (!$NoWarning) {
          Write-Warning "Are you sure you want to delete: $($hostID.display_name)?" -WarningAction Inquire
        }

        Query-CSP -Method DELETE -Uri "https://csp.infoblox.com/api/infra/v1/hosts/$($hostID.id)"
        if ($id) {
          $HID = Get-B1Host -id $idshort -Detailed
        } else {
          $HID = Get-B1Host -Name $Name -Strict
        }
        if ($HID) {
          Write-Host "Error. Failed to delete BloxOneDDI Host: $($HID.display_name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully deleted BloxOneDDI Host: $($hostID.display_name)" -ForegroundColor Green
        }
      } else {
        Write-Host "Error. Unable to find Host ID: $Name$id" -ForegroundColor Red
      }
    }
}