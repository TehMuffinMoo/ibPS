function Remove-B1DTCLBDN {
    <#
    .SYNOPSIS
        Removes an existing BloxOne DTC LBDN

    .DESCRIPTION
        This function is used to remove an existing BloxOne DTC LBDN

    .PARAMETER Name
        The name of the DTC LBDN to remove (FQDN)

    .PARAMETER Object
        The DTC LBDN Object(s) to remove. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DTCLBDN -Name "webmail.company.corp."

        Successfully removed DTC LBDN: webmail.company.corp.

    .EXAMPLE
        PS> Get-B1DTCLBDN -Name "webmail.company.corp"| Remove-B1DTCLBDN

        Successfully removed DTC LBDN: Exchange-LBDN

    .FUNCTIONALITY
        BloxOneDDI

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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/lbdn") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/lbdn' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCLBDN -Name $($Name) -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC LBDN: $($Name)"
                return $null
            }
        }
        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
            $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
            if (!(Get-B1DTCLBDN -id $Object.id)) {
                Write-Host "Successfully removed DTC LBDN: $($Object.name)" -ForegroundColor Green
            } else {
                Write-Error "Failed to remove DTC LBDN: $($Object.name)"
            }
        }
    }
}