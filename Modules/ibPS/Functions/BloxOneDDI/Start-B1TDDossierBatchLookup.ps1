﻿function Start-B1TDDossierBatchLookup {
    <#
    .SYNOPSIS
        Perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

    .DESCRIPTION
        This function is used to perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

    .PARAMETER Type
        The indicator type to search on

    .PARAMETER Value
        The indicator target(s) to search on

    .PARAMETER Source
        The sources to query. Multiple sources can be specified.
        A list of supported sources can be obtained by using the Get-B1TDDossierSupportedSources cmdlet

    .Example
        Start-B1TDDossierBatchLookup -Type ip -Target "1.1.1.1","1.0.0.1" -Source "apt","mandiant"
   
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
      [String[]]$Target,
      [Parameter(Mandatory=$true)]
      [String[]]$Source
    )
    
    $RequestBody = @{
      "target" = @()
    }

    if ($Target.count -eq 1) {
        $RequestBody.target = @{
            "one" = @{
                "type" = $Type
                "target" = $Target[0]
                "sources" = $Source
            }
        }
    } elseif ($Target.count -gt 1) {
        $RequestBody.target = @{
            "group" = @{
                "type" = $Type
                "targets" = $Target
                "sources" = $Source
            }
        }
    }

    $RequestJSON = $RequestBody | ConvertTo-Json -Depth 5

    if ($RequestBody) {
        $Results = Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/tide/api/services/intel/lookup/jobs" -Data $RequestJSON
    }

    if ($Results) {
        return $Results
    }

}