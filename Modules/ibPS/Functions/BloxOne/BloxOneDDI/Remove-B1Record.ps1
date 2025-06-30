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

    .PARAMETER Object
        The record object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [ValidateSet("A","AAAA","CAA","CNAME","HTTPS","MX","NAPTR","NS","PTR","SRV","SVCB","TXT")]
      [String]$Type,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Zone,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [String]$View,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [String]$rdata,
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [String]$FQDN,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      if ($Object) {
        $SplitID = $Object.id.split('/')
        if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/record") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/record' objects as input"
            return $null
        }
      } else {
        if (!(($Name -and $Zone) -or $FQDN)) {
          Write-Host "Error. You must specify either -Name & -Zone or -FQDN" -ForegroundColor Red
          break
        }
        $Object = Get-B1Record -Type $Type -Name $Name -Zone $Zone -View $View -rdata $rdata -FQDN $FQDN -Strict
        if (!($Object)) {
            Write-Error "Unable to find DNS Record: $($Name).$($Zone) in DNS View: $($View)."
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.absolute_name_spec) ($($Object.id))")){
        Write-Host "Removing record: $($Record.absolute_name_spec)" -ForegroundColor Yellow
        $null = Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        $RC = Get-B1Record -id $($Object.id)
        if ($RC) {
            Write-Host "Failed to remove DNS record: $($RC.absolute_name_spec)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed DNS record: $($Object.absolute_name_spec)" -ForegroundColor Green
        }
      }
    }
}