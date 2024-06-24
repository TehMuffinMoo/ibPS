function New-NIOSObject {
    param(
        [Parameter(Mandatory = $true)]
        [Alias('type')]
        [String]$ObjectType,
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline=$true
        )]
        [PSCustomObject]$Object,
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
        try {
            $Uri = "$($ObjectType)$($QueryString)"
            $JSON = $Object | ConvertTo-Json -Depth 5
            Invoke-NIOS @InvokeOpts -Uri $Uri -Method POST -Data $JSON
        } catch {
            Write-Error $_
            break
        }
    }
}