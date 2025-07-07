function Remove-B1DTCHealthCheck {
    <#
    .SYNOPSIS
        Removes an existing Universal DDI DTC Health Check

    .DESCRIPTION
        This function is used to remove an existing Universal DDI DTC Health Check

    .PARAMETER Name
        The name of the DTC Health Check to remove

    .PARAMETER Object
        The DTC Health Check Object(s) to remove. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DTCHealth Check -Name "Exchange-HealthCheck"

        Successfully removed DTC Health Check: Exchange-HealthCheck

    .EXAMPLE
        PS> Get-B1DTCHealth Check -Name "Exchange-HealthCheck"| Remove-B1DTCHealthCheck

        Successfully removed DTC Health Check: Exchange-HealthCheck

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(ParameterSetName="Default",Mandatory=$true)]
        [String]$Name,
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
            $PermittedObjects = 'dtc/health_check_http','dtc/health_check_tcp','dtc/health_check_icmp'
            if (("$($SplitID[0])/$($SplitID[1])") -notin $PermittedObjects) {
                Write-Error "Error. Unsupported pipeline object. This function supports 'dtc/health_check_http', 'health_check_tcp' & 'health_check_icmp' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCHealthCheck -Name $($Name) -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Health Check: $($Name)"
                return $null
            }
        }
        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
            $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
            if (!(Get-B1DTCHealthCheck -id $Object.id)) {
                Write-Host "Successfully removed DTC Health Check: $($Object.name)" -ForegroundColor Green
            } else {
                Write-Error "Failed to remove DTC Health Check: $($Object.name)"
            }
        }
    }
}