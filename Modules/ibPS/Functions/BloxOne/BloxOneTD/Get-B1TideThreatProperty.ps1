function Get-B1TideThreatProperty {
    <#
    .SYNOPSIS
        Queries a list of threat properties

    .DESCRIPTION
        This function will query a list of threat properties

    .PARAMETER id
        Filter the results by property ID

    .PARAMETER Name
        Filter the results by property name

    .PARAMETER Class
        Filter the results by property threat class

    .PARAMETER ThreatLevel
        Filter the results by property threat level

    .EXAMPLE
        PS> Get-B1TideThreatProperty -Name "CamelCase" -ThreatLevel 100

    .EXAMPLE
        PS> Get-B1TideThreatProperty | ft -AutoSize

        link                                                                                id                                             name                           threat_level class                  active added                 updated               reference
        ----                                                                                --                                             ----                           ------------ -----                  ------ -----                 -------               ---------
        {@{href=/data/properties/APT_EmdiviC2; rel=self}}                                   APT_EmdiviC2                                   EmdiviC2                                100 APT                    true   10/28/2016 9:54:36PM  10/28/2016 9:54:36PM  {}
        {@{href=/data/properties/APT_ExploitKit; rel=self}}                                 APT_ExploitKit                                 Exploit Kit                             100 APT                    true                         1/28/2020 2:29:36AM   {}
        {@{href=/data/properties/APT_Generic; rel=self}}                                    APT_Generic                                    Generic                                 100 APT                    true                         4/23/2016 12:01:53AM  {}
        {@{href=/data/properties/APT_MalwareC2; rel=self}}                                  APT_MalwareC2                                  Malware C2                              100 APT                    true                         7/16/2018 6:37:50PM   {}
        {@{href=/data/properties/APT_MalwareDownload; rel=self}}                            APT_MalwareDownload                            Malware Download                        100 APT                    true                         3/2/2016 6:57:24PM    {}
        {@{href=/data/properties/Bot_Bankpatch; rel=self}}                                  Bot_Bankpatch                                  Bankpatch                               100 Bot                    true                         1/29/2020 5:12:49PM   {}
        {@{href=/data/properties/Bot_Citadel; rel=self}}                                    Bot_Citadel                                    Citadel                                 100 Bot                    true                         3/2/2016 6:57:24PM    {}
        {@{href=/data/properties/Bot_Cridex; rel=self}}                                     Bot_Cridex                                     Cridex                                  100 Bot                    true                         3/2/2016 6:57:24PM    {}
        ...

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding()]
    param(
      [string]$id,
      [string]$Name,
      [string]$Class,
      [int]$ThreatLevel
    )

    $Filters = @()
    if ($Name) {
      $Filters += "name=$Name"
    }
    if ($Class) {
      $Filters += "class=$Class"
    }
    if ($ThreatLevel) {
      $Filters += "threat_level=$ThreatLevel"
    }
    if ($Filters) {
        $Filter = ConvertTo-QueryString($Filters)
    }

    if ($id) {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/properties/$id$filter" -Method GET | Select-Object -ExpandProperty property -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } else {
      $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/tide/api/data/properties$filter" -Method GET | Select-Object -ExpandProperty property -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}