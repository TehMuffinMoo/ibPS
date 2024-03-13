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
        
    .FUNCTIONALITY
        BloxOneDDI
        
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName = 'None')]
    Param(
        [Parameter(Mandatory=$true)]
        [String]$Profile,
        [Parameter(Mandatory=$true)]
        [ValidateSet('host','ip','url','email','hash')]
        [String]$RecordType,
        [Parameter(Mandatory=$true)]
        [String]$RecordValue,
        [Parameter(Mandatory=$false)]
        [String]$external_id,
        [Parameter(Mandatory=$true)]
        [datetime]$Detected,
        [Parameter(Mandatory=$true,ParameterSetName="Class")]
        [String]$ThreatClass,
        [Parameter(Mandatory=$true,ParameterSetName="Property")]
        [String]$ThreatProperty,
        [Parameter(Mandatory=$false)]
        [ValidateRange(1, 100)]
        [int]$Confidence,
        [Parameter(Mandatory=$false)]
        [String]$Domain,
        [Parameter(Mandatory=$false)]
        [String]$Duration,
        [Parameter(Mandatory=$false)]
        [String]$Expiration,
        [ValidateRange(1, 100)]
        [Parameter(Mandatory=$false)]
        [String]$ThreatLevel,
        [Parameter(Mandatory=$false)]
        [String]$Target,
        [Parameter(Mandatory=$false)]
        [String]$TLD
	  )

    Process {
      $Detected = $Detected.ToUniversalTime()
      $DetectedTime = $Detected.ToString("yyyy-MM-ddTHH:mm:ssZ")
      
      $Feed = @{
        "Feed" = @{
          "profile" = "$($Profile)"
          "record_type" = "$($RecordType)"
          "record" = @{
            "$($RecordType)" = "$($RecordValue)"
            "property" = "$($ThreatProperty)"
            "detected" = "$($DetectedTime)"
          }
        }
      }
      $Feed | ConvertTo-Json
    }
}