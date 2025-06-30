function Get-B1Import {
    <#
    .SYNOPSIS
        Used to query BloxOne Import Jobs

    .DESCRIPTION
        This function is used to query BloxOne Import Jobs

    .PARAMETER id
        Filter the results by the id of the import job

    .PARAMETER Name
        Filter the results by the name of the import job

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1Import -Name "Import backup"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Tasks
    #>
    [CmdletBinding()]
    param(
        [String]$id,
        [String]$Name,
        [Switch]$Strict
    )
    Get-B1BulkOperation -id $($id) -Name $($Name) -Strict:$Strict -Type import
}