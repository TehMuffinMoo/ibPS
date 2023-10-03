function Get-B1TDDossierSupportedSources {
    <#
    .SYNOPSIS
        Queries a list of available dossier sources

    .DESCRIPTION
        The Dossier Sources cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) sources and whether or not they are available for the caller.

    .Example
        Get-B1TDDossierSupportedSources -Target ip
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [ValidateSet("ip","host","url","email","hash")]
        [String]$Target
    )
 
    if ($Target) {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/sources/target/$Target" -Method GET
    } else {
      $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/sources" -Method GET
    }
  
    if ($Results) {
      return $Results
    }
}