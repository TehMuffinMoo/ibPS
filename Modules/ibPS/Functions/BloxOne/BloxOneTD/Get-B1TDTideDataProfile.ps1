function Get-B1TDTideDataProfile {
    <#
    .SYNOPSIS
        Queries a list of TIDE Data Profiles

    .DESCRIPTION
        This function is used to query a list of TIDE Data Profiles

    .PARAMETER Name
        Use this parameter to filter by Name. Supports tab-completion.

    .EXAMPLE
        PS> Get-B1TDTideDataProfiles -Name "My Profile"

    .EXAMPLE
        PS> Get-B1TDTideDataProfile | ft -AutoSize

        id                                           name                      description                  policy      default_ttl active rpzfeedname
        --                                           ----                      -----------                  ------      ----------- ------ -----------
        0014B00014BaC3hQKF:AntiMalware-Profile       AntiMalware-Profile       AntiMalware - Data Profile   default-csp        True   True amfeed
        0014B00014BaC3hQKF:KnownBad-Profile          KnownBad-Profile          Known Bad - Data Profile     default-csp        True   True kbfeed
        0014B00014BaC3hQKF:Test-Profile              Test-Profile              Test - Data Profile          default-csp        True  False tsfeed
        0014B00014BaC3hQKF:Secure-Profile            Secure-Profile            Secure - Data Profile        default-csp        True   True scfeed
        ...
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
      [String]$Name
    )

    process {
      if ($Name) {
          $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/dataprofiles/$Name" -Method GET -ErrorAction SilentlyContinue | Select-Object -ExpandProperty profile -ErrorAction SilentlyContinue
      } else {
          $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/dataprofiles" -Method GET -ErrorAction SilentlyContinue | Select-Object -ExpandProperty profiles -ErrorAction SilentlyContinue
      }
  
      if ($Results) {
        return $Results
      }
    }
}