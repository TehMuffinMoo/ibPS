function Remove-B1RecycleBin {
    <#
    .SYNOPSIS
        Removes an item from the Universal DDI Recycle Bin

    .DESCRIPTION
        This function is used to remove an item from the Universal DDI Recycle Bin. This only accepts pipeline input.

    .PARAMETER Object
        The Recycle Bin Object. Accepts pipeline input from Get-B1RecycleBin

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1RecycleBin -ResourceName "my.resource.name" -ResourceType "DNS Record" | Remove-B1RecycleBin

        Successfully peremently deleted 1 Recycle Bin item(s)

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
        $IDsToDelete = @()
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
        $IDsToDelete += $SplitID[2]
    }

    end {
        if ($IDsToDelete.Count -eq 0) {
            Write-Warning "No valid Recycle Bin items were provided"
            return
        }

        if ($PSCmdlet.ShouldProcess("$($IDsToDelete.Count) Recycle Bin items")) {
            $Payload = @{ ids = $IDsToDelete } | ConvertTo-Json

            Invoke-CSP -Method DELETE `
                -Uri "$(Get-B1CSPUrl)/api/atlas-recyclebin/v1/items" `
                -Data $Payload

            Write-Host "Sent request to permanently delete $($IDsToDelete.Count) Recycle Bin item(s)" -ForegroundColor Green
        }
    }
}