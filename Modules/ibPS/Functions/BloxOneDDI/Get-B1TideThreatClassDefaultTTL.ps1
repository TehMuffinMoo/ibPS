function Get-B1TideThreatClassDefaultTTL {
    <#
    .SYNOPSIS
        Queries the default TTL for threat classes

    .DESCRIPTION
        This function will query the default TTL applied to threat classes

    .Example
        Get-B1TideThreatClassDefaultTTL

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>

    $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/default/ttl" -Method GET | Select -ExpandProperty default_ttl -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select class,property,ttl -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }
}