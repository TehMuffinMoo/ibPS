function Remove-B1DTCServer {
    <#
    .SYNOPSIS
        Removes an existing Universal DDI DTC Server

    .DESCRIPTION
        This function is used to remove an existing Universal DDI DTC Server

    .PARAMETER Name
        The name of the DTC Server to remove

    .PARAMETER Object
        The DTC Server Object(s) to remove. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DTCServer -Name "EXCHANGE-MAIL01"

        Successfully removed DTC Server: EXCHANGE-MAIL01

    .EXAMPLE
        PS> Get-B1DTCServer -Name "EXCHANGE-" | Remove-B1DTCServer

        Successfully removed DTC Server: EXCHANGE-MAIL01
        Successfully removed DTC Server: EXCHANGE-MAIL02

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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/server") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/server' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCServer -Name $($Name) -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Server: $($Name)"
                return $null
            }
        }

        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
            $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
            if (!(Get-B1DTCServer -id $Object.id)) {
                Write-Host "Successfully removed DTC Server: $($Object.name)" -ForegroundColor Green
            } else {
                Write-Error "Failed to remove DTC Server: $($Object.name)"
            }
        }
    }
}