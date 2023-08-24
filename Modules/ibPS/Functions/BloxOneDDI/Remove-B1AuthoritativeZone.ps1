function Remove-B1AuthoritativeZone {
    <#
    .SYNOPSIS
        Removes a Authoritative Zone from BloxOneDDI

    .DESCRIPTION
        This function is used to remove a Authoritative Zone from BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to remove

    .PARAMETER View
        The DNS View the zone is located in

    .Example
        Remove-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View
    )
    $Zone = Get-B1AuthoritativeZone -FQDN $FQDN -Strict -View $View
    if ($Zone) {
        Query-CSP -Method "DELETE" -Uri "$($Zone.id)"
        if (Get-B1AuthoritativeZone -FQDN $FQDN -Strict -View $View) {
            Write-Host "Error. Failed to delete Authoritative Zone $FQDN." -ForegroundColor Red
        } else {
            Write-Host "Successfully deleted Authoritative Zone $FQDN." -ForegroundColor Green
        }
    } else {
        Write-Host "Zone $FQDN does not exist." -ForegroundColor Yellow
    }
}