function Remove-B1ForwardZone {
    <#
    .SYNOPSIS
        Removes a Authoritative Zone from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a Authoritative Zone from BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to remove

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER id
        The id of the authoritative zone. Accepts pipeline input

    .Example
        Remove-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true,ParameterSetName="noID")]
      [String]$FQDN,
      [Parameter(Mandatory=$true,ParameterSetName="noID")]
      [System.Object]$View,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process { 
      if ($id) {
        $Zone = Get-B1ForwardZone -id $id
      } else {
        $Zone = Get-B1ForwardZone -FQDN $FQDN -Strict -View $View
      }
      if ($Zone) {
        Query-CSP -Method "DELETE" -Uri "$($Zone.id)" | Out-Null
        $B1Zone = Get-B1ForwardZone -id $($Zone.id)
        if ($B1Zone) {
            Write-Host "Error. Failed to delete Forward Zone: $($B1Zone.fqdn)" -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted Forward Zone: $($Zone.fqdn)" -ForegroundColor Green
        }
      } else {
        Write-Host "Forward Zone $FQDN$id does not exist." -ForegroundColor Yellow
      }
    }
}