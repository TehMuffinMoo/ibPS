﻿function Get-B1Licenses {
    <#
    .SYNOPSIS
        Retrieves a list of licenses associated with the BloxOne Account

    .DESCRIPTION
        This function is used query a list of licenses associated with the BloxOne Account

    .PARAMETER State
        Use the -State parameter to filter by license state. (all/active/expired)

    .EXAMPLE
        PS> Get-B1Licenses -State all

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense

    .FUNCTIONALITY
        Licenses
    #>
    [CmdletBinding()]
    param(
        [ValidateSet('all','active','expired')]
        [String]$State = "all"
    )
    $QueryFilters = @()
    if ($State) {
        $QueryFilters += "state=$($State)"
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString($QueryFilters)
    }

    $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/licensing/v1/licenses$QueryString" | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue

    if ($Results) {
    return $Results
    } else {
    Write-Host "Error. No BloxOne Licenses found." -ForegroundColor Red
    }
}