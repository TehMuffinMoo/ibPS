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

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1CSPCurrentUser

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    [CmdletBinding(
        DefaultParameterSetName = 'None',
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
        [Parameter(ParameterSetName="Groups")]
        [Switch]$Groups,
        [Parameter(ParameterSetName="Account")]
        [Switch]$Account,
        [Parameter(ParameterSetName="Compartments")]
        [Switch]$Compartments,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if ($Groups) {
        if($PSCmdlet.ShouldProcess("List The Current CSP User`'s Groups","List Current CSP User`'s Groups",$MyInvocation.MyCommand)){
            Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user/groups" | Select-Object -ExpandProperty results
        }
    } elseif ($Account) {
        if($PSCmdlet.ShouldProcess("List The Current CSP User`'s Accounts","List Current CSP User`'s Accounts",$MyInvocation.MyCommand)){
            Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user/accounts" | Select-Object -ExpandProperty results
        }
    } elseif ($Compartments) {
        if($PSCmdlet.ShouldProcess("List The Current CSP User`'s Compartments","List Current CSP User`'s Compartments",$MyInvocation.MyCommand)){
            Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user/compartments" | Select-Object -ExpandProperty results
        }
    } else {
        if($PSCmdlet.ShouldProcess("List The Current CSP User`'s Details","List Current CSP User`'s Details",$MyInvocation.MyCommand)){
            Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/current_user" | Select-Object -ExpandProperty result
        }
    }
}
