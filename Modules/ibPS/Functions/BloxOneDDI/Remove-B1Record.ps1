function Remove-B1Record {
    <#
    .SYNOPSIS
        Removes an existing DNS record in BloxOneDDI

    .DESCRIPTION
        This function is used to remove an existing DNS record in BloxOneDDI

    .PARAMETER Type
        The type of the record to remove

    .PARAMETER Name
        The name of the record to remove

    .PARAMETER Zone
        The zone of the record to remove

    .PARAMETER rdata
        The RDATA of the record to remove

    .PARAMETER View
        The DNS View the record exists in

    .PARAMETER FQDN
        The FQDN of the record to remove

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Remove-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [String]$Name,
      [String]$Zone,
      [Parameter(Mandatory=$true)]
      [String]$View,
      [String]$rdata,
      [String]$FQDN,
      [Switch]$Strict = $false
    )

    if (!(($Name -and $Zone) -or $FQDN)) {
        Write-Host "Error. You must specify either -Name & -Zone or -FQDN" -ForegroundColor Red
        break
    }
    
    $Record = Get-B1Record -Type $Type -Name $Name -Zone $Zone -View $View -rdata $rdata -FQDN $FQDN -Strict:$Strict

    if (($Record | measure).Count -gt 1) {
        Write-Host "More than one record returned. These will not be removed." -ForegroundColor Red
        $Record | ft -AutoSize
    } elseif (($Record | measure).Count -eq 1) {
        Write-Host "Removing record: $FQDN$Name.$Zone.." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $Record.id
        if (Get-B1Record -Type $Type -Name $Name -Zone $Zone -View $View -rdata $rdata -FQDN $FQDN -Strict:$Strict) {
            Write-Host "Failed to remove DNS record: $FQDN$Name.$Zone" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed DNS record: $FQDN$Name.$Zone" -ForegroundColor Green
        }
    } else {
        Write-Host "DNS record does not exist: $FQDN$Name.$Zone" -ForegroundColor Gray
    }

}