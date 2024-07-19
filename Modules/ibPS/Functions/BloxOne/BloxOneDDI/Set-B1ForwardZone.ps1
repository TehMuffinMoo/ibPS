function Set-B1ForwardZone {
    <#
    .SYNOPSIS
        Updates an existing Forward Zone in BloxOneDDI

    .DESCRIPTION
        This function is used to an existing Forward Zone in BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the zone to update

    .PARAMETER View
        The DNS View the zone is located in

    .PARAMETER Description
        The new description for the Forward Zone

    .PARAMETER Forwarders
        A list of IPs/FQDNs to forward requests to. This will overwrite existing values

    .PARAMETER DNSHosts
        A list of DNS Hosts to assign to the zone. This will overwrite existing values

    .PARAMETER DNSServerGroups
        A list of Forward DNS Server Groups to assign to the zone. This will overwrite existing values

    .PARAMETER ForwardOnly
        Toggle the Forwarders Only option for this Forward Zone.

    .PARAMETER State
        Set whether the Forward Zone is enabled or disabled.

    .PARAMETER Tags
        Any tags you want to apply to the forward zone

    .PARAMETER Object
        The Forward Zone Object to update. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -DNSServerGroups "Data Centre"

    .EXAMPLE
        PS> Get-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" | Set-B1ForwardZone -DNSHosts "mybloxoneddihost1.corp.mycompany.com" -DNSServerGroups "Data Centre"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$FQDN,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [System.Object]$View,
      [String]$Description,
      $Forwarders,
      [System.Object]$DNSHosts,
      [String]$DNSServerGroups,
      [ValidateSet('Enabled','Disabled')]
      [String]$ForwardOnly,
      [ValidateSet("Enabled","Disabled")]
      [String]$State,
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
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/forward_zone") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/forward_zone' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1ForwardZone -FQDN $FQDN -View $View -Strict
            if (!($Object)) {
                Write-Error "Unable to find Forward Zone: $($FQDN)"
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty id,fqdn,mapped_subnet,mapping,parent,protocol_fqdn,updated_at,created_at,warnings,view

        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($ForwardOnly) {
            $NewObj.forward_only = $(if ($ForwardOnly -eq 'Enabled') { $true } else { $false })
        }
        if ($State) {
            $NewObj.disabled = $(if ($State -eq 'Enabled') { $false } else { $true })
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($Forwarders) {
            if ($Forwarders.GetType().Name -eq "Object[]") {
                $ExternalHosts = New-Object System.Collections.ArrayList
                foreach ($Forwarder in $Forwarders) {
                    $ExternalHosts.Add(@{"address"=$Forwarder;"fqdn"=$Forwarder;}) | Out-Null
                }
            } elseif ($Forwarders.GetType().Name -eq "ArrayList") {
                $ExternalHosts = $Forwarders
            }
            if ($ExternalHosts) {$NewObj.external_forwarders = $ExternalHosts}
        }
        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add((Get-B1DNSHost -Name $DNSHost).id) | Out-Null
            }
            if ($B1Hosts) {$NewObj.hosts = $B1Hosts}
        }
        if ($DNSServerGroups) {
            $B1ForwardNSGs = @()
            foreach ($DNSServerGroup in $DNSServerGroups) {
                $B1ForwardNSGs += (Get-B1ForwardNSG -Name $DNSServerGroup).id
            }
            if ($DNSServerGroups) {
                $NewObj.nsgs = $B1ForwardNSGs
                $NewObj.external_forwarders = @()
                $NewObj.hosts = @()
            }
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