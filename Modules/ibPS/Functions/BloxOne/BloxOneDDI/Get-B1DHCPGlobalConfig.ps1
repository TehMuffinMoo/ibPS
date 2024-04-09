function Get-B1DHCPGlobalConfig {
    <#
    .SYNOPSIS
        Retrieves the BloxOneDDI Global DHCP Configuration

    .DESCRIPTION
        This function is used to retrieve the BloxOneDDI Global DHCP Configuration

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.
        
    .EXAMPLE
        PS> Get-B1DHCPGlobalConfig
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param (
        [String[]]$Fields
    )
    [System.Collections.ArrayList]$Filters = @()
    if ($Fields) {
        $Fields += "id"
        $Filters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($Filters) {
        $QueryString = ConvertTo-QueryString $Filters
    }
    Write-DebugMsg -Filters $Filters
    $Result = Query-CSP -Method "GET" -Uri "dhcp/global$($QueryString)" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    return $Result
}