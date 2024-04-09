function Query-NIOS {
    [Alias("Invoke-NIOS")]
    <#
    .SYNOPSIS
        Queries a NIOS Grid Manager via Infoblox WAPI

    .DESCRIPTION
        This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs.

    .PARAMETER Method
        Specify the HTTP Method to use

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

        This parameter can be ommitted if the Server is stored by using Set-NIOSConfiguration

    .PARAMETER Uri
        Specify the Uri, such as "ipam/record", you can also use the full URL and http parameters must be appended here.

    .PARAMETER ApiVersion
        The version of the NIOS API to use (WAPI)

        This parameter can be ommitted if the API Version is stored by using Set-NIOSConfiguration

    .PARAMETER Creds
        The creds parameter can be used to specify credentials as part of the command.

        This parameter can be ommitted if the Credentials are stored by using Set-NIOSCredentials

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
    if (!($script:WebSession)) {
        $script:WebSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession -Property @{Credentials=$Creds}
    }

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
            
        $Splat = @{
            Method = $Method
            Uri = $Uri
            Headers = $NIOSHeaders
            WebSession = $script:WebSession
        }
        if ($SkipCertificateCheck -and ($PSVersionTable.PSVersion.ToString() -gt 7)) {
            $Splat | Add-Member -MemberType NoteProperty -Name 'SkipCertificateCheck' -Value $SkipCertificateCheck
        }
        switch ($Method) {
            'GET' { 
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
            if ($Result.result -and -not $Result.results) {
                $Result | Add-Member -MemberType NoteProperty -Name "results" -Value $Result.result
            }
            return $Result
        } elseif ($ErrorOnEmpty) {
            Write-Host "Error. No results from API."
        }
    }
}