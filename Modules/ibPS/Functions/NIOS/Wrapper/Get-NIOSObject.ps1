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
        BloxOneDDI

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
        Mandatory = $true
      )]
      [Alias('ref','_ref')]
      [String]$ObjectRef,
      [Int]$Limit = 1000,
      [String[]]$Fields,
      [String[]]$AllFields,
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

        ## Build Return Fields
        if (!$AllFields -and $Fields) {
            if ($BaseFields) {
                $QueryFilters.Add("_return_fields%2B=$($Fields -join ',')") | Out-Null
            } else {
                $QueryFilters.Add("_return_fields=$($Fields -join ',')") | Out-Null
            }
        }

        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }
    }

    process {
        $Uri = "$ObjectType$QueryString"

        $Results = Invoke-NIOS -Method GET -Uri $Uri @InvokeOpts
        if ($Results) {
            $Results
        }
    }

}