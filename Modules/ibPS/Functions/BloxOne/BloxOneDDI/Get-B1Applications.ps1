function Get-B1Applications {
    <#
    .SYNOPSIS
        Retrieves a list of supported BloxOneDDI Applications

    .DESCRIPTION
        This function is used query a list of supported BloxOneDDI Applications/Services

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
        BloxOneDDI

    .FUNCTIONALITY
        Service
    #>
    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/applications" | Select-Object -ExpandProperty results | Select-Object -ExpandProperty applications -ErrorAction SilentlyContinue
    
    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No BloxOneDDI Applications found." -ForegroundColor Red
    }
}