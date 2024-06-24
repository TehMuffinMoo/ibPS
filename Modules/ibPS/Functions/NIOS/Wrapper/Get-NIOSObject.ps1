function Get-NIOSObject {
    <#
    .SYNOPSIS
        Generic Wrapper for interaction with the NIOS WAPI

    .DESCRIPTION
        This is a Generic Wrapper for interaction with the NIOS WAPI

    .PARAMETER ObjectRef
        Specify the object URI / API endpoint and query parameters here

    .EXAMPLE
        PS> Get-NIOSObject 'network?_max_results=1000&_return_as_object=1'

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core
    #>
    param(
        [Parameter(
            ParameterSetName = 'Type',
            Mandatory = $true
        )]
        [Alias('type')]
        [String]$ObjectType,
        [Parameter(
            ParameterSetName = 'Ref',
            Mandatory = $true,
            ValueFromPipelineByPropertyName=$true
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
                } else {
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