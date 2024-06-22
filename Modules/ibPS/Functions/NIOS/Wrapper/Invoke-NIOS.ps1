function Invoke-NIOS {
    <#
    .SYNOPSIS
        Queries a NIOS Grid Manager via Infoblox WAPI or the BloxOne CSP via NIOS Federation

    .DESCRIPTION
        This is a core function used by all NIOS cmdlets when querying an Infoblox NIOS Grid Manager, required when interacting with the NIOS APIs locally or via BloxOne CSP via NIOS Federation.

    .PARAMETER Method
        Specify the HTTP Method to use

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

        This parameter can be ommitted if the Server is stored by using Set-NIOSConfiguration

        This is used only when connecting to NIOS directly.

    .PARAMETER GridUID
        Specify the NIOS Grid UID (license_uid). This indicates which Grid to connect to when using NIOS Federation within BloxOne.

    .PARAMETER GridName
        Specify the NIOS Grid Name in BloxOne DDI instead of the GridUID. This is convient, but requires resolving the license_uid on every API Call.

    .PARAMETER Uri
        Specify the Uri, such as "record:a", you can also use the full URL and http parameters must be appended here.

    .PARAMETER ApiVersion
        The version of the NIOS API to use (WAPI)

        This parameter can be ommitted if the API Version is stored by using Set-NIOSConfiguration

    .PARAMETER Creds
        The creds parameter can be used to specify credentials as part of the command.

        This parameter can be ommitted if the Credentials are stored by using Set-NIOSCredentials

        This is used only when connecting to NIOS directly.

    .PARAMETER Data
        Data to be submitted on POST/PUT/PATCH/DELETE requests

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
      [Parameter(ParameterSetName='Local')]
      [String]$Server,
      [Parameter(Mandatory=$true,ParameterSetName='FederatedUID')]
      [String]$GridUID,
      [Parameter(Mandatory=$true,ParameterSetName='FederatedName')]
      [String]$GridName,
      [Parameter(Mandatory=$true)]
      [String]$Uri,
      [String]$ApiVersion,
      [Parameter(ParameterSetName='Local')]
      [PSCredential]$Creds,
      [String]$Data,
      [Parameter(ParameterSetName='Local')]
      [Switch]$SkipCertificateCheck
    )

    $NIOSConfig = Get-NIOSConfiguration

    ## Set Headers
    $Headers = @{
        'Content-Type' = 'application/json'
    }

    if (!($ApiVersion)) {
        if ($NIOSConfig.APIVersion) {
            $ApiVersion = $NIOSConfig.APIVersion
        } else {
            Write-Error "Error. NIOS WAPI Version not specified. Either use the -ApiVersion parameter or Set-NIOSConfiguration -APIVersion `"2.13`""
        }
    }

    Switch($PSCmdlet.ParameterSetName) {
        'Local' {
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
            $ErrorOnEmpty = $true
            if (!($script:WebSession)) {
                $script:WebSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession -Property @{Credentials=$Creds}
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

            $WAPIBase = "https://$Server/wapi/v$ApiVersion"
        }
        'FederatedUID' {
            $Headers.Authorization = "Token $(Get-B1CSPAPIKey)"
            $Headers.license_uid = $($GridUID)
            [Uri]$CSP = Get-B1CSPUrl
            $WAPIBase = "https://wapi.$($CSP.DnsSafeHost)/wapi/v$ApiVersion"
        }
        'FederatedName' {
            $Headers.Authorization = "Token $(Get-B1CSPAPIKey)"
            $GridUID = (Get-B1Host -Name $GridName -Strict).tags.'host/license_uid'
            $Headers.license_uid = $($GridUID)
            [Uri]$CSP = Get-B1CSPUrl
            $WAPIBase = "https://wapi.$($CSP.DnsSafeHost)/wapi/v$ApiVersion"
        }
    }
    
    $Splat = @{
        Method = $Method
        Uri = "$WAPIBase/$Uri"
        Headers = $Headers
    }
    if ($script:WebSession) {
        $Splat.WebSession = $script:WebSession
    }
    if ($SkipCertificateCheck -and ($PSVersionTable.PSVersion.ToString() -gt 7)) {
        $Splat.SkipCertificateCheck = $SkipCertificateCheck
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