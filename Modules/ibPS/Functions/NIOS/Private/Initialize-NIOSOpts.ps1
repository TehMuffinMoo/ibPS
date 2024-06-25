function Initialize-NIOSOpts {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        $Opts
    )
    $AcceptedNIOSOpts = @('Server','GridUID','GridName','ApiVersion','SkipCertificateCheck','Creds')
    $NIOSOpts = @{}
    $Opts.GetEnumerator() | %{
        if ($_.Key -in $AcceptedNIOSOpts) { $NIOSOpts += @{$_.Key=$_.Value} }
    }
    if ($NIOSOpts.Count -gt 0) {
        $ReturnOpts = @{}
        $Opts.GetEnumerator() | %{
            Switch($_.Key) {
                'Server' { $ReturnOpts.Server = $Opts.Server }
                'GridUID' { $ReturnOpts.GridUID = $Opts.GridUID }
                'GridName' { $ReturnOpts.GridName = $Opts.GridName }
                'ApiVersion' { $ReturnOpts.ApiVersion = $Opts.ApiVersion }
                'SkipCertificateCheck' { $ReturnOpts.SkipCertificateCheck = $Opts.SkipCertificateCheck }
                'Creds' { $ReturnOpts.Creds = [PSCredential]$Opts.Creds }
            }
        }
    } else {
        $CurrentContext = (Get-NIOSContext).CurrentContext
        if ($CurrentContext) {
            $SelectedContext = (Get-NIOSContext).Contexts."$($CurrentContext)"
            if ($SelectedContext) {
                Switch($SelectedContext.Type) {
                    'Local' {
                        $SelectedConfig = $SelectedContext | Select-Object Server,Credentials,APIVersion,SkipCertificateCheck
    
                        ## Decode User/Pass
                        $Username = $SelectedConfig.Credentials.Username
                        $Base64Password = $SelectedConfig.Credentials.Password
                        $Password = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Base64Password)) | ConvertTo-SecureString
                        [PSCredential]$Creds = New-Object System.Management.Automation.PSCredential ($Username, $Password)
    
                        $Context = @{
                            'Server' = $SelectedConfig.Server
                            'APIVersion' = $SelectedConfig.APIVersion
                            'SkipCertificateCheck' = $SelectedConfig.SkipCertificateCheck
                            'Creds' = [PSCredential]$Creds
                        }
    
                        $ReturnOpts = $Context
                    }
                    'Federated' {
                        $SelectedConfig = $SelectedContext | Select-Object GridUID,APIVersion
    
                        $Context = @{
                            'GridUID' = $SelectedConfig.GridUID
                            'APIVersion' = $SelectedConfig.APIVersion
                        }
    
                        $ReturnOpts = $Context
                    }
                }
            }
        }
    }
    return $ReturnOpts
}