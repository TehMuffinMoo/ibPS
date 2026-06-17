function Enable-B1HostLocalAccess {
    <#
    .SYNOPSIS
        Enables the Bootstrap UI Local Access for the given NIOS-X Host

    .DESCRIPTION
        This function is used to enable the Bootstrap UI Local Access for the given NIOS-X Host

    .PARAMETER Server
        The name of the NIOS-X Host to enable local access for

    .PARAMETER UseDefaultCredentials
        Using the -UseDefaultCredentials parameter will attempt to use the default credentials (admin + last 8 characters of serial number)

    .PARAMETER Credentials
        The -Credentials parameter allows entering the Local Access credentials required to enable it

    .PARAMETER Wait
        Using the -Wait parameter will wait and check if the local access is enabled successfully. This can be manually checked using Get-B1HostLocalAccess

    .PARAMETER OPH
        The NIOS-X Host object to submit a enable local access request for. This accepts pipeline input from Get-B1Host

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1Host my-host-1 | Enable-B1HostLocalAccess -UseDefaultCredentials -Wait

            Local access enable request successfully sent for: my-host-1
            Checking local access enabled state..
            Local Access Enabled Successfully.
            You can access this by browsing to: https://10.15.23.101

            enabled  time_left    period    B1Host
            -------  ---------    ------    ------
            True     1h 59m 50s   2h 0m 0s  my-host-1

    .EXAMPLE
        PS> Enable-B1HostLocalAccess -Server my-host-1 -UseDefaultCredentials

            Local access enable request successfully sent for: my-host-1

    .FUNCTIONALITY
        NIOS-X

    .FUNCTIONALITY
        Bootstrap
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(
            ParameterSetName=("Default Credentials","Server"),
            Mandatory=$true
        )]
        [Parameter(
            ParameterSetName=("Typed Credentials","Server"),
            Mandatory=$true
        )]
        [Alias('B1Host')]
        [String]$Server,
        [Parameter(
            ParameterSetName=("Default Credentials","Server"),
            Mandatory=$true
        )]
        [Parameter(
            ParameterSetName=("Default Credentials","Pipeline"),
            Mandatory=$true
        )]
        [Switch]$UseDefaultCredentials,
        [Parameter(
            ParameterSetName=("Typed Credentials","Server"),
            Mandatory=$true
        )]
        [Parameter(
            ParameterSetName=("Typed Credentials","Pipeline"),
            Mandatory=$true
        )]
        [PSCredential]$Credentials,
        [Switch]$Wait,
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName=("Typed Credentials","Pipeline"),
            Mandatory=$true
        )]
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName=("Default Credentials","Pipeline"),
            Mandatory=$true
        )]
        [System.Object]$Object,
        [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        $ProcessStart = Get-Date
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/host") {
                $Object = Get-B1Host -id $($Object.id)
                if (-not $Object) {
                    Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/host' objects as input"
                    return $null
                } else {
                    $OPHID = $Object.ophid
                }
            } else {
                $OPHID = $Object.ophid
            }
        } else {
            $Object = Get-B1Host -Name $Server -Strict
            if ($Object.ophid) {
                $OPHID = $Object.ophid
            } else {
                Write-Error "Unable to find On-Prem Host with provided parameters."
                return $null
            }
        }
        ## Exclude NIOS-XaaS
        $Object = $Object | Where-Object {$_.managed_by -ne "infoblox"}

        if ($UseDefaultCredentials) {
            $HostSerial = ($Object | Select-Object -ExpandProperty tags).'host/serial_number'
            if ($HostSerial) {
                Switch -Wildcard ($HostSerial) {
                    "VMware-*" {
                        $HostSerial = $HostSerial.Replace(' ','')
                        $HostPassword = $HostSerial.Substring($HostSerial.length -8)
                    }
                    default {
                        $HostPassword = $HostSerial.Substring($HostSerial.length -8)
                    }
                }
                [PSCustomObject]$LocalAccessCredentials = @{
                    'Username' = 'admin'
                    'Password' = $HostPassword
                }
            } else {
                Write-Error "Unable to determine default credentials for $($Object.display_name)."
            }
        } else {
            if (!($Credentials)) {
                $Credentials = Get-Credential
            }
            [PSCustomObject]$LocalAccessCredentials = @{
                'Username' = $Credentials.GetNetworkCredential().Username
                'Password' = $Credentials.GetNetworkCredential().Password
            }
        }

        if ($LocalAccessCredentials.Username -and $LocalAccessCredentials.Password) {
            $JSONData = @{
                "username" = $LocalAccessCredentials.Username
                "password" = $LocalAccessCredentials.Password
            } | ConvertTo-Json

            if($PSCmdlet.ShouldProcess("Enable Local Access on: $($Object.display_name)","Enable Local Access on: $($Object.display_name)",$MyInvocation.MyCommand)){
                $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CspUrl)/bootstrap-app/v1/host/$($OPHID)/enable_local_access" -Data $($JSONData)
                if ($Results.Count -eq 1) {
                    Write-Host "Local access enable request successfully sent for: $($Object.display_name)" -ForegroundColor Green
                    if ($Wait) {
                        $Count = 0
                        while ($Count -lt 60) {
                            Write-Host "Checking local access enabled state.." -ForegroundColor Yellow
                            $B1HostLocalAccess = $Object | Get-B1HostLocalAccess
                            if ($B1HostLocalAccess.enabled -eq "True") {
                                Write-Host "Local Access Enabled Successfully." -ForegroundColor Green
                                Write-Host "You can access this by browsing to: https://$($Object.ip_address)" -ForegroundColor Cyan
                                return $B1HostLocalAccess
                            } else {
                                $AuditLog = Get-B1AuditLog -Action "LocalAccessEnabled" -Start $ProcessStart -ErrorAction SilentlyContinue
                                if ($AuditLog) {
                                    $Entries = $AuditLog | Where-Object {($_.event_metadata.value | ConvertFrom-Json).ophid -eq "$($OPHID)"}
                                    $LatestEntry = $Entries | Sort-Object created_at -Desc | Select-Object -First 1
                                    if ($LatestEntry.result -eq "Failed") {
                                        Write-Error $($LatestEntry.message)
                                        return $null
                                    }
                                }
                            }
                            Wait-Event -Timeout 10
                            $Count += 10
                        }
                        Write-Error "Error. Timed out waiting for Local Access to be enabled."
                    }
                } else {
                    Write-Error "Error. Failed to sent local access enable request for: $($Object.display_name)"
                }
            }
        }
    }
}