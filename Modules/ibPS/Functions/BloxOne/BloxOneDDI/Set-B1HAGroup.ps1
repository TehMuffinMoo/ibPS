function Set-B1HAGroup {
    <#
    .SYNOPSIS
        Updates an existing HA Group in BloxOneDDI

    .DESCRIPTION
        This function is used to update an existing HA Group in BloxOneDDI

    .PARAMETER Name
        The name of the HA Group to modify

    .PARAMETER NewName
        Use -NewName to update the name of the HA Group

    .PARAMETER Description
        The new description for the HA Group

    .PARAMETER Mode
        The mode to update the HA Group to

    .PARAMETER PrimaryNode
        The hostname or FQDN of the primary BloxOneDDI Host to update

    .PARAMETER SecondaryNode
        The hostname or FQDN of the secondary BloxOneDDI Host to update

    .PARAMETER Tags
        Any tags you want to apply to the HA Group

    .PARAMETER Object
        The HA Group Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
          PS> Set-B1HAGroup -Name "MyHAGroup" -Mode "active-passive" -PrimaryNode "bloxoneddihost1.mydomain.corp" -SecondaryNode "bloxoneddihost2.mydomain.corp" -Description "DHCP HA Group" -Tags @{"TagName"="TagValue"}

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(ParameterSetName="Default",Mandatory=$true)]
        [String]$Name,
        [String]$NewName,
        [String]$Description,
        [ValidateSet("active-active", "active-passive", "advanced-active-passive")]
        [String]$Mode,
        [String]$PrimaryNode,
        [String]$SecondaryNode,
        [System.Object]$Tags,
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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/ha_group") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/ha_group' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1HAGroup -Name $Name -Strict -Fields name,mode,hosts,comment,tags
            if (!($Object)) {
                Write-Error "Unable to find HA Group: $($Name)"
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty id,ip_space,created_at,updated_at,anycast_config_id
        $NewObj.hosts = $NewObj.hosts | Select-Object host,role

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($Mode) {
            $NewObj.mode = $Mode
            if ($Mode -eq "active-active") {
                $NewObj.hosts[0].role = "active"
                $NewObj.hosts[1].role = "active"
            }
            else {
                $NewObj.hosts[0].role = "active"
                $NewObj.hosts[1].role = "passive"
            }
        }
        if ($PrimaryNode) {
            if ($PrimaryHost = (Get-B1Host -Name $PrimaryNode -Strict)) {
                $PrimaryHostConfig = @{
                    "host" = "dhcp/host/$($PrimaryHost.legacy_id)"
                    "role" = "active"
                }
                $NewObj.hosts[0] = $PrimaryHostConfig
            } else {
                Write-Error "Unable to find B1 Host: $($PrimaryNode)"
                return $null
            }
        }
        if ($SecondaryNode) {
            if ($SecondaryHost = (Get-B1Host -Name $SecondaryNode -Strict)) {
                $NewObj.hosts[1].host = "dhcp/host/$($SecondaryHost.legacy_id)"
                if (!($Mode)) {
                    $Mode = $NewObj.mode
                }
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
                $NewObj.hosts[1] = $SecondaryHostConfig
            } else {
                Write-Error "Unable to find B1 Host: $($SecondaryNode)"
                return $null
            }
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}
