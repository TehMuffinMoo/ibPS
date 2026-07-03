function Update-B1AuthoritativeZoneSerial {
    <#
    .SYNOPSIS
        Increments the serial number of an existing Authoritative Zone in Universal DDI

    .DESCRIPTION
        This function is used to increment an Authoritative Zone Serial Number by 1,000 in Universal DDI

    .PARAMETER FQDN
        The FQDN of the zone to update

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER Object
        The Authoritative Zone Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to High.

    .EXAMPLE
        PS> Update-B1AuthoritativeZoneSerial -FQDN "mysubzone.mycompany.corp" -View "default"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="FQDN", Mandatory=$true)]
      [String]$FQDN,
      [Parameter(ParameterSetName="FQDN", Mandatory=$true)]
      [String]$View,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/auth_zone") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/auth_zone' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1AuthoritativeZone -FQDN $FQDN -View $View -Strict
            if (!($Object)) {
                Write-Error "Unable to find Authoritative Zone: $($FQDN)"
                return $null
            }
        }

        $SOARecord = $Object | Get-B1ZoneChild -RecordType SOA -Strict

        if (!$SOARecord) {
            Write-Error "Unable to find SOA record for Authoritative Zone: $($Object.fqdn)"
            return $null
        }

        $SOARDATA = $SOARecord.record_data | ConvertFrom-Json
        $OldSerial = $SOARDATA.serial
        $NewSerial = $SOARDATA.serial + 1000

        if($PSCmdlet.ShouldProcess("Increment Serial Number by 1,000 on Authoritative Zone: $($Object.fqdn) ($($Object.id)) from $OldSerial to $NewSerial","Increment Serial Number by 1,000 on Authoritative Zone: $($Object.fqdn) ($($Object.id)) from $OldSerial to $NewSerial",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($SOARecord.id)/serial_increment" -Data "{}"
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}