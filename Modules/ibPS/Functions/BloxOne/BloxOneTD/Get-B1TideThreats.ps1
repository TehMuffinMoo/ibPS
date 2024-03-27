function Get-B1TideThreats {
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

    .PARAMETER Age
        Filter the results by the age of the threat

    .PARAMETER Value
        The value to search based on the -Type selected

    .PARAMETER Distinct
        Threats may be considered separately by profile and property, depending on the value of the “distinct” query parameter. For example, assume an IP has been most recently submitted by an organization as Bot_Sality and Bot_Virut. If the “distinct” parameter is “property”, both records will be returned. If the “distinct” parameter is “profile”, only the most recently detected record from the organization will be returned.
        The default is "Property"

    .PARAMETER Id
        Filter the results by Threat ID

    .EXAMPLE
        PS> Get-B1TideThreats -Hostname "google.com"

    .EXAMPLE
        PS> Get-B1TideThreats -IP "1.1.1.1"

    .EXAMPLE
        PS> Get-B1TideThreats -Hostname eicar.co -Limit 10

    .EXAMPLE
        PS> Get-B1TideThreats -Type Host -Value eicar.co -Distinct Profile

        id                      : d123456-f9d4-11ed-9fe7-123456789
        type                    : HOST
        host                    : eicar.co
        domain                  : eicar.co
        tld                     : co
        profile                 : IID
        property                : MaliciousNameserver_Generic
        class                   : MaliciousNameserver
        threat_level            : 100
        confidence              : 100
        detected                : 5/24/2023 1:45:30AM
        received                : 5/24/2023 1:46:36AM
        imported                : 5/24/2023 1:46:36AM
        expiration              : 5/24/2043 1:45:30AM
        dga                     : false
        up                      : true
        batch_id                : d123456-f9d4-11ed-9fe7-123456789
        threat_score            : 6.3
        threat_score_rating     : Medium
        threat_score_vector     : TSIS:1.0/AV:N/AC:L/PR:L/UI:N/EX:L/MOD:L/AVL:L/CI:N/ASN:N/TLD:N/DOP:N/P:F
        confidence_score        : 8
        confidence_score_rating : High
        confidence_score_vector : COSIS:1.0/SR:H/POP:N/TLD:N/CP:F
        risk_score              : 7.9
        risk_score_rating       : High
        risk_score_vector       : RSIS:1.0/TSS:M/TLD:N/CVSS:M/EX:L/MOD:L/AVL:L/T:M/DT:M
        extended                : @{cyberint_guid=0718b50d524c42a70eb459c28d9891bf; notes=This is an artificial indicator created by Infoblox for monitoring and testing the health of Infoblox managed services. It is also used in security demonstrations by the Infoblox sales and tech support 
                                teams. The "EICAR" name was inspired by the European Institute for Computer Antivirus Research (EICAR) antivirus test file called EICAR. This is not an inherently malicious domain.}

    .EXAMPLE
        Get-B1TideThreats -Type URL -Age Hourly | ft detected,type,host,threat_level,tld,url -AutoSize

        detected            type host                                                                      threat_level tld             url
        --------            ---- ----                                                                      ------------ ---             ---
        3/6/2024 6:56:10AM  URL  themes-app.netlify.app                                                              80 netlify.app     http://themes-app.netlify.app/img/yt.png
        3/6/2024 3:55:10AM  URL  trsfr.com                                                                           80 com             https://trsfr.com/PDF/paid.exe
        3/6/2024 4:56:10AM  URL  dev-zimba.pantheonsite.io                                                           80 pantheonsite.io https://dev-zimba.pantheonsite.io/loginpage/Epdf.php
        3/6/2024 6:56:10AM  URL  themes-app.netlify.app                                                              80 netlify.app     https://themes-app.netlify.app/img/yt.png
        3/5/2024 9:55:10PM  URL  bafkreih7azguzaxjuphwrbrak4r2cv4gvz3mkh2uxrj3aaddfisglbi3t4.ipfs.w3s.link           80 link            https://bafkreih7azguzaxjuphwrbrak4r2cv4gvz3mkh2uxrj3aaddfisglbi3t4.ipfs.w3s.link/?filename=save.js
        3/6/2024 6:56:10AM  URL  themes-app.netlify.app                                                              80 netlify.app     https://themes-app.netlify.app/img/tw.png
        ...

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
        [parameter(ParameterSetName="With ID")]
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