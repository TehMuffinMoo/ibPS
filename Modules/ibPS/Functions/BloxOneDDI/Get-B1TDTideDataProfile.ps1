function Get-B1TDTideDataProfile {
    <#
    .SYNOPSIS
        Queries a list of TIDE Data Profiles

    .DESCRIPTION
        This function is used to query a list of TIDE Data Profiles

    .PARAMETER Name
        Use this parameter to filter by Name

    .Example
        Get-B1TDTideDataProfiles -Name "My Profile"
    
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
          $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/dataprofiles/$Name" -Method GET -ErrorAction SilentlyContinue | select -ExpandProperty profile -ErrorAction SilentlyContinue
      } else {
          $Results = Query-CSP -Uri "$(Get-B1CspUrl)/tide/admin/v1/resources/dataprofiles" -Method GET -ErrorAction SilentlyContinue | select -ExpandProperty profiles -ErrorAction SilentlyContinue
      }
  
      if ($Results) {
        return $Results
      }
    }
}