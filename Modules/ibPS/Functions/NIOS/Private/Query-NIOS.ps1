function Query-NIOS {
    <#
    .SYNOPSIS
        Queries a NIOS Grid Manager via Infoblox WAPI

    .DESCRIPTION
        This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs.

    .PARAMETER Method
        Specify the HTTP Method to use

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

    .PARAMETER Uri
        Specify the Uri, such as "ipam/record", you can also use the full URL and http parameters must be appended here.

    .PARAMETER ApiVersion
        The version of the NIOS API to use (WAPI)

    .PARAMETER Data
        Data to be submitted on POST/PUT/PATCH/DELETE requests

    .PARAMETER SkipCertificateCheck
        If this parameter is set, SSL Certificates Checks will be ignored

    .EXAMPLE
        Query-NIOS -Method GET -Uri "zone_delegated?return_as_object=1"

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [String]$Method,
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [String]$Uri,
      [String]$ApiVersion,
      [PSCredential]$Creds,
      [String]$Data,
      [Switch]$SkipCertificateCheck
    )
    $NIOSConfig = Get-NIOSConfiguration
    if (!($Creds)) {
        $Creds = Get-NIOSCredentials
    }
    if (!($Server)) {
        if ($NIOSConfig.Server) {
            $Server = $NIOSConfig.Server
        } else {
            Write-Error "Error. NIOS Server not specified. Either use the -Server parameter or Set-NIOSConfiguration -Server `"gm.mydomain.corp`""
        }
    }
    if (!($ApiVersion)) {
        if ($NIOSConfig.APIVersion) {
            $ApiVersion = $NIOSConfig.APIVersion
        } else {
            Write-Error "Error. NIOS WAPI Version not specified. Either use the -ApiVersion parameter or Set-NIOSConfiguration -APIVersion `"2.13`""
        }
    }

    $ErrorOnEmpty = $true
    $WebSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession -Property @{Credentials=$Creds}

    ## Set Headers
    $NIOSHeaders = @{
        'Content-Type' = 'application/json'
    }

    if ($SkipCertificateCheck) {
      if ($PSVersionTable.PSVersion.ToString() -lt 7) {
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
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
      }
    }

    if ($Server -and $ApiVersion) {

        ## Build URL
        $Uri = "https://$Server/wapi/v$ApiVersion/"+$Uri
            
        if ($PSVersionTable.PSVersion.ToString() -lt 7) {
            switch ($Method) {
                'GET' { 
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -WebSession $WebSession
                }
                'POST' {
                    if (!($Data)) {
                        Write-Host "Error. Data parameter not set."
                        break
                    }
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
                }
                'PUT' {
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
                }
                'PATCH' {
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
                }
                'DELETE' {
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession
                    $ErrorOnEmpty = $false
                }
                default {
                    Write-Host "Error. Invalid Method: $Method. Accepted request types are GET, POST, PUT, PATCH & DELETE"
                }
            }
        } elseif ($PSVersionTable.PSVersion.ToString() -gt 7) {
            switch ($Method) {
                'GET' { 
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -WebSession $WebSession -SkipCertificateCheck:$SkipCertificateCheck
                }
                'POST' {
                    if (!($Data)) {
                        Write-Host "Error. Data parameter not set."
                        break
                    }
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession -SkipCertificateCheck:$SkipCertificateCheck
                }
                'PUT' {
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession -SkipCertificateCheck:$SkipCertificateCheck
                }
                'PATCH' {
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession -SkipCertificateCheck:$SkipCertificateCheck
                }
                'DELETE' {
                    $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $NIOSHeaders -Body $Data -WebSession $WebSession -SkipCertificateCheck:$SkipCertificateCheck
                    $ErrorOnEmpty = $false
                }
                default {
                    Write-Host "Error. Invalid Method: $Method. Accepted request types are GET, POST, PUT, PATCH & DELETE"
                }
            }
        }
        if ($Result) {
            if ($Result.result -and -not $Result.results) {
                $Result | Add-Member -MemberType NoteProperty -Name "results" -Value $Result.result
            }
            return $Result
        } elseif ($ErrorOnEmpty) {
            Write-Host "Error. No results from API."
        }
    }
}