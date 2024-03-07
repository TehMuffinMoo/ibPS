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

    .PARAMETER NoWarning
        Using -NoWarning will stop warnings prior to deleting a host

    .EXAMPLE
        PS> Remove-B1Host -Name "bloxoneddihost1.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id,
      [Switch]$NoWarning
    )
    
    process {

      if ($id) {
        if ($id -like "infra/host/*") {
          $idshort = $id.replace("infra/host/","")
        } else {
          $idshort = $id
        }
        $hostID = Get-B1Host -id $idshort -Detailed
      } else {
        $hostID = Get-B1Host -Name $Name -Strict -Detailed
      }
      if ($hostID) {

        if (!$NoWarning) {
          Write-Warning "Are you sure you want to delete: $($hostID.display_name)?" -WarningAction Inquire
        }

        Query-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/infra/v1/hosts/$($hostID.id)" | Out-Null
        $HID = Get-B1Host -id $($hostID.id) -Detailed

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