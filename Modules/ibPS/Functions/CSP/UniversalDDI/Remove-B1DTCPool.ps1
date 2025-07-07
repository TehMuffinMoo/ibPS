function Remove-B1DTCPool {
    <#
    .SYNOPSIS
        Removes an existing Universal DDI DTC Pool

    .DESCRIPTION
        This function is used to remove an existing Universal DDI DTC Pool

    .PARAMETER Name
        The name of the DTC Pool to remove

    .PARAMETER Object
        The DTC Pool Object(s) to remove. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DTCPool -Name "Exchange-Pool"

        Successfully removed DTC Pool: Exchange-Pool

    .EXAMPLE
        PS> Get-B1DTCPool -Name "Exchange-Pool"| Remove-B1DTCPool

        Successfully removed DTC Pool: Exchange-Pool

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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/pool") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/pool' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCPool -Name $($Name) -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Pool: $($Name)"
                return $null
            }
        }

        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
            $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
            if (!(Get-B1DTCPool -id $Object.id)) {
                Write-Host "Successfully removed DTC Pool: $($Object.name)" -ForegroundColor Green
            } else {
                Write-Error "Failed to remove DTC Pool: $($Object.name)"
            }
        }
    }
}