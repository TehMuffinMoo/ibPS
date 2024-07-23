function Set-B1DHCPGlobalConfig {
    <#
    .SYNOPSIS
        Updates the BloxOneDDI Global DHCP Configuration

    .DESCRIPTION
        This function is used to update the BloxOneDDI Global DHCP Configuration

    .PARAMETER DDNSZones
        Provide a list of DDNS Zones to add or remove to/from the Global DHCP Configuration.

        This is to be used in conjunction with -AddDDNSZones and -RemoveDDNSZones respectively.

    .PARAMETER AddDDNSZones
        Using this switch indicates the zones specified in -DDNSZones are to be added to the Global DHCP Configuration

    .PARAMETER RemoveDDNSZones
        Using this switch indicates the zones specified in -DDNSZones are to be removed from the Global DHCP Configuration

    .PARAMETER DNSView
        The DNS View for applying the configuration to

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .PARAMETER Object
        The DHCP Global Config object to update. Accepts pipeline input.

    .EXAMPLE
        PS> Set-B1DHCPGlobalConfig -AddDDNSZones -DDNSZones "mysubzone.corp.mycompany.com" -DNSView "default"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        DefaultParameterSetName='Default',
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(ParameterSetName="AddDDNSZones",Mandatory=$true)]
        [Switch]$AddDDNSZones,
        [Parameter(ParameterSetName="RemoveDDNSZones",Mandatory=$true)]
        [Switch]$RemoveDDNSZones,
        [Parameter(ParameterSetName="AddDDNSZones",Mandatory=$true)]
        [Parameter(ParameterSetName="RemoveDDNSZones",Mandatory=$true)]
        [System.Object]$DDNSZones,
        [Parameter(ParameterSetName="AddDDNSZones",Mandatory=$true)]
        [Parameter(ParameterSetName="RemoveDDNSZones",Mandatory=$false)]
        [String]$DNSView,
        [Parameter(ValueFromPipeline = $true)]
        [System.Object]$Object,
        [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/global") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/global' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DHCPGlobalConfig
            if (!($Object)) {
                Write-Error "Unable to query Global DHCP Configuration."
                return $null
            }
        }
        $ObjectExclusions = @('id')
        $NewObj = $Object | Select-Object * -ExcludeProperty $ObjectExclusions
        $NewObj.ddns_zones = $NewObj.ddns_zones | Select-Object * -ExcludeProperty view_name,view
        $NewObj.dhcp_options = @($NewObj.dhcp_options | Select-Object * -ExcludeProperty group)
        $NewObj.dhcp_options_v6 = @($NewObj.dhcp_options_v6 | Select-Object * -ExcludeProperty group)

        $Iter = 0
        foreach ($DDNSObj in $NewObj.ddns_zones) {
            $KeysToRemove = ($DDNSObj.PSObject.Properties | Where-Object {$_.Value -eq $null}).Name
            foreach ($DDNSObjKey in $KeysToRemove) {
                $DDNSObj.PSObject.Properties.Remove($DDNSObjKey)
            }
            if ($DDNSObj.zone) {
                $NewObj.ddns_zones[$Iter] = $NewObj.ddns_zones[$Iter] | Select-Object zone
            }
            if ($DDNSObj.tsig_key) {
                $NewObj.ddns_zones[$Iter].tsig_key = $NewObj.ddns_zones[$Iter].tsig_key | Select-Object key
            }
            $Iter++
        }
        if ($DDNSZones) {
            if ($AddDDNSZones) {
                foreach ($DDNSZone in $DDNSZones) {
                    $DDNSZone = $DDNSZone.TrimEnd(".")
                    if (("$DDNSZone.") -in $Object.ddns_zones.fqdn) {
                        Write-Host "$DDNSZone already exists in the Global Configuration. Skipping.." -ForegroundColor Yellow
                    } else {
                        $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                        if ($AuthZone) {
                            $NewObj.ddns_zones += [PSCustomObject]@{
                                "zone" = $AuthZone.id
                            }
                        } else {
                            Write-Error "Authoritative Zone: $($DDNSZone) not found."
                        }
                    }
                }

            } elseif ($RemoveDDNSZones) {
                foreach ($DDNSZone in $DDNSZones) {
                    $DDNSZone = $DDNSZone.TrimEnd(".")
                    if (("$DDNSZone.") -in $Object.ddns_zones.fqdn) {
                        $SelectedDDNSObj = $Object.ddns_zones | Where-Object {$_.fqdn -eq "$($DDNSZone)."}
                        $NewObj.ddns_zones = $NewObj.ddns_zones | Where-Object {$_.zone -ne $SelectedDDNSObj.zone}
                    } else {
                        Write-Host "$DDNSZone does not exist in the Global Configuration. Skipping.." -ForegroundColor Yellow
                    }
                }
            }
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress

        if($PSCmdlet.ShouldProcess("Update Global DHCP Config:`n$(JSONPretty($JSON))","Update Global DHCP Config: ($($Object.id))",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method "PATCH" -Uri "$($Object.id)" -Data $JSON
            if ($Result) {
                $Result | Select-Object -ExpandProperty result
            } else {
                Write-Error "Error. Failed to update Global DHCP Configuration."
                $Result
            }
        }
    }
}