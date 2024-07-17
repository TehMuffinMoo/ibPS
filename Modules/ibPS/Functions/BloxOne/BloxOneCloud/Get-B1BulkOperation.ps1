function Get-B1BulkOperation {
    <#
    .SYNOPSIS
        Used to query BloxOne Bulk Operations

    .DESCRIPTION
        This function is used to query BloxOne Bulk Operations

    .PARAMETER id
        Filter the results by bulk operation id

    .PARAMETER Name
        Filter the results by bulk operation name

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1BulkOperation -Name "Backup of all CSP data"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Tasks
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
        [string]$id,
        [string]$Name,
        [Switch]$Strict,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
	$MatchType = Match-Type $Strict
    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }

    Write-DebugMsg -Filters $QueryFilters

    if($PSCmdlet.ShouldProcess('Query Bulk Operations','Query Bulk Operations',$MyInvocation.MyCommand)){
        if ($QueryString) {
            Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/operation$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        } else {
            Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/operation" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
    }
}