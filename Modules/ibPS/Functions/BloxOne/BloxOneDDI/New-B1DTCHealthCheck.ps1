function New-B1DTCHealthCheck {
    <#
    .SYNOPSIS
        Creates a new health check object within BloxOne DTC

    .DESCRIPTION
        This function is used to create a new health check object within BloxOne DTC
    
    .PARAMETER Name
        The name of the DTC health check object to create

    .PARAMETER Description
        The description for the new health check object

    .PARAMETER Type
        The type of Health Check to create (TCP/ICMP/HTTP(s))

    .PARAMETER Interval
        The frequency in seconds in which the health check is performed. Defaults to 15s

    .PARAMETER Timeout
        The number of seconds before the health check times out. Defaults to 10s

    .PARAMETER RetryUp
        How many retry attempts before reporting a Healthy status. Defaults to 1

    .PARAMETER RetryDown
        How many retry attempts before reporting a Down status. Defaults to 1

    .PARAMETER State
        Whether or not the new health check is created as enabled or disabled. Defaults to enabled

    .PARAMETER Tags
        Any tags you want to apply to the DTC health check

    .EXAMPLE
        PS> New-B1DTCHealthCheck -Name 'Exchange HTTPS Check' -Type HTTP -UseHTTPS -Port 443 -HTTPRequest "GET /owa/auth/logon.aspx HTTP/1.1`nHost: webmail.company.corp"

        id                             : dtc/health_check_http/0fsdfef-34fg-dfvr-9dxf-svev4vgv21d9
        name                           : Exchange HTTPS Check
        comment                        : 
        disabled                       : False
        interval                       : 15
        timeout                        : 10
        retry_up                       : 1
        retry_down                     : 1
        tags                           : 
        port                           : 443
        https                          : True
        request                        : GET /owa/auth/logon.aspx HTTP/1.1
                                        Host: webmail.company.corp
        codes                          : 200,401
        metadata                       : 

    .EXAMPLE
       PS> 
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [ValidateSet('TCP','ICMP','HTTP')]
      [Parameter(Mandatory=$true)]
      [String]$Type,
      [Int]$Interval = 15,
      [Int]$Timeout = 10,
      [Int]$RetryUp = 1,
      [Int]$RetryDown = 1,
      [String]$State = 'Enabled',
      [System.Object]$Tags
    )

    DynamicParam {
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        if ($Type -eq "TCP" -or $Type -eq "HTTP") {
             $portAttribute = New-Object System.Management.Automation.ParameterAttribute
             $portAttribute.Position = 4
             $portAttribute.Mandatory = $true
             $portAttribute.HelpMessage = "The -Port parameter is required when creating a $($Type) Health Check."

             $portAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $portAttributeCollection.Add($portAttribute)

             $portParam = New-Object System.Management.Automation.RuntimeDefinedParameter('Port', [String], $portAttributeCollection)

             $paramDictionary.Add('Port', $portParam)
       }
       if ($Type -eq "HTTP") {
            $useHTTPSAttribute = New-Object System.Management.Automation.ParameterAttribute
            $useHTTPSAttribute.Position = 5
            $useHTTPSAttribute.HelpMessage = "The -UseHTTPS parameter is used to create a HTTPS Health Check, instead of HTTP."
            $useHTTPSAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $useHTTPSAttributeCollection.Add($useHTTPSAttribute)
            $useHTTPSParam = New-Object System.Management.Automation.RuntimeDefinedParameter('UseHTTPS', [Switch], $useHTTPSAttributeCollection)

            $httpRequestAttribute = New-Object System.Management.Automation.ParameterAttribute
            $httpRequestAttribute.Position = 6
            $httpRequestAttribute.Mandatory = $true
            $httpRequestAttribute.HelpMessage = "The -HTTPRequest parameter is used to specify the HTTP Request to make during the health check."
            $httpRequestAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $httpRequestAttributeCollection.Add($httpRequestAttribute)
            $httpRequestParam = New-Object System.Management.Automation.RuntimeDefinedParameter('HTTPRequest', [String], $httpRequestAttributeCollection)

            $statusCodesAttribute = New-Object System.Management.Automation.ParameterAttribute
            $statusCodesAttribute.Position = 7
            $statusCodesAttribute.HelpMessage = "The -StatusCodes parameter is used to specify the status codes to identify healthy status. This could be `"Any`" or a list of Status Codes"
            $statusCodesAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $statusCodesAttributeCollection.Add($statusCodesAttribute)
            $statusCodesParam = New-Object System.Management.Automation.RuntimeDefinedParameter('StatusCodes', [System.Object], $statusCodesAttributeCollection)

            $paramDictionary.Add('UseHTTPS', $useHTTPSParam)
            $paramDictionary.Add('HTTPRequest', $httpRequestParam)
            $paramDictionary.Add('StatusCodes', $statusCodesParam)
       }
       return $paramDictionary
   }

    process {
        $splat = @{
            "name" = $Name
            "comment" = $Description
            "disabled" = $(if ($State -eq 'Enabled') { $false } else { $true })
            "interval" = $Interval
            "timeout" = $Timeout
            "retry_up" = $RetryUp
            "retry_down" = $RetryDown
            "tags" = $Tags
        }

        if ($Type -eq "TCP" -or $Type -eq "HTTP") {
            $splat | Add-Member -MemberType NoteProperty -Name 'port' -Value $PSBoundParameters['Port']
        }
        if ($Type -eq "HTTP") {
            $splat | Add-Member -MemberType NoteProperty -Name 'https' -Value $(if ($PSBoundParameters['UseHTTPS']) { $true } else { $false })
            $splat | Add-Member -MemberType NoteProperty -Name 'request' -Value $(if ($PSBoundParameters['HTTPRequest']) { $PSBoundParameters['HTTPRequest'] } else { $null })
            $splat | Add-Member -MemberType NoteProperty -Name 'codes' -Value $(if ($PSBoundParameters['StatusCodes']) { ($PSBoundParameters['StatusCodes']) -join ',' } else { $null })
        }

        $JSON = $splat | ConvertTo-Json -Depth 5

        $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/health_check_$($Type.ToLower())" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}