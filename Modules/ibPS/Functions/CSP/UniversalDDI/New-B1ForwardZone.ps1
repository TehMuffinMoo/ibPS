﻿function New-B1ForwardZone {
    <#
    .SYNOPSIS
        Creates a new Forward Zone in Universal DDI

    .DESCRIPTION
        This function is used to create a new Forward Zone in Universal DDI

    .PARAMETER FQDN
        The FQDN of the zone to create

    .PARAMETER View
        The DNS View the zone will be created in

    .PARAMETER Forwarders
        A list of IPs/FQDNs to forward requests to

    .PARAMETER DNSHosts
        A list of DNS Hosts to assign to the zone

    .PARAMETER Description
        The description for the new zone

    .PARAMETER ForwardOnly
        Setting the -ForwardOnly switch will enable forward only mode for this zone

    .PARAMETER Tags
        Any tags you want to apply to the forward zone

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1ForwardZone -FQDN "mysubzone.mycompany.corp" -View "default" -DNSHosts "ddihost1.corp.mycompany.com" -Description "My Forward Zone"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View,
      [Parameter(Mandatory=$true)]
      [System.Object]$Forwarders,
      [System.Object]$DNSHosts,
      [String]$Description,
      [Switch]$ForwardOnly,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if (Get-B1ForwardZone -FQDN $FQDN -View $View) {
        Write-Host "The $FQDN Zone already exists in DNS." -ForegroundColor Red
    } else {

        $ViewUUID = (Get-B1DNSView -Name $View -Strict).id

        if ($Forwarders.GetType().Name -eq "Object[]") {
            $ExternalHosts = New-Object System.Collections.ArrayList
            foreach ($Forwarder in $Forwarders) {
                $ExternalHosts.Add(@{"address"=$Forwarder;"fqdn"=$Forwarder;}) | Out-Null
            }
        } elseif ($Forwarders.GetType().Name -eq "ArrayList") {
            $ExternalHosts = $Forwarders
        } else {
            Write-Host "Error. Invalid data submitted in -ExternalHosts" -ForegroundColor Red
            break
        }

        $splat = @{
	        "fqdn" = $FQDN
            "comment" = $Description
	        "disabled" = $false
            "forward_only" = if ($ForwardOnly) {$true} else {$false}
	        "external_forwarders" = $ExternalHosts
	        "view" = $ViewUUID
            "tags" = $Tags
        }

        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add((Get-B1DNSHost -Name $DNSHost).id) | Out-Null
            }
            $splat | Add-Member -Name "hosts" -Value $B1Hosts -MemberType NoteProperty
        }

        $splat = $splat | ConvertTo-Json

        if($PSCmdlet.ShouldProcess("Create new Forward Zone:`n$($splat)","Create new Forward Zone: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/forward_zone" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
            if ($Result) {
                Write-Host "Created Forward DNS Zone $FQDN successfully." -ForegroundColor Green
                return $Result
            } else {
                Write-Host "Failed to create Forward DNS Zone $FQDN." -ForegroundColor Red
            }
        }
    }
}