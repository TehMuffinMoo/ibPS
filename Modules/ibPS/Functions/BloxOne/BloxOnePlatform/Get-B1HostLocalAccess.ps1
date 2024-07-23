function Get-B1HostLocalAccess {
    <#
    .SYNOPSIS
        Checks the Bootstrap UI Local Access status for the given BloxOne Host

    .DESCRIPTION
        This function is used to check the Bootstrap UI Local Access status for the given BloxOne Host

    .PARAMETER B1Host
        The name of the BloxOne Host to check the current local access status for

    .PARAMETER OPH
        The BloxOne Host object to check the current local access status for. This accepts pipeline input from Get-B1Host

    .EXAMPLE
        PS> Get-B1HostLocalAccess -B1Host "my-host-1"

        enabled  time_left    period     B1Host
        -------  ---------    ------     ------
        True     1h 53m 46s   2h 0m 0s   my-host-1

    .EXAMPLE
        PS> Get-B1Host | Get-B1HostLocalAccess

        time_left   period       enabled   B1Host
        ---------   ------       -------   ------
        1h 53m 42s  2h 0m 0s     True      my-host-1
        0h 0m 0s    2h 0m 0s     False     my-host-2
        0h 0m 0s    2h 0m 0s     False     my-host-3
        0h 0m 0s    2h 0m 0s     False     my-host-4
        ...

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Bootstrap
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            ParameterSetName=("Default"),
            Mandatory=$true
        )]
        [String]$B1Host,
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName=("Pipeline"),
            Mandatory=$true
        )]
        [PSCustomObject[]]$OPH
    )

    process {
        if ($OPH) {
            if (($OPH.id.split('/')[1]) -ne "host") {
                Write-Error "Error. Unsupported pipeline object. The input must be of type: host"
                break
            } else {
                $OPHID = $OPH.ophid
            }
        } else {
            $OPH = Get-B1Host -Name $B1Host -Strict
            if (!($OPH)) {
                Write-Error "Error. Unable to find BloxOne Host: $($B1Host)"
                break
            } else {
                $OPHID = $OPH.ophid
            }
        }
        if ($OPHID) {
            $LocalAccess = Invoke-CSP -Method GET -Uri "$(Get-B1CspUrl)/bootstrap-app/v1/host/$($OPHID)/host_info" | Select-Object -ExpandProperty local_access -EA SilentlyContinue -WA SilentlyContinue
            if (!($LocalAccess.enabled)) {
                $LocalAccess | Add-Member -Type NoteProperty -Name "enabled" -Value 'False'
            }
            $LocalAccess | Add-Member -Type NoteProperty -Name "B1Host" -Value $($OPH.display_name)
            return $LocalAccess
        } else {
            Write-Error "Error. OPHID is invalid."
            break
        }
    }
}