function Set-B1AuthoritativeZone {
    <#
    .SYNOPSIS
        Updates an existing Authoritative Zone in BloxOneDDI

    .DESCRIPTION
        This function is used to an existing Authoritative Zone in BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to update

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER DNSHosts
        A list of DNS Hosts to assign to the zone. This will overwrite existing values

    .PARAMETER AddAuthNSGs
        A list of Authoritative DNS Server Groups to add to the zone.

    .PARAMETER RemoveAuthNSGs
        A list of Authoritative DNS Server Groups to remove from the zone.

    .PARAMETER Description
        The description for the zone to be updated to

    .PARAMETER State
        Set whether the Forward Zone is enabled or disabled.

    .PARAMETER NotifyExternalSecondaries
        Toggle whether to notify external secondary DNS Servers for this zone.

    .PARAMETER Compartment
        The name of the compartment to assign to this authoritative zone

    .PARAMETER Tags
        A list of tags to update on the authoritative zone. This will replace existing tags, so would normally be a combined list of existing and new tags

    .PARAMETER Object
        The Authoritative Zone Object to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1AuthoritativeZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -AddAuthNSGs "Data Centre"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$FQDN,
      [System.Object]$DNSHosts,
      [System.Object]$AddAuthNSGs,
      [System.Object]$RemoveAuthNSGs,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [System.Object]$View,
      [String]$Description,
      [ValidateSet("Enabled","Disabled")]
      [String]$State,
      [ValidateSet("Enabled","Disabled")]
      [String]$NotifyExternalSecondaries,
      [String]$Compartment,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object
    )

    begin {
        if ($Compartment) {
            $CompartmentID = (Get-B1Compartment -Name $Compartment -Strict).id
            if (!($CompartmentID)) {
                Write-Error "Unable to find compartment with name: $($Compartment)"
                return $null
            }
        }
    }

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/auth_zone") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/auth_zone' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1ForwardZone -FQDN $FQDN -Strict
            if (!($Object)) {
                Write-Error "Unable to find Authoritative Zone: $($FQDN)"
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty id,fqdn,mapped_subnet,mapping,parent,protocol_fqdn,updated_at,created_at,warnings,view,inheritance_assigned_hosts,inheritance_sources,initial_soa_serial,primary_type,zone_authority,external_providers,nios_grids_metadata

        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($NotifyExternalSecondaries) {
            $NewObj.notify = $(if ($NotifyExternalSecondaries -eq 'Enabled') { $true } else { $false })
        }
        if ($State) {
            $NewObj.disabled = $(if ($State -eq 'Enabled') { $false } else { $true })
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($CompartmentID) {
            $NewObj.compartment_id = $CompartmentID
        }
        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add(@{"host"=(Get-B1DNSHost -Name $DNSHost).id;}) | Out-Null
            }
            $NewObj.internal_secondaries = $B1Hosts
        }

        if ($AddAuthNSGs) {
            $B1AuthNSGs = @()
            if ($NewObj.nsgs -gt 0) {
                $B1AuthNSGs += $NewObj.nsgs
            }
            foreach ($AuthNSG in $AddAuthNSGs) {
                $B1AuthNSGs += (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
            }
            $NewObj.nsgs = @()
            $NewObj.nsgs += $B1AuthNSGs | Select-Object -Unique
        }

        if ($RemoveAuthNSGs) {
            $B1AuthNSGs = @()
            if ($NewObj.nsgs -gt 0) {
                $B1AuthNSGs += $NewObj.nsgs
            }
            foreach ($AuthNSG in $RemoveAuthNSGs) {
                $AuthNSGid = (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
                $B1AuthNSGs = $B1AuthNSGs | Where-Object {$_ -ne $AuthNSGid}
            }
            $NewObj.nsgs = @()
            $NewObj.nsgs += $B1AuthNSGs | Select-Object -Unique
        }

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress

        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}