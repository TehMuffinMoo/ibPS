﻿function Start-B1DossierLookup {
    <#
    .SYNOPSIS
        Performs a single lookup against the Infoblox Threat Defense Dossier

    .DESCRIPTION
        This function is used to perform a single lookup against the Infoblox Threat Defense Dossier

    .PARAMETER Type
        The indicator type to search on

    .PARAMETER Value
        The indicator value to search on

    .PARAMETER Source
        The sources to query. Multiple sources can be specified, if no source is specified, the call will search on all available sources.
        A list of supported sources can be obtained by using the Get-B1DossierSupportedSources cmdlet

    .PARAMETER Wait
        If this switch is set, the API call will wait for job completion before returning

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Start-B1DossierLookup -Type ip -Value 1.1.1.1

    .EXAMPLE
        PS> Start-B1DossierLookup -Type host -Value eicar.co

        status  job_id                               job
        ------  ------                               ---
        pending 123456788-123d-4565-6452-05fgdgv54t4fvswe @{id=123456788-123d-4565-6452-05fgdgv54t4fvswe; state=created; status=pending; create_ts=1709744367885; create_time=2024-03-06T16:59:27.88511568Z; start_ts=1709744367885; start_time=2024-03-06T16:59:27.88511568Z; request_ttl=0; result_ttl=3600; p…

    .FUNCTIONALITY
        Universal DDI

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
      [String]$Value,
      [String[]]$Source,
      [Switch]$Wait,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $Filters = @()

    $Filters += "value=$Value"
    if ($Source) {
      $Filters += "source=$Source"
    }
    if ($Wait) {
      $Filters += "wait=true"
    }

    $CombinedFilters = ConvertTo-QueryString $Filters

    if($PSCmdlet.ShouldProcess("Start Dossier Lookup.","Start Dossier Lookup.",$MyInvocation.MyCommand)){
        if ($CombinedFilters) {
            $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/tide/api/services/intel/lookup/indicator/$Type$CombinedFilters" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }

        if ($Results) {
            if (($Results.GetType().Name -eq 'String')) {
                try {
                    Write-Debug 'Invoke response failed to convert JSON. Attempting alternative conversion..'
                    if ($PSVersionTable.PSVersion.Major -le 5) {
                        $Results = ConvertFrom-ComplexJSON $Results
                    } else {
                        $Results = $Results | ConvertFrom-Json -AsHashtable | ConvertFrom-HashTable
                    }
                } catch {
                    Write-Error "Failed to convert JSON response."
                    Write-Error $_
                    return $null
                }
            }
            if ($Wait) {
                $ReturnProperties = @{
                    Property =  @{n="status";e={$_.status}},
                                @{n="job_id";e={$_.job_id}},
                                @{n="job";e={$_.job}},
                                @{n="tasks";e={$_.tasks}},
                                @{n="results";e={$_.results | ConvertFrom-HashTable}}
                }
                return $Results | Select-Object @ReturnProperties
            } else {
                return $Results
            }
        }
    }
}