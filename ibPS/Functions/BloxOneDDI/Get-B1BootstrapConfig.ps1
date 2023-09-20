function Get-B1BootstrapConfig {
    <#
    .SYNOPSIS
        Retrieves the bootstrap configuration for a BloxOneDDI Host

    .DESCRIPTION
        This function is used to retrieve the bootstrap configuration for a BloxOneDDI Host

    .PARAMETER OnPremHost
        The name of the BloxOneDDI host to check the NTP configuration for

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1BootstrapConfig -OnPremHost "myonpremhost.corp.domain.com"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Host
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String]$OnPremHost,
        [Switch]$Strict = $false
    )
    $ophids = (Get-B1Host -Name $OnPremHost -Strict:$Strict).ophid
    $Results = @()
    foreach ($ophid in $ophids) {
        $Results += Query-CSP -Method "GET" -Uri "https://csp.infoblox.com/api/atlas-bootstrap-app/v1/host/$ophid"
    }
    return $Results
}
