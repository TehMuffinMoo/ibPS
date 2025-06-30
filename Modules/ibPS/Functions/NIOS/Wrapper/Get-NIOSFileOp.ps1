function Get-NIOSFileOp {
    <#
    .SYNOPSIS
        Generic Wrapper function for retrieving files from the NIOS WAPI

    .DESCRIPTION
        Generic Wrapper function for retrieving files from the NIOS WAPI, either directly or via Universal DDI Federation

    .PARAMETER Function
        The File Operation to perform, i.e 'get_log_files'

    .PARAMETER Data
        The HTTP Body to submit as part of the File Operation. This should be in [Object] format, as it gets converted to JSON by this function.

    .PARAMETER Path
        The file path to use when specifying the -Download option. Defaults to the current directory.

    .PARAMETER Download
        Switch parameter to indicate whether to download the file.

    .PARAMETER Server
        Specify the NIOS Grid Manager IP or FQDN to use

        This parameter can be ommitted if the Server is stored by using Set-NIOSConnectionProfile

        This is used only when connecting to NIOS directly.

    .PARAMETER GridUID
        Specify the NIOS Grid UID (license_uid). This indicates which Grid to connect to when using NIOS Federation within Universal DDI.

    .PARAMETER GridName
        Specify the NIOS Grid Name in Universal DDI instead of the GridUID. This is convient, but requires resolving the license_uid on every API Call.

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
        $Data = @{"log_type" = "SYSLOG"; "member" = "grid-member.fqdn.corp"; "node_type" = "ACTIVE"}
        Get-NIOSFileOp -Function 'get_log_files' -Data $Data -Download

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Core
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String]$Function,
        [System.Object]$Data,
        [String]$Path = './',
        [Switch]$Download,
        [String]$Server,
        [String]$GridUID,
        [String]$GridName,
        [String]$ApiVersion,
        [Switch]$SkipCertificateCheck,
        [PSCredential]$Creds
    )

    begin {
        ## Initialize Query Filters
        $InvokeOpts = Initialize-NIOSOpts $PSBoundParameters
        if (!(Test-Path $Path)) {
            Write-Error "Unable to find path: $($Path)"
            break
        }
    }

    process {
        try {
            $Uri = "fileop?_function=$($Function)"
            $JSON = $Data | ConvertTo-Json -Depth 5
            $ReturnResults = Invoke-NIOS -Method POST -Uri $Uri -Data $JSON @InvokeOpts
        } catch {
            Write-Error $_
            break
        }

        if ($ReturnResults) {
            if ($Download) {
                $Url = [Uri]$($ReturnResults.url)
                if ($InvokeOpts.GridUID) {
                    [Uri]$CSP = Get-B1CSPUrl
                    $DownloadUri = "https://wapi.$($CSP.DnsSafeHost)$($Url.PathAndQuery)"
                } else {
                    $DownloadUri = "https://$($InvokeOpts.Server)$($Url.PathAndQuery)"
                }
                try {
                    ## Download File
                    Write-Debug 'Downloading file..'
                    Invoke-NIOS -Method GET -Uri $DownloadUri -OutFile $Path -AdditionalHeaders @{'Content-Type'='application/force-download'} -Data $([String]::Empty) @InvokeOpts
                    Write-Host "File downloaded to: $((Get-Item $Path).ResolvedTarget)" -ForegroundColor Green
                    try {
                        ## Indicate download completion
                        $Token = $ReturnResults | Select-Object token
                        Write-Debug 'Marking download as complete..'
                        Get-NIOSFileOp -Function downloadcomplete -Data $Token
                    } catch {
                        Write-Error $_
                    }
                } catch {
                    Write-Error $_
                }
            } else {
                return $ReturnResults
            }
        }
    }

}