function Initialize-NIOSOpts {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        $Opts
    )

    $RequiredOpts = @(
        'Server'
        'GridUID'
        'GridName'
        'ApiVersion'
        'SkipCertificateCheck'
        'Creds'
    )
    $ReturnOpts = @{}
    $Opts.GetEnumerator() | %{ 
        if ($_.Key -in $RequiredOpts) {
            $ReturnOpts += @{$_.Key=$_.Value}
        }
    }
    return $ReturnOpts
}