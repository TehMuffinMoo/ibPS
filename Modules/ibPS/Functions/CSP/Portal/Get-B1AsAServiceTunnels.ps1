function Get-B1AsAServiceTunnels {
    <#
    .SYNOPSIS
        Retrieves the connection information of NIOS-X As A Service IPSEC Tunnels

    .DESCRIPTION
        This function is used query the connection information of NIOS-X As A Service IPSEC Tunnels

    .PARAMETER Service
        The name of the Universal DDI Service to query the tunnel status for. Either Service or ServiceID is required.

    .PARAMETER ServiceID
        The id of the Universal DDI Service to query the tunnel status for. Either ServiceID or Service is required.

    .PARAMETER Location
        The name of the Access Location to filter the the tunnel status by. This parameter is optional.

    .PARAMETER ReturnStatus
        If specified, the function will return only the status of the tunnels.

    .EXAMPLE
        PS> Get-B1AsAServiceTunnels -Service Production

        id               : fdsdfoi9sdejf98ewsgfn98e4whfsue
        name             : GB-DC
        wan_ip           : 66.66.66.66
        identity_type    : FQDN
        physical_tunnels : {@{path=secondary; remote_id=infoblox.cloud; identity=df43ewf34rf444g.infoblox.com; credential_id=fdsfsfdse-fesfsfs-seffe43gf45-g444gg4g4;
                          credential_name=Path-A-PSK; status=Connected}, @{path=primary; remote_id=infoblox.cloud; identity=fsef4f4f4thd4rt.infoblox.com;
                          credential_id=fdfsdf4e-87iik87i-h656urf9ddf-fdsgsd9sx; credential_name=Path-B-PSK; status=Connected}}
        remote_id        : infoblox.cloud

    .EXAMPLE
        PS> Get-B1AsAServiceTunnels -Service Production -ReturnStatus

        path      remote_id      identity                      credential_id                        credential_name      status
        ----      ---------      --------                      -------------                        ---------------      ------
        secondary infoblox.cloud df43ewf34rf444g.infoblox.com fdsfsfdse-fesfsfs-seffe43gf45-g444gg4g4 Path-A-PSK         Connected
        primary   infoblox.cloud fsef4f4f4thd4rt.infoblox.com fdfsdf4e-87iik87i-h656urf9ddf-fdsgsd9sx Path-B-PSK         Connected

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [Alias('Get-B1AASTunnels')]
    [CmdletBinding()]

    param(
      [Parameter(Mandatory=$true, ParameterSetName = 'ByService')]
      [String]$Service,
      [Parameter(Mandatory=$true, ParameterSetName = 'ByServiceID')]
      [String]$ServiceID,
      [Parameter(Mandatory=$true)]
      [String]$Location,
      [Switch]$ReturnStatus
    )

    if (!$ServiceID) {
        $ServiceID = Get-B1AsAServiceServices | Where-Object {$_.name -eq $Service} | Select-Object -ExpandProperty id
    }

    if ($Location) {
        if (!$ServiceID) {
            Write-Host "Service parameter is required when specifying a location." -ForegroundColor Red
            return
        }
        $Results = (Get-B1AsAServiceDeployments -ServiceID $ServiceID -Location $Location | Select-Object -ExpandProperty access_locations)[0] | Select-Object -ExpandProperty tunnel_configs
    } else {
        $Results = Get-B1AsAServiceDeployments -ServiceID $ServiceID | Select-Object -ExpandProperty access_locations | ForEach-Object { $_.tunnel_configs }
    }

    if ($Results) {
      if ($ReturnStatus) {
        return $Results | Select-Object -ExpandProperty physical_tunnels
      } else {
        return $Results
      }
    } else {
      Write-Host "Error. No NIOS-XaaS Tunnels Found." -ForegroundColor Red
    }
}