function Get-B1DossierSupportedFeedback {
    <#
    .SYNOPSIS
        Queries a list of available dossier feedback types

    .DESCRIPTION
        The Dossier Indicators cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) feedback types.

    .EXAMPLE
        PS> Get-B1DossierSupportedFeedback

        False Positive, This indicator is NOT a threat
        False Negative, This indicator is a threat
        Infoblox Web Category is Incorrect
        Lookalike Detection is incorrect
        Application Detection is incorrect

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
    )

    $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/feedback/types" -Method GET | Select-Object -ExpandProperty types -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
      return $Results
    }
}