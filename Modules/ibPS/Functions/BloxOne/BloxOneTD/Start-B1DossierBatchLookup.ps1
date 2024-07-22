function Start-B1DossierBatchLookup {
    <#
    .SYNOPSIS
        Perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

    .DESCRIPTION
        This function is used to perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

    .PARAMETER Type
        The indicator type to search on

    .PARAMETER Target
        The indicator target(s) to search on

    .PARAMETER Source
        The sources to query. Multiple sources can be specified.
        A list of supported sources can be obtained by using the Get-B1DossierSupportedSources cmdlet

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Start-B1DossierBatchLookup -Type ip -Target "1.1.1.1","1.0.0.1" -Source "apt","mandiant"

        status  job_id                               job
        ------  ------                               ---
        pending 12345678-2228-433e-9578-12345678980d @{id=12345678-2228-433e-9578-12345678980d; state=created; status=pending; create_ts=1709744311615; create_time=3/6/2024 4:58:31PM; start_ts=1709744311615; start_time=3/6/2024 4:58:31PM; request_ttl=0; result_ttl=3600; pending_tasks=System.Ob…

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("host", "ip", "url", "hash", "email")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String[]]$Target,
      [Parameter(Mandatory=$true)]
      [String[]]$Source,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $Splat = @{
      "target" = @()
    }

    if ($Target.count -eq 1) {
        $Splat.target = @{
            "one" = @{
                "type" = $Type
                "target" = $Target[0]
                "sources" = $Source
            }
        }
    } elseif ($Target.count -gt 1) {
        $Splat.target = @{
            "group" = @{
                "type" = $Type
                "targets" = $Target
                "sources" = $Source
            }
        }
    }

    $JSON = $Splat | ConvertTo-Json -Depth 5
    if($PSCmdlet.ShouldProcess("Start Dossier Batch Lookup:`n$(JSONPretty($JSON))","Start Dossier Batch Lookup.",$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/tide/api/services/intel/lookup/jobs" -Data $JSON
        if ($Results) {
            return $Results
        }
    }
}