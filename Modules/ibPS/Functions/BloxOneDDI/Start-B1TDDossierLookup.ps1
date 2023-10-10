function Start-B1TDDossierLookup {
    <#
    .SYNOPSIS
        Performs a single lookup against the BloxOne Threat Defense Dossier

    .DESCRIPTION
        This function is used to perform a single lookup against the BloxOne Threat Defense Dossier

    .PARAMETER Type
        The indicator type to search on

    .PARAMETER Value
        The indicator value to search on

    .PARAMETER Source
        The sources to query. Multiple sources can be specified, if no source is specified, the call will search on all available sources.
        A list of supported sources can be obtained by using the Get-B1TDDossierSupportedSources cmdlet

    .PARAMETER Wait
        If this switch is set, the API call will wait for job completion before returning

    .Example
        Start-B1TDDossierLookup -Type ip -Value 1.1.1.1

    .EXAMPLE
        Start-B1TDDossierLookup -Type host -Value eicar.co
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("host", "ip", "url", "hash", "email")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$Value,
      [String[]]$Source,
      [Switch]$Wait
    )
    
    $Filters = @()

    $Filters += "value=$Value"
    if ($Source) {
      $Filters += "source=$Source"
    }
    if ($Wait) {
      $Filters += "wait=true"
    }

    $CombinedFilters = Combine-Filters2 $Filters

    if ($CombinedFilters) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/tide/api/services/intel/lookup/indicator/$Type$CombinedFilters" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}