function Get-B1DossierSupportedTargets {
    <#
    .SYNOPSIS
        Queries a list of available dossier indicator types

    .DESCRIPTION
        The Dossier Indicators cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) indicator types and whether or not they are available for the caller.

    .Example
        Get-B1DossierSupportedTargets
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [String]$Source
    )
 
    if ($Source) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/source/$Source/targets" -Method GET
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/targets" -Method GET
    }
  
    if ($Results) {
      return $Results
    }
}