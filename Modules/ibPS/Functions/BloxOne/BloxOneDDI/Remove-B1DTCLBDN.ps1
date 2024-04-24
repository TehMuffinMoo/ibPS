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

        $Result = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
        if (!(Get-B1DTCLBDN -id $Object.id)) {
            Write-Host "Successfully removed DTC LBDN: $($Object.name)" -ForegroundColor Green
        } else {
            Write-Error "Failed to remove DTC LBDN: $($Object.name)"
        }
    }
}