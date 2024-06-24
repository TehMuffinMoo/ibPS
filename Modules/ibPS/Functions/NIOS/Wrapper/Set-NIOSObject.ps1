function Set-NIOSObject {
    param(
        [Parameter(
            Mandatory=$true,
            ParameterSetName='Object',
            ValueFromPipeline=$true
        )]
        [PSCustomObject]$Object,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ref',
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias('ref','_ref')]
        [String]$ObjectRef,
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Ref',
            ValueFromPipelineByPropertyName=$true
        )]
        [PSCustomObject]$TemplateObject,
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
        Switch($PSCmdlet.ParameterSetName) {
            'Object' {
                if (!($Object._ref)) {
                    Write-Error "Input object is missing the '_ref' field."
                    return $null
                }
                $ObjectRef = $Object._ref
            }
            'Ref' {
                $Object = $TemplateObject
            }
        }

        $ObjectType = $ObjectRef.split('/')[0]

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

        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }

        $Uri = "$($ObjectRef)$($QueryString)"

        ## Strip non-writable fields
        $PUTFields = (Get-NIOSSchema @InvokeOpts -ObjectType $ObjectType -Fields -Method PUT).name
        $FieldsToRemove = $Object.PSObject.Properties.Name | Where-Object {$_ -notin $PUTFields}
        $FieldsToRemove | %{
            $Object.PSObject.Properties.Remove($_)
        }

        $JSON = $Object | ConvertTo-Json -Depth 5

        try {
            Invoke-NIOS @InvokeOpts -Uri $Uri -Method PUT -Data $JSON
        } catch {
            Write-Error $_
            break
        }
    }
}