﻿function Get-B1DHCPGlobalConfig {
    <#
    .SYNOPSIS
        Retrieves the Universal DDI Global DHCP Configuration

    .DESCRIPTION
        This function is used to retrieve the Universal DDI Global DHCP Configuration

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .EXAMPLE
        PS> Get-B1DHCPGlobalConfig

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding()]
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