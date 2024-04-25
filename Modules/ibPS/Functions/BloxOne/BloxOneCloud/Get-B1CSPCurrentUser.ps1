function Get-B1CSPCurrentUser {
    <#
    .SYNOPSIS
        Retrieves the user associated with the current API key

    .DESCRIPTION
        This function will retrieve the user associated with the current API key

    .PARAMETER Groups
        Using the -Groups switch will return a list of Groups associated with the current user

    .EXAMPLE
        PS> Get-B1CSPCurrentUser

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [Switch]$Groups
    )
    if ($Groups) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user/groups" | Select-Object -ExpandProperty results
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user" | Select-Object -ExpandProperty result
    }
}