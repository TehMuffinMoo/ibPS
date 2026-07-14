function Set-B1AuthoritativeZoneSerial {
    <#
    .SYNOPSIS
        Increments the serial number of an existing Authoritative Zone in Universal DDI

    .DESCRIPTION
        This function is used to increment an Authoritative Zone SOA Serial Number in Universal DDI

    .PARAMETER FQDN
        The FQDN of the zone to update

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER Serial
        The new serial number to set for the Authoritative Zone. If not specified, the serial will be incremented by 1,000

    .PARAMETER Object
        The Authoritative Zone Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to High.

    .EXAMPLE
        PS> Set-B1AuthoritativeZoneSerial -FQDN my.corp -View "default"

            Set-B1AuthoritativeZoneSerial
            Increment Serial Number by 1,000 on Authoritative Zone: my.corp. (dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a) from 27 to 1,027
            [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y

            absolute_name_spec     : my.corp.
            absolute_zone_name     : my.corp.
            comment                :
            compartment_id         :
            created_at             : 24/11/2025 15:04:49
            delegation             :
            disabled               : False
            dns_absolute_name_spec : my.corp.
            dns_absolute_zone_name : my.corp.
            dns_name_in_zone       :
            dns_rdata              : ns.my.corp. hostmaster.my.corp. 28 10800 3600 2419200 900
            id                     : dns/record/095ds3de-7793-469b-9159-7e62fd80278d
            inheritance_sources    :
            ipam_host              :
            last_queried           : 01/01/1970 00:00:00
            name_in_zone           :
            nios_metadata          :
            options                :
            protection             :
            provider_metadata      :
            rdata                  : @{expire=2419200; mname=ns.my.corp.; negative_ttl=900; refresh=10800; retry=3600; rname=hostmaster@my.corp; serial=1027}
            source                 : {SYSTEM}
            subtype                :
            tags                   :
            ttl                    : 28800
            type                   : SOA
            updated_at             : 2026-07-03T10:40:20.668283186Z
            view                   : dns/view/e3ebc1f6-c493-441a-b2b8-d509cc2e3ee5
            view_name              : default
            zone                   : dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a

    .EXAMPLE
        PS> Get-B1AuthoritativeZone -FQDN my.corp | Set-B1AuthoritativeZoneSerial -Serial 1028

            Set-B1AuthoritativeZoneSerial
            Increment Serial Number by 1 on Authoritative Zone: my.corp. (dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a) from 1,027 to 1,028
            [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y

            absolute_name_spec     : my.corp.
            absolute_zone_name     : my.corp.
            comment                :
            compartment_id         :
            created_at             : 24/11/2025 15:04:49
            delegation             :
            disabled               : False
            dns_absolute_name_spec : my.corp.
            dns_absolute_zone_name : my.corp.
            dns_name_in_zone       :
            dns_rdata              : ns.my.corp. hostmaster.my.corp. 28 10800 3600 2419200 900
            id                     : dns/record/095ds3de-7793-469b-9159-7e62fd80278d
            inheritance_sources    :
            ipam_host              :
            last_queried           : 01/01/1970 00:00:00
            name_in_zone           :
            nios_metadata          :
            options                :
            protection             :
            provider_metadata      :
            rdata                  : @{expire=2419200; mname=ns.my.corp.; negative_ttl=900; refresh=10800; retry=3600; rname=hostmaster@my.corp; serial=1028}
            source                 : {SYSTEM}
            subtype                :
            tags                   :
            ttl                    : 28800
            type                   : SOA
            updated_at             : 2026-07-03T10:40:20.668283186Z
            view                   : dns/view/e3ebc1f6-c493-441a-b2b8-d509cc2e3ee5
            view_name              : default
            zone                   : dns/auth_zone/d66ef0f4-37d5-49a9-b23a-d64cfea77e0a

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
      [String]$Serial,
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
        if ($Serial) {
            $NewSerial = $Serial
            $Diff = $NewSerial - $OldSerial
            if ($Diff -le 0) {
                Write-Error "New Serial Number ($NewSerial) must be greater than the current Serial Number ($OldSerial)"
                return $null
            }
            $SOARDATA.serial = [int]$NewSerial
            $JSON = @{
                "rdata" = $SOARDATA
            } | ConvertTo-Json -Depth 4 -Compress
            if($PSCmdlet.ShouldProcess("Increment Serial Number by $Diff on Authoritative Zone: $($Object.fqdn) ($($Object.id)) from $OldSerial to $NewSerial","Increment Serial Number by $Diff on Authoritative Zone: $($Object.fqdn) ($($Object.id)) from $OldSerial to $NewSerial",$MyInvocation.MyCommand)){
                $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($SOARecord.id)" -Data $JSON
                if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                    $Results | Select-Object -ExpandProperty result
                } else {
                    $Results
                }
            }
        } else {
            $NewSerial = $OldSerial + 1000
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
}