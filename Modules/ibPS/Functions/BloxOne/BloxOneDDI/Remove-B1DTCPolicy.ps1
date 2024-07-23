function Remove-B1DTCPolicy {
    <#
    .SYNOPSIS
        Removes an existing BloxOne DTC Policy

    .DESCRIPTION
        This function is used to remove an existing BloxOne DTC Policy

    .PARAMETER Name
        The name of the DTC Policy to remove

    .PARAMETER Object
        The DTC Policy Object(s) to remove. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1DTCPolicy -Name "Exchange-Policy"

        Successfully removed DTC Policy: Exchange-Policy

    .EXAMPLE
        PS> Get-B1DTCPolicy -Name "Exchange-Policy" | Remove-B1DTCPolicy

        Successfully removed DTC Policy: Exchange-Policy

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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/policy") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/policy' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCPolicy -Name $($Name) -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Policy: $($Name)"
                return $null
            }
        }
        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
            $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
            if (!(Get-B1DTCPolicy -id $Object.id)) {
                Write-Host "Successfully removed DTC Policy: $($Object.name)" -ForegroundColor Green
            } else {
                Write-Error "Failed to remove DTC Policy: $($Object.name)"
            }
        }
    }
}