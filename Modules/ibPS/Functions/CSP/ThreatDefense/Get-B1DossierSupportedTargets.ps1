﻿function Get-B1DossierSupportedTargets {
    <#
    .SYNOPSIS
        Queries a list of available dossier indicator types

    .DESCRIPTION
        The Dossier Indicators cmdlet returns a list of all Dossier (sometimes referred to as Intel Lookup) indicator types and whether or not they are available for the caller.

    .PARAMETER Source
        Filter the supported targets based on Source

        You can get a list of supported sources using Get-B1DossierSupportedSources

    .EXAMPLE
        PS> Get-B1DossierSupportedTargets

        ip
        host
        url
        hash
        email

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Infoblox Threat Defense
    #>
    [CmdletBinding()]
    param(
        [String]$Source
    )

    if ($Source) {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/source/$Source/targets" -Method GET
    } else {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/services/intel/lookup/targets" -Method GET
    }

    if ($Results) {
      return $Results
    }
}