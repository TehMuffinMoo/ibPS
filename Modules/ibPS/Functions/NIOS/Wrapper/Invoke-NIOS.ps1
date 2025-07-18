﻿function Invoke-NIOS {
    <#
    .SYNOPSIS
        Queries a NIOS Grid Manager via Infoblox WAPI or the Universal DDI CSP via NIOS Federation

    .DESCRIPTION
        This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs locally or via Universal DDI CSP via NIOS Federation.

    .PARAMETER Method
        Specify the HTTP Method to use. (Default,Get,Head,Post,Put,Delete,Trace,Options,Merge,Patch)

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

        This parameter can be ommitted if the Server is stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER GridUID
        Specify the NIOS Grid UID (license_uid). This indicates which Grid to connect to when using NIOS Federation within Universal DDI.

    .PARAMETER GridName
        Specify the NIOS Grid Name in Universal DDI instead of the GridUID. This is convient, but requires resolving the license_uid on every API Call.

    .PARAMETER Uri
        Specify the Uri, such as "record:a", you can also use the full URL and http parameters must be appended here.

    .PARAMETER ApiVersion
        The version of the NIOS API to use (WAPI)

        This parameter can be ommitted if the API Version is stored by using Set-NIOSConnectionProfile

    .PARAMETER Creds
        The creds parameter can be used to specify credentials as part of the command.

        This parameter can be ommitted if the Credentials are stored by using New-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER Data
        Data to be submitted on POST/PUT/PATCH/DELETE requests

    .PARAMETER OutFile
        The file path to save downloaded files to.

    .PARAMETER AdditionalHeaders
        This parameter can be used to pass additional headers, or override the Content-Type header (defaults to application/json).

    .PARAMETER SkipCertificateCheck
        If this parameter is set, SSL Certificates Checks will be ignored

        This is used only when connecting to NIOS directly.

    .EXAMPLE
        Invoke-NIOS -Uri "zone_delegated?return_as_object=1"

    .EXAMPLE
        Invoke-NIOS -Uri "record:a?return_as_object=1" -GridUID 'afjs8fje89hf4fjwsbf9sdvgreg4r'

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core
    #>
    param(
      [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',
      [Parameter(Mandatory=$true,ParameterSetName='Local')]
      [String]$Server,
      [Parameter(Mandatory=$true,ParameterSetName='FederatedUID')]
      [String]$GridUID,
      [Parameter(Mandatory=$true,ParameterSetName='FederatedName')]
      [String]$GridName,
      [Parameter(Mandatory=$true)]
      [String]$Uri,
      [Parameter(Mandatory=$true)]
      [String]$ApiVersion,
      [Parameter(Mandatory=$true,ParameterSetName='Local')]
      [Alias('Credentials')]
      [PSCredential]$Creds,
      [String]$Data,
      [String]$OutFile,
      [Parameter(ParameterSetName='Local')]
      [Switch]$SkipCertificateCheck,
      [System.Object]$AdditionalHeaders
    )

    if ($AdditionalHeaders) {
        $Headers = @{}
        $Headers += $AdditionalHeaders
        if (!($Headers.'Content-Type')) {
            $Headers += @{
                'Content-Type' = 'application/json; charset=utf-8'
            }
        }
    } else {
        $Headers = @{
            'Content-Type' = 'application/json; charset=utf-8'
        }
    }

    Switch($PSCmdlet.ParameterSetName) {
        'Local' {
            ## Establish Websession & Cache it
            if (!(Get-NIOSWebSession -Server $Server -Creds $Creds)) {
                Set-NIOSWebSession -Server $($Server) -Creds $($Creds) -WebSession (New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession -Property @{Credentials=$Creds})
            }
            $WebSession = Get-NIOSWebSession -Server $Server -Creds $Creds

            if ($SkipCertificateCheck) {
                if ($PSVersionTable.PSVersion.ToString() -lt 7) {
                  if (-not ([System.Management.Automation.PSTypeName]'CertValidation').Type) {
                    add-type @"
                        using System.Net;
                        using System.Security.Cryptography.X509Certificates;
                        public class TrustAllCertsPolicy : ICertificatePolicy {
                            public bool CheckValidationResult(
                                ServicePoint srvPoint, X509Certificate certificate,
                                WebRequest request, int certificateProblem) {
                                return true;
                            }
                        }
"@
                  }
                  [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                }
            }

            $WAPIBase = "https://$Server/wapi/v$ApiVersion"
        }
        'FederatedUID' {
            $Headers.Authorization = "Token $(Get-B1CSPAPIKey -DefaultProfile)"
            $Headers.license_uid = $($GridUID)
            [Uri]$CSP = Get-B1CSPUrl
            $WAPIBase = "https://wapi.$($CSP.DnsSafeHost)/wapi/v$ApiVersion"
        }
        'FederatedName' {
            $Headers.Authorization = "Token $(Get-B1CSPAPIKey -DefaultProfile)"
            $GridUID = (Get-B1Host -Name $GridName -Strict).tags.'host/license_uid'
            $Headers.license_uid = $($GridUID)
            [Uri]$CSP = Get-B1CSPUrl
            $WAPIBase = "https://wapi.$($CSP.DnsSafeHost)/wapi/v$ApiVersion"
        }
    }

    ## Allow full API or only endpoint to be specified.
    ##  Default to WAPI endpoint
    if ($Uri -like "http*/*/*") {
        $FullUri = $Uri
    } else {
        $FullUri = "$WAPIBase/$Uri"
    }

    $Splat = @{
        Method = $Method
        Uri = $FullUri
        Headers = $Headers
    }

    if ($WebSession) {
        $Splat.WebSession = $WebSession
    }

    if ($SkipCertificateCheck -and ($PSVersionTable.PSVersion.ToString() -gt 7)) {
        $Splat.SkipCertificateCheck = $SkipCertificateCheck
    }

    if ($OutFile) {
        $Splat.OutFile = $OutFile
    }

    Write-DebugMsg -URI "$($Method): $($Splat.Uri)" -Body $Data
    switch ($Method) {
        'GET' {
            if ($Data -ne $null) {
                $Splat.body = $Data
            }
            $Result = Invoke-RestMethod @Splat
        }
        'POST' {
            if (!($Data)) {
                Write-Host "Error. Data parameter not set."
                break
            }
            $Result = Invoke-RestMethod @Splat -Body $Data
        }
        'PUT' {
            $Result = Invoke-RestMethod @Splat -Body $Data
        }
        'PATCH' {
            $Result = Invoke-RestMethod @Splat -Body $Data
        }
        'DELETE' {
            $Result = Invoke-RestMethod @Splat -Body $Data
            $ErrorOnEmpty = $false
        }
        default {
            Write-Host "Error. Invalid Method: $Method. Accepted request types are GET, POST, PUT, PATCH & DELETE"
        }
    }
    if ($Result) {
        return $Result
    } elseif ($ErrorOnEmpty) {
        Write-Host "Error. No results from API."
    }
}