function Remove-B1ForwardZone {
    <#
    .SYNOPSIS
        Removes a Forward Zone from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a Forward Zone from BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to remove

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER id
        The id of the forward zone. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true,ParameterSetName="Default")]
      [String]$FQDN,
      [Parameter(Mandatory=$true,ParameterSetName="Default")]
      [System.Object]$View,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
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