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

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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
        $HeaderRegexes = @(
            @{
                'header' = 'X-Some-Header'
                'regex' = '(.*)'
            }
            @{
                'header' = 'X-Another-Header'
                'regex' = '(.*)'
            }
        )
        New-B1DTCHealthCheck -Name 'Exchange HTTPS Check' -Type HTTP -UseHTTPS -Port 443 `
                             -HTTPRequest "GET /owa/auth/logon.aspx HTTP/1.1`nHost: webmail.company.corp" `
                             -ResponseBody Found -ResponseBodyRegex '(.*)' `
                             -ResponseHeader Found -ResponseHeaderRegexes $HeaderRegexes

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
        codes                          :
        metadata                       :
        check_response_body            : True
        check_response_body_regex      : (.*)
        check_response_body_negative   : False
        check_response_header          : True
        check_response_header_regexes  : {@{header=X-Some-Header; regex=(.*)}, @{header=X-Another-Header; regex=(.*)}}
        check_response_header_negative : False

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
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
      [ValidateSet("Enabled","Disabled")]
      [String]$State = 'Enabled',
      [System.Object]$Tags,
      [Switch]$Force
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

            $responseBodyAttribute = New-Object System.Management.Automation.ParameterAttribute
            $responseBodyAttribute.Position = 8
            $responseBodyAttribute.HelpMessage = "The -ResponseBody parameter is used to indicate if to check the body response content. This should be used in combination with -ResponseBodyRegex"
            $responseBodyAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $responseBodyValidateSet = New-Object System.Management.Automation.ValidateSetAttribute('Found','NotFound','None')
            $responseBodyAttributeCollection.Add($responseBodyAttribute)
            $responseBodyAttributeCollection.add($responseBodyValidateSet)
            $responseBodyParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ResponseBody', [String], $responseBodyAttributeCollection)

            $responseBodyRegexAttribute = New-Object System.Management.Automation.ParameterAttribute
            $responseBodyRegexAttribute.Position = 8
            $responseBodyRegexAttribute.HelpMessage = "The -ResponseBodyRegex parameter is used to specify the regex used when checking the body of the response"
            $responseBodyRegexAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $responseBodyRegexAttributeCollection.Add($responseBodyRegexAttribute)
            $responseBodyRegexParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ResponseBodyRegex', [String], $responseBodyRegexAttributeCollection)

            $responseHeaderAttribute = New-Object System.Management.Automation.ParameterAttribute
            $responseHeaderAttribute.Position = 8
            $responseHeaderAttribute.HelpMessage = "The -ResponseHeader parameter is used to indicate if to check the header response content. This should be used in combination with -ResponseHeaderRegex"
            $responseHeaderAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $responseHeaderValidateSet = New-Object System.Management.Automation.ValidateSetAttribute('Found','NotFound','None')
            $responseHeaderAttributeCollection.Add($responseHeaderAttribute)
            $responseHeaderAttributeCollection.add($responseHeaderValidateSet)
            $responseHeaderParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ResponseHeader', [String], $responseHeaderAttributeCollection)

            $responseHeaderRegexAttribute = New-Object System.Management.Automation.ParameterAttribute
            $responseHeaderRegexAttribute.Position = 8
            $responseHeaderRegexAttribute.HelpMessage = "The -ResponseHeaderRegex parameter is used to a list of regular expressions, used when checking specific response headers."
            $responseHeaderRegexAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
            $responseHeaderRegexAttributeCollection.Add($responseHeaderRegexAttribute)
            $responseHeaderRegexParam = New-Object System.Management.Automation.RuntimeDefinedParameter('ResponseHeaderRegexes', [System.Object], $responseHeaderRegexAttributeCollection)

            $paramDictionary.Add('UseHTTPS', $useHTTPSParam)
            $paramDictionary.Add('HTTPRequest', $httpRequestParam)
            $paramDictionary.Add('StatusCodes', $statusCodesParam)
            $paramDictionary.Add('ResponseBody', $responseBodyParam)
            $paramDictionary.Add('ResponseBodyRegex', $responseBodyRegexParam)
            $paramDictionary.Add('ResponseHeader', $responseHeaderParam)
            $paramDictionary.Add('ResponseHeaderRegexes', $responseHeaderRegexParam)
       }
       return $paramDictionary
   }

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
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

            Switch ($PSBoundParameters['ResponseBody']) {
                "Found" {
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body' -Value $true
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body_negative' -Value $false
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body_regex' -Value $(if ($PSBoundParameters['ResponseBodyRegex']) { $PSBoundParameters['ResponseBodyRegex'] } else { Write-Error 'No regular expression entered for checking HTTP Response Body. You must use -ResponseBodyRegex when specifying -ResponseBody'; return $null })
                }
                "NotFound" {
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body' -Value $true
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body_negative' -Value $true
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body_regex' -Value $(if ($PSBoundParameters['ResponseBodyRegex']) { $PSBoundParameters['ResponseBodyRegex'] } else { Write-Error 'No regular expression entered for checking HTTP Response Body. You must use -ResponseBodyRegex when specifying -ResponseBody'; return $null })
                }
                "None" {
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body' -Value $false
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body_negative' -Value $false
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_body_regex' -Value $null
                }
                default {
                    $null
                }
            }

            Switch ($PSBoundParameters['ResponseHeader']) {
                "Found" {
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header' -Value $true
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header_negative' -Value $false
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header_regexes' -Value @($(if ($PSBoundParameters['ResponseHeaderRegexes']) { $PSBoundParameters['ResponseHeaderRegexes'] } else { Write-Error 'No regular expression entered for checking HTTP Response Header(s). You must use -ResponseHeaderRegex when specifying -ResponseHeader'; return $null }))
                }
                "NotFound" {
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header' -Value $true
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header_negative' -Value $true
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header_regexes' -Value @($(if ($PSBoundParameters['ResponseHeaderRegexes']) { $PSBoundParameters['ResponseHeaderRegexes'] } else { Write-Error 'No regular expression entered for checking HTTP Response Header(s). You must use -ResponseHeaderRegex when specifying -ResponseHeader'; return $null }))
                }
                "None" {
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header' -Value $false
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header_negative' -Value $false
                    $splat | Add-Member -MemberType NoteProperty -Name 'check_response_header_regexes' -Value $null

                }
                default {
                    $null
                }
            }
        }

        $JSON = $splat | ConvertTo-Json -Depth 5
        if($PSCmdlet.ShouldProcess("Create new DTC Health Check:`n$($JSON)","Create new DTC Health Check: $($Name)",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/health_check_$($Type.ToLower())" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}