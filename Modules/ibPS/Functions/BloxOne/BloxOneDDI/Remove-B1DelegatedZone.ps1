function Remove-B1DelegatedZone {
    <#
    .SYNOPSIS
        Removes a Delegated Zone from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a Delegated Zone from BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to remove

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER id
        The id of the Delegated Zone. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1DelegatedZone -FQDN "delegated.mycompany.corp" -View "default"
   
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
        $Zone = Get-B1DelegatedZone -id $id
      } else {
        $Zone = Get-B1DelegatedZone -FQDN $FQDN -Strict -View $View
      }
      if ($Zone) {
        Invoke-CSP -Method "DELETE" -Uri "$($Zone.id)" | Out-Null
        $B1Zone = Get-B1DelegatedZone -id $($Zone.id)
        if ($B1Zone) {
            Write-Host "Error. Failed to delete Delegated Zone: $($B1Zone.fqdn)" -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted Delegated Zone: $($Zone.fqdn)" -ForegroundColor Green
        }
      } else {
        Write-Host "Delegated Zone $FQDN$id does not exist." -ForegroundColor Yellow
      }
    }
}