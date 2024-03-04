function Set-B1HAGroup {
    <#
    .SYNOPSIS
        Updates an existing HA Group in BloxOneDDI

    .DESCRIPTION
        This function is used to update an existing HA Group in BloxOneDDI

    .PARAMETER Name
        The name of the HA Group to modify

    .PARAMETER Mode
        The mode to update the HA Group to

    .PARAMETER PrimaryNode
        The hostname or FQDN of the primary BloxOneDDI Host to update

    .PARAMETER SecondaryNode
        The hostname or FQDN of the secondary BloxOneDDI Host to update

    .PARAMETER Description
        The new description/comment to modify the HA Group to

    .PARAMETER Tags
        Any tags you want to apply to the HA Group

    .EXAMPLE
          PS> Set-B1HAGroup -Name "MyHAGroup" -Mode "active-passive" -PrimaryNode "bloxoneddihost1.mydomain.corp" -SecondaryNode "bloxoneddihost2.mydomain.corp" -Description "DHCP HA Group" -Tags @{"TagName"="TagValue"}
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    param(
        [Parameter(ParameterSetName="noID",Mandatory=$true)]
        [String]$Name,
        [ValidateSet("active-active", "active-passive", "advanced-active-passive")]
        [String]$Mode,
        [String]$PrimaryNode,
        [String]$SecondaryNode,
        [String]$Description,
        [System.Object]$Tags,
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = "ID",
            Mandatory = $true
        )]
        [String]$id
    )

    process {
        if ($id) {
            $HAGroup = Get-B1HAGroup -id $id -Strict -Fields name,mode,hosts,comment,tags
        } else {
            $HAGroup = Get-B1HAGroup -Name $Name -Strict -Fields name,mode,hosts,comment,tags
        }
        if (!($HAGroup)) {
            Write-Error "HA Group does not exist: $Name."
        }
        else {
            if ($Mode) {
                $HAGroup.mode = $Mode
                if ($Mode -eq "active-active") {
                    $HAGroup.hosts[0].role = "active"
                    $HAGroup.hosts[1].role = "active"
                }
                else {
                    $HAGroup.hosts[0].role = "active"
                    $HAGroup.hosts[1].role = "passive"
                }
            }
            if ($PrimaryNode) {
                if (!($PrimaryHost = (Get-B1Host -Name $PrimaryNode -BreakOnError).legacy_id)) {
                    $PrimaryHostConfig = @{
                        "host" = "dhcp/host/$($PrimaryHost.legacy_id)"
                        "role" = "active"
                    }
                    $HAGroup.hosts[0] = $PrimaryHostConfig
                }
            }
            else {
                $HAGroup.hosts[0].PSObject.Properties.Remove(0)
            }
            $HAGroup.hosts[0].PSObject.Properties.Remove('port')
            if ($SecondaryNode) {
                if (!($SecondaryHost = (Get-B1Host -Name $SecondaryNode -BreakOnError).legacy_id)) {
                    $HAGroup.hosts[1].host = "dhcp/host/$($SecondaryHost.legacy_id)"
                    if ($Mode -eq "active-passive" -or $Mode -eq "advanced-active-passive") {
                        $SecondaryRole = "passive"
                    }
                    else {
                        $SecondaryRole = "active"
                    }
                    $SecondaryHostConfig = @{
                        "host" = "dhcp/host/$($SecondaryHost.legacy_id)"
                        "role" = "$($SecondaryRole)"
                    }
                    $HAGroup.hosts[1] = $SecondaryHostConfig
                }
            }
            $HAGroup.hosts[1].PSObject.Properties.Remove('port')
            if ($Description) {
                $HAGroup.comment = $Description
            }
            if ($Tags) {
                $HAGroup.tags = $Tags
            }
            $HAGroupID = $HAGroup.id
            $HAGroup.PSObject.Properties.Remove('id')
            $splat = $HAGroup | ConvertTo-Json -Depth 5
            if ($Debug) { $splat }

            $Result = Query-CSP -Method PATCH -Uri $($HAGroupID) -Data $splat | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue
            if ($Result.id -eq $HAGroupID) {
                Write-Host "Updated DHCP HA Group $($HAGroup.name) Successfully." -ForegroundColor Green
                return $Result
            }
            else {
                Write-Host "Failed to update DHCP HA Group $($HAGroup.name)." -ForegroundColor Red
            }
        }
    }
} 
