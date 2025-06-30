function Set-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Updates an existing DHCP Config Profiles from Universal DDI

    .DESCRIPTION
        This function is used to update an existing DHCP Config Profiles from Universal DDI

    .PARAMETER Name
        The name of the DHCP Config Profile

    .PARAMETER NewName
        Use -NewName to update the name of the DHCP Config Profile

    .PARAMETER Description
        The new description for the DHCP Config Profile

    .PARAMETER EnableDDNS
        Enable or Disable the DDNS Service for this DHCP Config Profile

    .PARAMETER SendDDNSUpdates
        Enable or Disable the sending DDNS Updates for this DHCP Config Profile

    .PARAMETER DDNSDomain
        The new DDNS Domain for the DHCP Config Profile. Using the value 'None' will submit an empty DDNS Domain.

    .PARAMETER DDNSZones
        Provide a list of DDNS Zones to add or remove to/from the the DHCP Config Profile.

        This is to be used in conjunction with -AddDDNSZones and -RemoveDDNSZones respectively.

    .PARAMETER AddDDNSZones
        This switch determines if you want to add DDNS Zones using the -DDNSZones parameter

    .PARAMETER RemoveDDNSZones
        This switch determines if you want to remove DDNS Zones using the -DDNSZones parameter

    .PARAMETER DNSView
        The DNS View the Authoritative DDNS Zones are located in

    .PARAMETER Tags
        The tags to apply to the DHCP Config Profile

    .PARAMETER Object
        The DHCP Config Profile Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1DHCPConfigProfile -Name 'Data Centre DHCP' -AddDDNSZones -DDNSZones 'company.corp' -DNSView default

        Overriding Global DHCP Properties for DHCP Config Profile: Data Centre DHCP..
        company.corp added successfully to DDNS Config for the DHCP Config Profile: Data Centre DHCP

    .FUNCTIONALITY
        Universal DDI
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [ValidateSet("Enabled","Disabled")]
      [String]$EnableDDNS,
      [ValidateSet("Enabled","Disabled")]
      [String]$SendDDNSUpdates,
      [String]$DDNSDomain,
      [Switch]$AddDDNSZones,
      [Switch]$RemoveDDNSZones,
      [System.Object]$DDNSZones,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$DNSView,
      [System.Object]$Tags,
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
        if ($AddDDNSZones -and $RemoveDDNSZones) {
            Write-Error "Error. -AddDDNSZones and -RemoveDDNSZones are mutually exclusive parameters."
            return $null
        }
        if ($DDNSZones -and (!($AddDDNSZones -or $RemoveDDNSZones))) {
            Write-Error "Error. -DDNSZones additionally requires one of the following parameters to be used: -AddDDNSZones or -RemoveDDNSZones."
            return $null
        }
        if (($AddDDNSZones -or $RemoveDDNSZones) -and -not $DDNSZones) {
            Write-Error "Error. -DDNSZones is required when using -AddDDNSZones or -RemoveDDNSZones."
            return $null
        }
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/server") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/server' objects as input"
                return $null
            }
            if (($DDNSDomain -or $AddDDNSZones -or $RemoveDDNSZones -or $EnableDDNS -or $SendDDNSUpdates) -and ($Object.inheritance_sources -eq $null)) {
                $Object = Get-B1DHCPConfigProfile -id $Object.id -IncludeInheritance
            }
            if ($Object.inheritance_sources -eq $null) {
                $Object.PSObject.Properties.Remove('inheritance_sources')
            }
        } else {
            $Object = Get-B1DHCPConfigProfile -Name $Name -IncludeInheritance -Strict
            if (!($Object)) {
                Write-Error "Unable to find Authoritative Zone: $($FQDN)"
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty id
        $NewObj.ddns_zones = $NewObj.ddns_zones | Select-Object zone
        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($DDNSDomain -or $EnableDDNS -or $SendDDNSUpdates) {
            $NewObj.inheritance_sources.ddns_block.action = "override"
        }
        if ($DDNSDomain) {
            if ($DDNSDomain -eq "None") {
                $NewObj.ddns_domain = $null
            } else {
                $NewObj.ddns_domain = $DDNSDomain
            }
        }
        if ($EnableDDNS) {
            $NewObj.ddns_enabled = $(if ($EnableDDNS -eq 'Enabled') { $true } else { $false })
        }
        if ($SendDDNSUpdates) {
            $NewObj.ddns_send_updates = $(if ($SendDDNSUpdates -eq 'Enabled') { $true } else { $false })
        }
        if ($AddDDNSZones) {
            $ConfigProfileZones = @()
            $NewObj.ddns_zones = @($NewObj.ddns_zones | Select-Object zone)
            foreach ($DDNSZone in $DDNSZones) {
                $DDNSZone = $DDNSZone.TrimEnd(".")
                if (("$DDNSZone.") -in $Object.ddns_zones.fqdn) {
                    Write-Host "$DDNSZone already exists. Skipping.." -ForegroundColor Yellow
                } else {
                    $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                    if ($AuthZone) {
                        $Zone = [PSCustomObject]@{
                            "zone" = $AuthZone.id
                        }
                        $ConfigProfileZones += $Zone
                    } else {
                        Write-Host "Error: Authoritative Zone not found." -ForegroundColor Red
                    }
                    $ToUpdate += $DDNSZone
                }
            }
            $NewObj.ddns_zones += $ConfigProfileZones
        }
        if ($RemoveDDNSZones) {
            $ConfigProfileZones = @()
            foreach ($ConfigProfileDDNSZone in $Object.ddns_zones) {
                $DDNSZone = $ConfigProfileDDNSZone.fqdn.TrimEnd(".")
                if ($DDNSZone -notin $DDNSZones) {
                    Write-Host "$DDNSZone already does not exist. Skipping.." -ForegroundColor Yellow
                } else {
                    $NewObj.ddns_zones = $NewObj.ddns_zones | Where-Object {$_.fqdn -ne "$($DDNSZone)."}
                }
            }
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress

        if($PSCmdlet.ShouldProcess("Update DHCP Config Profile:`n$(JSONPretty($JSON))","Update DHCP Config Profile: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}