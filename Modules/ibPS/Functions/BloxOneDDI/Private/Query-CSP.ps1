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

    .Example
        Query-CSP -Method GET -Uri "ipam/subnet?_filter=address==`"10.10.10.10`""

    .Example
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
      [String]$InFile
    )

    ## Get Stored API Key
    $B1ApiKey = Get-B1CSPAPIKey

    ## Get Saved CSP URL
    $B1CSPUrl = Get-B1CSPUrl

    ## Set Headers
    $CSPHeaders = @{
        'Authorization' = "Token $B1ApiKey"
        'Content-Type' = 'application/json'
    }

    $ErrorOnEmpty = $true

    ## Allow full API or only endpoint to be specified.
    if ($Uri -notlike "$B1CSPUrl/*") {
        $Uri = "$B1CSPUrl/api/ddi/v1/"+$Uri
    }
    $Uri = $Uri -replace "\*","``*"
    if ($Debug) {$Uri}

   # try {
      switch ($Method) {
        'GET' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders
        }
        'POST' {
            if ($Data -and $InFile) {
                Write-Host "Error. -Data and -InFile are mutually exclusive parameters."
                break
            }
            if ($InFile) {
                $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -InFile $InFile
            } else {
                $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
            }
        }
        'PUT' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
        }
        'PATCH' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
        }
        'DELETE' {
            $Result = Invoke-RestMethod -Method $Method -Uri $Uri -Headers $CSPHeaders -Body $Data
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
   # } catch {
   #   switch ($_.Exception.Response.StatusCode) {
   #     429 {
   #       Write-Error "Too many requests. Please refine your query and try again to avoid rate limiting."
   #     }
   #     401 {
   #       Write-Error "Authorization required, please store/update your BloxOne API Key using Store-B1CSPAPIKey"
   #     }
   #     default {
   #       return $_.Exception.Response
   #     }
   #   }
   # }
}