function Restore-B1RecycleBin {
    <#
    .SYNOPSIS
        Restores an item from the Universal DDI Recycle Bin

    .DESCRIPTION
        This function is used to restore an item from the Universal DDI Recycle Bin. This only accepts pipeline input.

    .PARAMETER Object
        The Recycle Bin Object. Accepts pipeline input from Get-B1RecycleBin

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1RecycleBin -ResourceName "my.resource.name" -ResourceType "DNS Record" | Restore-B1RecycleBin

        Successfully restored 1 Recycle Bin item(s)

    .FUNCTIONALITY
        Universal DDI
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [System.Object]$Object,
        [Switch]$Force
    )

    begin {
        $IDsToRestore = @()
    }

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters

        if (-not $Object) {
            Write-Error "Recycle Bin item not found"
            return
        }

        $SplitID = $Object.id.Split('/')
        if ("$($SplitID[0])/$($SplitID[1])" -ne "atlas.recyclebin/deleted_items") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'atlas.recyclebin/deleted_items' objects as input"
            return
        }

        # Add ID to batch list
        $IDsToRestore += $SplitID[2]
    }

    end {
        if ($IDsToRestore.Count -eq 0) {
            Write-Warning "No valid Recycle Bin items were provided"
            return
        }

        if ($PSCmdlet.ShouldProcess("$($IDsToRestore.Count) Recycle Bin items")) {
            $Payload = @{ id = $IDsToRestore } | ConvertTo-Json

            Invoke-CSP -Method PUT `
                -Uri "$(Get-B1CSPUrl)/api/atlas-recyclebin/v1/items/restore" `
                -Data $Payload

                Write-Host "Sent request to restore $($IDsToRestore.Count) Recycle Bin item(s)" -ForegroundColor Green
        }
    }
}