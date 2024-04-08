function Query-CSP {
    <#
    .SYNOPSIS
        Queries the BloxOneDDI Cloud Services Portal

    .DESCRIPTION
        This is a core function used by all cmdlets when querying the CSP (Cloud Services Portal), required when interacting with the BloxOne APIs.

    .PARAMETER Method
        Specify the HTTP Method to use

    .PARAMETER Uri
        Specify the Uri, such as "ipam/record", you can also use the full URL and http parameters must be appended here.

    .PARAMETER Data
        Data to be submitted on POST/PUT/PATCH/DELETE requests

    .PARAMETER InFile
        File path of data to submit as part of POST request

    .EXAMPLE
        Query-CSP -Method GET -Uri "ipam/subnet?_filter=address==`"10.10.10.10`""

    .EXAMPLE
        Query-CSP -Method DELETE -Uri "dns/record/abc16def-a125-423a-3a42-dcv6f6c4dj8x"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("GET","POST","PUT", "PATCH", "DELETE")]
      [String]$Method,
      [Parameter(Mandatory=$true)]
      [String]$Uri,
      [String]$Data,
      [String]$InFile,
      [String]$ContentType = 'application/json'
    )

    ## Get Stored API Key
    $B1ApiKey = Get-B1CSPAPIKey

    ## Get Saved CSP URL
    $B1CSPUrl = Get-B1CSPUrl

    ## Set Headers
    $CSPHeaders = @{
        'Authorization' = "Token $B1ApiKey"
        'Content-Type' = $ContentType
    }

    $ErrorOnEmpty = $true

    ## Allow full API or only endpoint to be specified.
    if ($Uri -notlike "$B1CSPUrl/*") {
        $Uri = "$B1CSPUrl/api/ddi/v1/"+$Uri
    }
    $Uri = $Uri -replace "\*","``*"
    if ($ENV:IBPSDebug -eq "Enabled") {$Uri}

    $splat = @{
        "Method" = $Method
        "Uri" = $Uri
        "Headers" = $CSPHeaders
    }
    if ($PSVersionTable.PSVersion -gt "7.0.0") {
      $splat += @{
        "SkipHttpErrorCheck" = $true
        "StatusCodeVariable" = 'StatusCode'
      }
    }

    #try {
      Write-DebugMsg -URI $Uri -Body $Data
      switch ($Method) {
        'GET' {
            $Result = Invoke-RestMethod @splat
        }
        'POST' {
            if ($Data -and $InFile) {
                Write-Error "Error. -Data and -InFile are mutually exclusive parameters."
                break
            }
            if ($InFile) {
                $Result = Invoke-RestMethod @splat -InFile $InFile
            } else {
                $Result = Invoke-RestMethod @splat -Body $Data
            }
        }
        'PUT' {
            $Result = Invoke-RestMethod @splat -Body $Data
        }
        'PATCH' {
            $Result = Invoke-RestMethod @splat -Body $Data
        }
        'DELETE' {
            $Result = Invoke-RestMethod @splat -Body $Data
            $ErrorOnEmpty = $false
        }
        default {
            Write-Error "Error. Invalid Method: $Method. Accepted request types are GET, POST, PUT, PATCH & DELETE"
        }
      }
      if ($Result) {
        if ($Result.error -ne $null) {
            switch ($StatusCode) {
                401 {
                    Write-Error "Authorization required, please store/update your BloxOne API Key using Set-B1CSPAPIKey"
                }
                429 {
                    Write-Error "API Request Limit Reached. Use the -Limit and -Offset parameters or make your search more specific."
                }
                501 {
                    Write-Error "API Endpoint and/or Method are not supported. Please check syntax and try again."
                }
            }
        } else {
            return $Result
        }
      } elseif ($ErrorOnEmpty) {
        Write-Host "Error. No results from API."
      }
    #} catch {
    #    Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
    #    Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    #    if ($PSVersionTable.PSVersion -lt "7.0.0") {
    #        $reader = New-Object System.IO.StreamReader($result)
    #        $reader.BaseStream.Position = 0
    #        $reader.DiscardBufferedData()
    #        $reader.ReadToEnd();
    #    }
    #}
}