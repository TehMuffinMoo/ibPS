function Get-B1DHCPGlobalConfig {
    <#
    .SYNOPSIS
        Retrieves the BloxOneDDI Global DHCP Configuration

    .DESCRIPTION
        This function is used to retrieve the BloxOneDDI Global DHCP Configuration

    .Example
        Get-B1DHCPGlobalConfig
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    $Result = Query-CSP -Method "GET" -Uri "dhcp/global" | Select -ExpandProperty result -ErrorAction SilentlyContinue
    return $Result
}