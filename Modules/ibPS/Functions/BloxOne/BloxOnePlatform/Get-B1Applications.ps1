function Get-B1Applications {
    <#
    .SYNOPSIS
        Retrieves a list of supported Infoblox Portal Applications

    .DESCRIPTION
        This function is used query a list of supported Infoblox Portal Applications/Services

    .EXAMPLE
        PS> Get-B1Applications

        dfp
        dns
        dhcp
        cdc
        anycast
        orpheus
        msad
        authn
        ntp
        rip
        bgp
        ospf
        discovery

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Service
    #>
    [CmdletBinding()]
    param()

    $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/applications" | Select-Object -ExpandProperty results | Select-Object -ExpandProperty applications -ErrorAction SilentlyContinue

    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No Applications found." -ForegroundColor Red
    }
}