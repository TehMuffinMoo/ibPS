function Get-B1DHCPGlobalConfig {
    <#
    .SYNOPSIS
        Retrieves the BloxOneDDI Global DHCP Configuration

    .DESCRIPTION
        This function is used to retrieve the BloxOneDDI Global DHCP Configuration

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1DHCPGlobalConfig

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
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
    $Result = Invoke-CSP -Method "GET" -Uri "dhcp/global$($QueryString)" | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    return $Result
}