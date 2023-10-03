function Get-B1TDDossierSupportedFeedback {
    <#
    .SYNOPSIS
        Queries a list of available dossier feedback types

    .DESCRIPTION
        The Dossier Indicators cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) feedback types.

    .Example
        Get-B1TDDossierSupportedFeedback
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
    )
 
    $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/feedback/types" -Method GET | Select-Object -ExpandProperty types -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
  
    if ($Results) {
      return $Results
    }
}