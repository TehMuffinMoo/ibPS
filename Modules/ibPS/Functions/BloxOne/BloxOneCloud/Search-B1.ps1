function Search-B1 {
    <#
    .SYNOPSIS
        Query the BloxOneDDI CSP Global Search

    .DESCRIPTION
        This function is used to query the BloxOneDDI CSP Global Search

    .PARAMETER Query
        Search query

    .PARAMETER IncludeQueryDetails
        Use this parameter to include the query shard, aggregation, state, and duration data.
        By default, the hits property is auto-expanded

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Search-B1 "10.10.100.1"

    .EXAMPLE
        PS> Search-B1 "mysubzone.corp.com"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Search
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Query,
        [Switch]$IncludeQueryDetails,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $Body = @{
      "query"=$Query
    } | ConvertTo-Json | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_)}
    if($PSCmdlet.ShouldProcess("Search BloxOne","Search BloxOne",$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/atlas-search-api/v1/search" -Method "POST" -Data $Body
        if ($IncludeQueryDetails) {
            $Results
        } else {
            $Results.hits | Select-Object -ExpandProperty hits
        }
    }
}