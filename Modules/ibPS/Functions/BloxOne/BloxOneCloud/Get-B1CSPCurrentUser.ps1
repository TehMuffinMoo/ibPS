function Get-B1CSPCurrentUser {
    <#
    .SYNOPSIS
        Retrieves the user associated with the current API key

    .DESCRIPTION
        This function will retrieve the user associated with the current API key

    .PARAMETER Groups
        Using the -Groups switch will return a list of Groups associated with the current user

    .PARAMETER Compartments
        Using the -Compartments switch will return a list of Compartments associated with the current user

    .PARAMETER Account
        Using the -Account switch will return the account data associated with the current user

    .EXAMPLE
        PS> Get-B1CSPCurrentUser

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param(
        [Parameter(ParameterSetName="Groups")]
        [Switch]$Groups,
        [Parameter(ParameterSetName="Account")]
        [Switch]$Account,
        [Parameter(ParameterSetName="Compartments")]
        [Switch]$Compartments
    )
    if ($Groups) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user/groups" | Select-Object -ExpandProperty results
    } elseif ($Account) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user/accounts" | Select-Object -ExpandProperty results
    } elseif ($Compartments) {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user/compartments" | Select-Object -ExpandProperty results
    } else {
        Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user" | Select-Object -ExpandProperty result
    }
}
