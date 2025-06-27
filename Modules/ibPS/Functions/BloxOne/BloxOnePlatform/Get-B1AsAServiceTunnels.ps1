function Get-B1AsAServiceTunnels {
    <#
    .SYNOPSIS
        Retrieves the connection information of NIOS-X As A Service IPSEC Tunnels

    .DESCRIPTION
        This function is used query the connection information of NIOS-X As A Service IPSEC Tunnels

    .EXAMPLE
        PS> Get-B1AsAServiceTunnels -Service Production | ft -AutoSize

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
        $Results = (Get-B1AsAServiceDeployments -ServiceID $ServiceID -Location $Location | Select-Object -ExpandProperty access_locations)[0] | Select -ExpandProperty tunnel_configs
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