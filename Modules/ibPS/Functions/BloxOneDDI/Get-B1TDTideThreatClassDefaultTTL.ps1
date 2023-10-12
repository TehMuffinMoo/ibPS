function Get-B1TDTideThreatClassDefaultTTL {
    <#
    .SYNOPSIS
        Queries the default TTL for threat classes

    .DESCRIPTION
        This function will query the default TTL applied to threat classes

    .Example
        Get-B1TDTideThreatClassDefaultTTL

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>

    $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/default/ttl" -Method GET | Select-Object -ExpandProperty default_ttl -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object class,property,ttl -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }
}