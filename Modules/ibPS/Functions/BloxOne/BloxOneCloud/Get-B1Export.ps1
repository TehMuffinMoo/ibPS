﻿function Get-B1Export {
    <#
    .SYNOPSIS
        Used to query BloxOne Export Jobs

    .DESCRIPTION
        This function is used to query BloxOne Export Jobs

    .PARAMETER id
        Filter the results by the id of the export job

    .PARAMETER Name
        Filter the results by the name of the export job

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1Export -Name "Backup of all CSP data"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Tasks
    #>
    [CmdletBinding()]
    param(
        [String]$id,
        [String]$Name,
        [Switch]$Strict
    )
    Get-B1BulkOperation -id $($id) -Name $($Name) -Strict:$Strict -Type export
}