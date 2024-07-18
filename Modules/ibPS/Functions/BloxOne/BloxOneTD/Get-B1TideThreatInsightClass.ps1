function Get-B1TideThreatInsightClass {
    <#
    .SYNOPSIS
        Queries a list of threat insight classes

    .DESCRIPTION
        This function will query a list of threat insight classes

    .EXAMPLE
        PS> Get-B1TideThreatInsightClass

        class                 family                  desc
        -----                 ------                  ----
        TI-DNST               Generic                 Threat Insight’s ML/AI algorithm has identified DNS that looks like a DNS tunnel.  This could be a C2 Channel or an attempt to exfiltrate data.  Some legitimate services use DNS Tunnels to transmit data (particularly antivirus software), we maintain…
        TI-DNSTN              Generic                 Threat Insight’s ML/AI algorithm has identified DNS that NOTIONALLY looks like a DNS tunnel.  However, there were no successfully resolved queries and the domain doesn't appear to be using it's only nameserver. This could be a C2 Channel or an attem…
        TI-DNST               COBALTSTRIKE            Threat Insight’s ML/AI algorithm has identified a Cobalt Strike C2 Beacon or Tunnel.  Cobalt Strike is primarily used by pen testers but a malicious actor may use a hacked copy. You may wish to investigate and/or block the domain. If the domain is b…
        ...

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding()]
    param(
    )

    $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/ti_classes" -Method GET | Select-Object -ExpandProperty record -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }
}