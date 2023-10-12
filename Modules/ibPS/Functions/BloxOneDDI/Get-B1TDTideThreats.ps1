function Get-B1TDTideThreats {
    <#
    .SYNOPSIS
        Queries active threats from the TIDE API

    .DESCRIPTION
        This function will query the active threats from the TIDE API

    .PARAMETER Hostname
        Use -Hostname to retrieve threats based on a hostname indicator

    .PARAMETER IP
        Use -IP to retrieve threats based on a IP indicator

    .PARAMETER URL
        Use -URL to retrieve threats based on a URL indicator

    .PARAMETER Email
        Use -Email to retrieve threats based on a Email indicator

    .PARAMETER Hash
        Use -Hash to retrieve threats based on a Hash indicator

    .PARAMETER Limit
        Used to set the maximum number of records to be returned (default is 100)

    .PARAMETER Type
        Use the -Type parameter to search by threat type and optionally indicator. Must be used in conjunction with the -Value parameter

    .PARAMETER Value
        The value to search based on the -Type selected

    .PARAMETER Distinct
        Threats may be considered separately by profile and property, depending on the value of the “distinct” query parameter. For example, assume an IP has been most recently submitted by an organization as Bot_Sality and Bot_Virut. If the “distinct” parameter is “property”, both records will be returned. If the “distinct” parameter is “profile”, only the most recently detected record from the organization will be returned.
        The default is "Property"

    .PARAMETER Id
        Filter the results by Threat ID

    .EXAMPLE
        Get-B1TDTideThreats -Hostname "google.com"

    .EXAMPLE
        Get-B1TDTideThreats -IP "1.1.1.1"

    .EXAMPLE
        Get-B1TDTideThreats -Hostname eicar.co -Limit 10

    .EXAMPLE
        Get-B1TDTideThreats -Type Host -Value eicar.co -Distinct Profile

    .EXAMPLE
        Get-B1TDTideThreats -Type URL -Age Recent

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName = 'host')]
    param(
        [parameter(ParameterSetName="host")]
        [String]$Hostname,
        [parameter(ParameterSetName="ip")]
        [String]$IP,
        [parameter(ParameterSetName="url")]
        [String]$URL,
        [parameter(ParameterSetName="email")]
        [String]$Email,
        [parameter(ParameterSetName="hash")]
        [String]$Hash,
        [parameter(ParameterSetName="type")]
        [ValidateSet("Host","IP","URL","Email","Hash")]
        [String]$Type,
        [parameter(ParameterSetName="type")]
        [String]$Value,
        [parameter(ParameterSetName="type")]
        [ValidateSet("Recent","Hourly","Daily","Weekly","Monthly")]
        [String]$Age,
        [parameter(ParameterSetName="type")]
        [ValidateSet("Property","Profile")]
        [String]$Distinct = "Property",
        [parameter(ParameterSetName="id")]
        [String]$Id,
        [int]$Limit = 100
    )

    if ($Value -and $Age) {
        Write-Error "-Value and -Age are mutually exclusive, you can only select one of these parameters."
        break
    } elseif ($Type -and -not $Value -and -not $Age) {
        Write-Error "-Value or -Age are required when specifying -Type"
        break
    }

    if ($Hostname) {
      $Uri = "/tide/api/data/threats?host=$Hostname&rlimit=$Limit"
    } elseif ($IP) {
      $Uri = "/tide/api/data/threats?ip=$IP&rlimit=$Limit"
    } elseif ($URL) {
      $Uri = "/tide/api/data/threats?url=$URL&rlimit=$Limit"
    } elseif ($Email) {
      $Uri = "/tide/api/data/threats?email=$Email&rlimit=$Limit"
    } elseif ($Hash) {
      $Uri = "/tide/api/data/threats?hash=$Hash&rlimit=$Limit"
    } elseif ($Id) {
      $Uri = "/tide/api/data/threats/id/$Id"  
    } elseif ($Type) {
      if ($Value) {
        $Uri = "/tide/api/data/threats/state?type=$($Type.ToLower())&$Type=$Value&distinct=$($Distinct.ToLower())&rlimit=$Limit"
      }
      if ($Age) {
        $Uri = "/tide/api/data/threats/$($Type.ToLower())/$($Age.ToLower())?rlimit=$Limit"
      }
    } else {
      Write-Error "Error. You must specify either Hostname, IP, URL, Email or Hash"
    }

    if ($Uri) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)$Uri"
        if ($Results) {
            if ($Id) {
              return $Results
            } else {
              return $Results | Select-Object -ExpandProperty threat -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            }
        }
    }
}