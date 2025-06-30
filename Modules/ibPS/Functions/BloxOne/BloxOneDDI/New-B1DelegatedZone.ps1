function New-B1DelegatedZone {
    <#
    .SYNOPSIS
        Creates a new Delegated Zone in BloxOneDDI

    .DESCRIPTION
        This function is used to create a new Delegated Zone in BloxOneDDI

    .PARAMETER FQDN
        The FQDN of the delegated zone to create

    .PARAMETER View
        The DNS View the zone will be created in

    .PARAMETER DelegationServers
        A list of IPs/FQDNs to delegate requests to

    .PARAMETER Description
        The description for the new zone

    .PARAMETER Tags
        Any tags you want to apply to the delegated zone

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1DelegatedZone -FQDN "mysubzone.mycompany.corp" -View "default" -Description "My Delegated Zone"

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
      [System.Object]$DelegationServers,
      [String]$Description,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if (Get-B1DelegatedZone -FQDN $FQDN -View $View) {
        Write-Host "The $FQDN Zone already exists in DNS." -ForegroundColor Red
    } else {

        $ViewUUID = (Get-B1DNSView -Name $View -Strict).id

        if ($DelegationServers.GetType().Name -eq "Object[]") {
            $ExternalHosts = New-Object System.Collections.ArrayList
            foreach ($DNSServer in $DelegationServers) {
                $ExternalHosts.Add(@{"address"=$DNSServer;"fqdn"=$DNSServer;}) | Out-Null
            }
        } elseif ($DelegationServers.GetType().Name -eq "ArrayList") {
            $ExternalHosts = $DelegationServers
        } else {
            Write-Host "Error. Invalid data submitted in -ExternalHosts" -ForegroundColor Red
            break
        }

        $splat = @{
	        "fqdn" = $FQDN
            "comment" = $Description
	        "disabled" = $false
	        "delegation_servers" = $ExternalHosts
	        "view" = $ViewUUID
            "tags" = $Tags
        }

        $splat = $splat | ConvertTo-Json

        if($PSCmdlet.ShouldProcess("Create new Delegated Zone:`n$($splat)","Create new Delegated Zone: $($FQDN)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/delegation" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue

            if ($Result) {
                Write-Host "Created Delegated DNS Zone $FQDN successfully." -ForegroundColor Green
                return $Result
            } else {
                Write-Host "Failed to create Delegated DNS Zone $FQDN." -ForegroundColor Red
            }
        }
    }
}