function Restart-B1Host {
    <#
    .SYNOPSIS
        Restarts a BloxOneDDI Host

    .DESCRIPTION
        This function is used to initiate a reboot of a BloxOneDDI Host

    .PARAMETER B1Host
        The FQDN of the host to reboot

    .PARAMETER Object
        The BloxOneDDI Host Object(s) to restart. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Restart-B1Host -B1Host "bloxoneddihost1.mydomain.corp" -NoWarning

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
        [Parameter(ParameterSetName="Default",Mandatory=$true)]
        [Alias('OnPremHost')]
        [String]$B1Host,
        [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
        )]
        [System.Object]$Object,
        [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/host") {
                $Object = Get-B1Host -id $($Object.id) -Detailed
                if (-not $Object) {
                  Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/host' objects as input"
                  return $null
                }
                $HostID = $Object.id
            } else {
              $HostID = $SplitID[2]
            }
        } else {
            $Object = Get-B1Host -Name $B1Host -Strict -Detailed
            if (!($Object)) {
                Write-Error "Unable to find BloxOne Host: $($B1Host)"
                return $null
            }
            $HostID = $Object.id
        }

        $JSON = @{
            "ophid" = $Object.ophid
            "cmd" = @{
            "name" = "reboot"
            }
        } | ConvertTo-Json

        if($PSCmdlet.ShouldProcess("$($Object.display_name) ($($HostID))")){
            Write-Host "Rebooting $($Object.display_name).." -ForegroundColor Yellow
            Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/atlas-onprem-diagnostic-service/v1/privilegedtask" -Data $JSON | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        }
    }
}