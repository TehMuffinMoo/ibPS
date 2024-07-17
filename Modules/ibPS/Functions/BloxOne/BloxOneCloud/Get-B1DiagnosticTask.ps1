function Get-B1DiagnosticTask {
    <#
    .SYNOPSIS
        Query a list of BloxOneDDI Diagnostic Tasks

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI Diagnostic Tasks

    .PARAMETER id
        The id of the diagnostic task to filter by

    .PARAMETER download
        This switch indicates if to download the results returned

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Get-B1DiagnosticTask -id diagnostic/task/abcde634-2113-ddef-4d05-d35ffs1sa4 -download

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
        [Parameter(Mandatory=$true)]
        [String]$id,
        [Switch]$Download,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if ($download) {
      if($PSCmdlet.ShouldProcess("$($id)","Download the diagnostic task results")){
        $URI = "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task/$($id)/download"
        $Result = Invoke-CSP -Method GET -Uri $URI
      }
    } else {
      if($PSCmdlet.ShouldProcess("$($id)","Get the diagnostic task details")){
        $URI = "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task/$($id)"
        $Result = Invoke-CSP -Method GET -Uri $URI | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
      }
    }

    if ($Result) {
        return $Result
    }
}