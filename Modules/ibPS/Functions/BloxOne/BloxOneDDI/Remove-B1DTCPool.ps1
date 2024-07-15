function Remove-B1DTCPool {
    <#
    .SYNOPSIS
        Removes an existing BloxOne DTC Pool

    .DESCRIPTION
        This function is used to remove an existing BloxOne DTC Pool

    .PARAMETER Name
        The name of the DTC Pool to remove

    .PARAMETER Object
        The DTC Pool Object(s) to remove. Accepts pipeline input.

    .EXAMPLE
        PS> Remove-B1DTCPool -Name "Exchange-Pool"

        Successfully removed DTC Pool: Exchange-Pool

    .EXAMPLE
        PS> Get-B1DTCPool -Name "Exchange-Pool"| Remove-B1DTCPool

        Successfully removed DTC Pool: Exchange-Pool

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    param(
        [Parameter(ParameterSetName="Default",Mandatory=$true)]
        [String]$Name,
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName="With ID",
            Mandatory=$true
        )]
        [System.Object]$Object
    )

    process {
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

        $Result = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        if (!(Get-B1DTCPool -id $Object.id)) {
            Write-Host "Successfully removed DTC Pool: $($Object.name)" -ForegroundColor Green
        } else {
            Write-Error "Failed to remove DTC Pool: $($Object.name)"
        }
    }
}