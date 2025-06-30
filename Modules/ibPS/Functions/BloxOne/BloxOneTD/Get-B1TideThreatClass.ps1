function Get-B1TideThreatClass {
    <#
    .SYNOPSIS
        Queries a list of threat classes

    .DESCRIPTION
        This function will query a list of threat classes

    .PARAMETER id
        Filter the results by class ID

    .EXAMPLE
        PS> Get-B1TideThreatClass

        link                                                            id                     name                      updated
        ----                                                            --                     ----                      -------
        {@{href=/data/threat_classes/APT; rel=self}}                    APT                    APT                       3/2/2016 6:57:24PM
        {@{href=/data/threat_classes/Bot; rel=self}}                    Bot                    Bot                       3/2/2016 6:57:24PM
        {@{href=/data/threat_classes/CompromisedDomain; rel=self}}      CompromisedDomain      Compromised Domain
        {@{href=/data/threat_classes/CompromisedHost; rel=self}}        CompromisedHost        Compromised Host
        ...

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Infoblox Threat Defense
    #>
    [CmdletBinding()]
    param(
      [string]$id
    )

    if ($id) {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/threat_classes/$($id)?detail=true" -Method GET -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/threat_classes?detail=true" -Method GET | Select-Object -ExpandProperty threat_class -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}