function Remove-NIOSObject {
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName=$true
        )]
        [Alias('ref','_ref')]
        [String]$ObjectRef,
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
            Invoke-NIOS @InvokeOpts -Uri $ObjectRef -Method DELETE
        } catch {
            Write-Error $_
            break
        }
    }
}