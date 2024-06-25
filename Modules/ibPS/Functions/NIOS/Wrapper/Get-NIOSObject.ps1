function Get-NIOSObject {
    <#
    .SYNOPSIS
        Generic Wrapper function for retrieving objects from the NIOS WAPI

    .DESCRIPTION
        Generic Wrapper function for retrieving objects from the NIOS WAPI, either directly or via BloxOne Federation

    .PARAMETER ObjectType
        Specify the object type to retrieve. This field supports tab completion.

    .PARAMETER ObjectRef
        Specify the object _ref to retrieve.

    .PARAMETER Limit
        Specify the number of results to return. The default limit is 1000. If a limit higher than 1000 is specified, this will enable paging of results.

    .PARAMETER PageSize
        Specify the results page size when paging is enabled.

    .PARAMETER Filters
        Specify a list of filters to use, this must be one of;

             [string]      'network_view=default'
             [string[]]    'network_view=default','network=10.10.10.0/24'
             [Hashtable] @{ 'network_view~'='default' }

    .PARAMETER Fields
        A string array of fields to return in the response. This field supports tab completion.

    .PARAMETER BaseFields
        Using the -BaseFields switch will return the base fields in addition to those selected in -Fields.

    .PARAMETER AllFields
        Using the -AllFields switch will return all available fields in the response.

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

        This parameter can be ommitted if the Server is stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER GridUID
        Specify the NIOS Grid UID (license_uid). This indicates which Grid to connect to when using NIOS Federation within BloxOne.

    .PARAMETER GridName
        Specify the NIOS Grid Name in BloxOne DDI instead of the GridUID. This is convient, but requires resolving the license_uid on every API Call.

        This parameter can be ommitted if the Federated Grid has been stored by using Set-NIOSConnectionProfile

    .PARAMETER ApiVersion
        The version of the NIOS API to use (WAPI)

        This parameter can be ommitted if the API Version is stored by using Set-NIOSConnectionProfile

    .PARAMETER Creds
        The creds parameter can be used to specify credentials as part of the command.

        This parameter can be ommitted if the Credentials are stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER SkipCertificateCheck
        If this parameter is set, SSL Certificates Checks will be ignored.

        This parameter can be ommitted if the configuration has been stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .EXAMPLE
        PS> Get-NIOSObject -ObjectType network -Limit 5

        _ref                                                                             comment                          network           network_view
        ----                                                                             -------                          -------           ------------
        network/ZG5zLm5ldHdvcmskMTAuMC4xMC4wLzI0LzA:10.0.10.0/24/Company%201             Lab                              10.0.10.0/24      Company 1
        network/ZG5zLm5ldHdvcmskMTI4LjI0Mi45OS4xMjgvMjUvMA:128.242.99.128/25/Company%201 Web DMZ                          128.242.99.128/25 Company 1
        network/ZG5zLm5ldHdvcmskMTAuMTAuMC4wLzI0LzA:10.10.0.0/24/Company%201             test                             10.10.0.0/24      Company 1
        network/ZG5zLm5ldHdvcmskMTAuMC4xLjAvMjQvMA:10.0.1.0/24/Company%201                                                10.0.1.0/24       Company 1
        network/ZG5zLm5ldHdvcmskMTkyLjE2OC4xLjAvMjQvMA:192.168.1.0/24/Company%201        Corporate DC - The Grid + NetMRI 192.168.1.0/24    Company 1

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core
    #>
    param(
        [Parameter(
            ParameterSetName = 'Type',
            Mandatory = $true,
            Position = 0
        )]
        [Alias('type')]
        [String]$ObjectType,
        [Parameter(
            ParameterSetName = 'Ref',
            Mandatory = $true,
            ValueFromPipelineByPropertyName=$true,
            Position = 1
        )]
        [Alias('ref','_ref')]
        [String]$ObjectRef,
        [ValidateRange(1,[int]::MaxValue)]
        [Int]$Limit = 1000,
        [ValidateRange(1,1000)]
        [Int]$PageSize = 1000,
        [Object]$Filters,
        [Alias('ReturnFields')]
        [String[]]$Fields,
        [Alias('ReturnAllFields')]
        [Switch]$AllFields,
        [Alias('ReturnBaseFields')]
        [Switch]$BaseFields,
        [String]$Server,
        [String]$GridUID,
        [String]$GridName,
        [String]$ApiVersion,
        [Switch]$SkipCertificateCheck,
        [PSCredential]$Creds
    )

    begin {
        ## Initialize Query Filters
        [System.Collections.ArrayList]$QueryFilters = @()
        $InvokeOpts = Initialize-NIOSOpts $PSBoundParameters
    }

    process {
        if ($ObjectRef) {
            $ObjectType = $ObjectRef.split('/')[0]
            $QueryURI = $ObjectRef
        } elseif ($ObjectType) {
            $QueryURI = $ObjectType
        }

        ## Build Return Fields
        if (!$AllFields -and $Fields) {
            if ($BaseFields) {
                $QueryFilters.Add("_return_fields%2B=$($Fields -join ',')") | Out-Null
            } else {
                $QueryFilters.Add("_return_fields=$($Fields -join ',')") | Out-Null
            }
        } elseif ($AllFields) {
            $QueryFilters.Add("_return_fields=$((Get-NIOSSchema @InvokeOpts -ObjectType $ObjectType -Fields -Method GET).name -join ',')") | Out-Null
        }

        ## Set _return_as_object
        $QueryFilters.Add("_return_as_object=1") | Out-Null

        ## Build Result Size / Paging
        if ($Limit -gt $PageSize) {
            $QueryFilters.Add("_max_results=$($PageSize)") | Out-Null
            $QueryFilters.Add("_paging=1") | Out-Null
            Write-Host "Query Size Exceeds Page Size $($PageSize). Enabling paging of results.." -ForegroundColor Blue
            $EnablePaging = $true
        } else {
            $QueryFilters.Add("_max_results=$($Limit)") | Out-Null
        }

        ## Build List of Filters
        if ($Filters) {
            if ($Filters -is [string]) {
                # add as-is
                $QueryFilters.Add($Filters) | Out-Null
            }
            elseif ($Filters -is [array] -and $Filters[0] -is [string]) {
                # add as-is
                $QueryFilters.AddRange([string[]]$Filters) | Out-Null
            }
            elseif ($Filters -is [Collections.IDictionary]) {
                # URL encode the pairs and join with '=' before adding
                $Filters.GetEnumerator().foreach{
                    $QueryFilters.Add(
                        ('{0}={1}' -f [Web.HttpUtility]::UrlEncode($_.Key),[Web.HttpUtility]::UrlEncode($_.Value.ToString()))
                    ) | Out-Null
                }
            }
            else {
                Write-Error "Unsupported Filter parameter. This must be a string, array, or hashtable."
                break
            }
        }

        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }
        $Uri = "$($QueryURI)$($QueryString)"

        if ($EnablePaging) {
            try {
                $Results = Invoke-NIOS -Method GET -Uri $Uri @InvokeOpts
            } catch {
                Write-Error $_
                break
            }
            $ReturnResults = @()
            $ReturnResults += $Results.result
            Write-Host -NoNewLine "`r($($ReturnResults.count)/$($Limit)): Results Returned." -ForegroundColor Cyan
            while ($Results.next_page_id -ne $null) {
                if (!($ReturnResults.count -ge $Limit)) {
                    try {
                        $Results = Invoke-NIOS -Method GET -Uri "$($Uri)&_page_id=$($Results.next_page_id)" @InvokeOpts
                    } catch {
                        Write-Error $_
                        break
                    }
                    if (($Limit-$ReturnResults.count) -lt $PageSize) {
                        $ReturnResults += $Results.result | Select-Object -First ($Limit-$ReturnResults.count)
                    } else {
                        $ReturnResults += $Results.result
                    }
                    Write-Host -NoNewLine "`r($($ReturnResults.count)/$($Limit)): Results Returned." -ForegroundColor Cyan
                } else {
                    Write-Host -NoNewLine "`r($($ReturnResults.count)/$($ReturnResults.count)): Results Returned." -ForegroundColor Green
                    break
                }
            }
        } else {
            try {
                $ReturnResults = (Invoke-NIOS -Method GET -Uri $Uri @InvokeOpts).result
            } catch {
                Write-Error $_
                break
            }
        }

        if ($ReturnResults) {
            return $ReturnResults
        }
    }

}