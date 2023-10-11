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

    .PARAMETER id
        The id of the record. Accepts pipeline input

    .Example
        Remove-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [Parameter(ParameterSetName="noID-FQDN",Mandatory=$true)]
      [ValidateSet("A","AAAA","CAA","CNAME","HTTPS","MX","NAPTR","NS","PTR","SRV","SVCB","TXT")]
      [String]$Type,
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Zone,
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [Parameter(ParameterSetName="noID-FQDN",Mandatory=$true)]
      [String]$View,
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [Parameter(ParameterSetName="noID-FQDN",Mandatory=$true)]
      [String]$rdata,
      [Parameter(ParameterSetName="noID-FQDN",Mandatory=$true)]
      [String]$FQDN,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($id) {
        $Record = Get-B1Record -id $id
      } else {
        if (!(($Name -and $Zone) -or $FQDN)) {
          Write-Host "Error. You must specify either -Name & -Zone or -FQDN" -ForegroundColor Red
          break
        }
        $Record = Get-B1Record -Type $Type -Name $Name -Zone $Zone -View $View -rdata $rdata -FQDN $FQDN -Strict
        if (($Record | measure).Count -gt 1) {
          Write-Host "More than one record returned. These will not be removed. Please pipe Get-B1Record into Remove-B1Record instead for changes to more than one record." -ForegroundColor Red
          $Record | ft -AutoSize
          break
        }
      }
      if ($Record) {
        Write-Host "Removing record: $($Record.absolute_name_spec)" -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $Record.id
        if ($id) {
          $RC = Get-B1Record -id $id
        } else {
          $RC = Get-B1Record -Type $Type -Name $Name -Zone $Zone -View $View -rdata $rdata -FQDN $FQDN -Strict
        }
        if ($RC) {
            Write-Host "Failed to remove DNS record: $($RC.absolute_name_spec)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed DNS record: $($Record.absolute_name_spec)" -ForegroundColor Green
        }
      } else {
        Write-Host "DNS record does not exist: $id$FQDN$Name.$Zone" -ForegroundColor Gray
      }
    }
}