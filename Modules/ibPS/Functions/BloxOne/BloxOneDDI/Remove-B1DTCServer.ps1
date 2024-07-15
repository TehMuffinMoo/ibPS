function Remove-B1DTCServer {
    <#
    .SYNOPSIS
        Removes an existing BloxOne DTC Server

    .DESCRIPTION
        This function is used to remove an existing BloxOne DTC Server

    .PARAMETER Name
        The name of the DTC Server to remove

    .PARAMETER Object
        The DTC Server Object(s) to remove. Accepts pipeline input.

    .EXAMPLE
        PS> Remove-B1DTCServer -Name "EXCHANGE-MAIL01"

        Successfully removed DTC Server: EXCHANGE-MAIL01

    .EXAMPLE
        PS> Get-B1DTCServer -Name "EXCHANGE-" | Remove-B1DTCServer

        Successfully removed DTC Server: EXCHANGE-MAIL01
        Successfully removed DTC Server: EXCHANGE-MAIL02

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

        $Result = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        if (!(Get-B1DTCServer -id $Object.id)) {
            Write-Host "Successfully removed DTC Server: $($Object.name)" -ForegroundColor Green
        } else {
            Write-Error "Failed to remove DTC Server: $($Object.name)"
        }
    }
}