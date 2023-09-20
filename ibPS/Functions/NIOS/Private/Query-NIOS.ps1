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

    .Example
        Query-CSP -Method GET -Uri "zone_delegated?return_as_object=1"

    .FUNCTIONALITY
        NIOS
        Core
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [String]$Method,
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [String]$Uri,
      [String]$ApiVersion = "2.12",
      $Creds,
      [String]$Data
    )

    if (!($Creds)) {
        $Creds = Get-NIOSCredentials
    }

    $ErrorOnEmpty = $true
    $WebSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession -Property @{Credentials=$Creds}

    ## Set Headers
    $NIOSHeaders = @{
        'Content-Type' = 'application/json'
    }

    ## Build URL
    $Uri = "https://$Server/wapi/v$ApiVersion/"+$Uri

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

    if ($Result) {
        if ($Result.result -and -not $Result.results) {
            $Result | Add-Member -MemberType NoteProperty -Name "results" -Value $Result.result
        }
        return $Result
    } elseif ($ErrorOnEmpty) {
        Write-Host "Error. No results from API."
    }
}