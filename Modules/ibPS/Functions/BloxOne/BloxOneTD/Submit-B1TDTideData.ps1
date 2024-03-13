function Submit-B1TDTideData {
    <#
    .SYNOPSIS
        Used to submit threat indicators into a TIDE Data Profile

    .DESCRIPTION
        This function is used to submit threat indicators into a TIDE Data Profile

    .PARAMETER Profile
        This is the data profile name to submit the TIDE data to

    .PARAMETER RecordType
        The record type indicates the type of indicator you are submitting. This can be host, ip, url, email, or hash.

    .PARAMETER RecordValue
        This is the threat/indicator Hostname, IP, URL, Email or Hash value to submit.
          This depends on the -RecordType parameter

    .PARAMETER external_id
        This is a string indicating an external ID to assign to the batch (optional).

    .PARAMETER Detected
        The date/time the threat was detected in as a Date/Time object. This is converted to ISO8601 format prior to submission.

    .PARAMETER Class
        The threat's class. For example: Sinkhole.  Note: Either "class" or "property" is required, but not both.

    .PARAMETER Property
        The threat's property, For example, Sinkhole_SinkholedHost. Note: Either "class" or "property" is required, but not both.

    .PARAMETER Confidence
        The threat's confidence score ranging from 0 - 100 (optional).
    
    .PARAMETER Domain
        The domain string (optional).

    .PARAMETER Duration
        The duration of the threat in Xd format or XyXmXwXdXh format.
        
        The expiration date will be set to the detected date + this duration (optional).

    .PARAMETER Expiration
        The expiration is the date & time that the threat will expire.

    .PARAMETER ThreatLevel
        The threat's level ranging from 0 - 100 as an integer (optional).

    .PARAMETER Target
        The target of the threat (optional). For example: “fakeamazon.com” is a threat targeting “amazon.com”.

    .PARAMETER TLD
        The top-level domain, string (optional). 

    .PARAMETER ThreatClass
        The Threat/Indicator class and supports tab-completion.
        
        This is mutually exclusive with -ThreatProperty

    .PARAMETER ThreatProperty
        The Threat/Indicator property and supports tab-completion.
        
        This is mutually exclusive with -ThreatClass

    .PARAMETER File
        The -File parameter accepts a CSV/TSV/PSV, JSON or XML file.

        This should conform to the formats listed here: https://docs.infoblox.com/space/BloxOneThreatDefense/35434535/TIDE+Data+Submission+Overview
    
    .EXAMPLE
        PS> Submit-B1TDTideData -Profile my-dataprofile -ThreatClass Malicious -RecordType host -RecordValue superbaddomain.com -Detected (Get-Date).AddHours(-7) -ThreatLevel 10 -Confidence 30

        link           : {@{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74; rel=self}, 
                        @{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74/detail; rel=detail}}
        id             : csdv8d8s-fdss-14fe-vsee-cdsuddcs74
        submitted      : 3/13/2024 9:41:39PM
        imported       : 3/13/2024 9:41:39PM
        profile        : 0015J44662GhD3jFGF:my-dataprofile
        status         : DONE
        user           : user.service.dsjcdvse-dssd-dsvc-e83d-csd8cuds3d@infoblox.invalid
        organization   : 0015J44662GhD3jFGF
        method         : ui
        type           : HOST
        total          : 1
        num_successful : 1
        num_errors     : 0

    .EXAMPLE
        ## This supports all file types supported by TIDE, including CSV/TSV/PSV, JSON & XML
        PS> Submit-B1TDTideData -Profile my-dataprofile -File ../tide.csv

        link           : {@{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74; rel=self}, 
                        @{href=/data/batches/csdv8d8s-fdss-14fe-vsee-cdsuddcs74/detail; rel=detail}}
        id             : csdv8d8s-fdss-14fe-vsee-cdsuddcs74
        submitted      : 3/13/2024 9:42:14PM
        imported       : 3/13/2024 9:42:14PM
        profile        : 0015J44662GhD3jFGF:my-dataprofile
        status         : DONE
        user           : user.service.dsjcdvse-dssd-dsvc-e83d-csd8cuds3d@infoblox.invalid
        organization   : 0015J44662GhD3jFGF
        method         : ui
        type           : HOST
        total          : 1422
        num_successful : 1422
        num_errors     : 0
    
    .FUNCTIONALITY
        BloxOneDDI
        
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    Param(
        [Parameter(Mandatory=$true,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$true,ParameterSetName=("Property"))]
        [Parameter(Mandatory=$true,ParameterSetName=("File"))]
        [String]$Profile,
        [Parameter(Mandatory=$true,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$true,ParameterSetName=("Property"))]
        [ValidateSet('host','ip','url','email','hash')]
        [String]$RecordType,
        [Parameter(Mandatory=$true,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$true,ParameterSetName=("Property"))]
        [String]$RecordValue,
        [Parameter(Mandatory=$true,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$true,ParameterSetName=("Property"))]
        [String]$external_id,
        [Parameter(Mandatory=$true,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$true,ParameterSetName=("Property"))]
        [datetime]$Detected,
        [Parameter(Mandatory=$true,ParameterSetName="Class")]
        [String]$ThreatClass,
        [Parameter(Mandatory=$true,ParameterSetName="Property")]
        [String]$ThreatProperty,
        [Parameter(Mandatory=$false,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$false,ParameterSetName=("Property"))]
        [ValidateRange(1, 100)]
        [int]$Confidence,
        [Parameter(Mandatory=$false,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$false,ParameterSetName=("Property"))]
        [String]$Domain,
        [Parameter(Mandatory=$false,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$false,ParameterSetName=("Property"))]
        [String]$Duration,
        [Parameter(Mandatory=$false,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$false,ParameterSetName=("Property"))]
        [datetime]$Expiration,
        [ValidateRange(1, 100)]
        [Parameter(Mandatory=$false,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$false,ParameterSetName=("Property"))]
        [String]$ThreatLevel,
        [Parameter(Mandatory=$false,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$false,ParameterSetName=("Property"))]
        [String]$Target,
        [Parameter(Mandatory=$false,ParameterSetName=("Class"))]
        [Parameter(Mandatory=$false,ParameterSetName=("Property"))]
        [String]$TLD,
        [Parameter(Mandatory=$true,ParameterSetName="File")]
        [String]$File
	  )

    Process {

      if (!(Get-B1TDTideDataProfile -Name $($Profile))) {
        Write-Error "Error. TIDE Data Profile does not exist: $($Profile)"
        break
      }

      if ($File) {
        $FileContents = Get-Content $($File) -Raw
        Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/tide/api/data/batches?profile=$($Profile)" -Data $FileContents -ContentType 'text/plain'
      } else {

        $DetectedTime = $Detected.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.000Z")
        
        $Feed = @{
            "feed" = @{
            "profile" = "$($Profile)"
            "record_type" = "$($RecordType)"
            "record" = @(@{
                "$($RecordType)" = "$($RecordValue)"
                "detected" = "$($DetectedTime)"
            })
            }
        }

        if ($ThreatClass) {
            $Feed.feed.record[0].class = "$($ThreatClass)"
        }
        if ($ThreatProperty) {
            $Feed.feed.record[0].property = "$($ThreatProperty)"
        }
        if ($Confidence) {
            $Feed.feed.record[0].confidence = "$($Confidence)"
        }
        if ($Domain) {
            $Feed.feed.record[0].domain = "$($Domain)"
        }
        if ($Duration) {
            $Feed.feed.record[0].duration = "$($Duration)"
        }
        if ($Expiration) {
            $ExpirationTime = $Detected.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.000Z")
            $Feed.feed.record[0].expiration = "$($ExpirationTime)"
        }
        if ($ThreatLevel) {
            $Feed.feed.record[0].threat_level = "$($ThreatLevel)"
        }
        if ($Target) {
            $Feed.feed.record[0].target = "$($Target)"
        }
        if ($TLD) {
            $Feed.feed.record[0].tld = "$($TLD)"
        }

        $JSONFeed = $Feed | ConvertTo-Json -Depth 5

        Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/tide/api/data/batches?profile=$($Profile)" -Data $JSONFeed
      }
    }
}