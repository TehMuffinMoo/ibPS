function Get-B1TideThreatClassDefaultTTL {
    <#
    .SYNOPSIS
        Queries the default TTL for threat classes

    .DESCRIPTION
        This function will query the default TTL applied to threat classes

    .EXAMPLE
        PS> Get-B1TideThreatClassDefaultTTL

        class                  property                              ttl
        -----                  --------                              ---
        APT                                                          2 years
        Bot                                                          7 days
        CompromisedHost                                              30 days
        Cryptocurrency                                               1 year
        Cryptocurrency         Cryptocurrency_Coinhive               60 days
        Cryptocurrency         Cryptocurrency_Cryptojacking          60 days
        Cryptocurrency         Cryptocurrency_Exchange               60 days
        Cryptocurrency         Cryptocurrency_Generic                14 days
        Cryptocurrency         Cryptocurrency_GenericThreat          14 days
        ...

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>

    $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/default/ttl" -Method GET | Select-Object -ExpandProperty default_ttl -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object class,property,ttl -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }
}