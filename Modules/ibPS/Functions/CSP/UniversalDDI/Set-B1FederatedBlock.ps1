function Set-B1FederatedBlock {
    <#
    .SYNOPSIS
        Updates an existing federated block in Universal DDI IPAM

    .DESCRIPTION
        This function is used to update an existing federated block in Universal DDI IPAM

    .PARAMETER Subnet
        The subnet of the federated block you want to update in CIDR notation

    # .PARAMETER Realm
    #     The name of the federated realm the federated block is associated with

    .PARAMETER Name
        The name of the federated block you want to update

    .PARAMETER NewName
        Use -NewName to update the name of the federated block

    .PARAMETER Description
        The new description for the federated block

    .PARAMETER CIDR
        The new CIDR of the federated block you are updating

    .PARAMETER DefaultPrefixLength
        The default prefix length of the Federated Block you are updating

    .PARAMETER MinimumPrefixLength
        The minimum prefix length allowed under the Federated Block you are updating.

    .PARAMETER MaximumPrefixLength
        The maximum prefix length allowed under the Federated Block you are updating.

    .PARAMETER Tags
        A list of tags to update on the federated block. This will replace existing tags, so would normally be a combined list of existing and new tags

    .PARAMETER Object
        The Federated Block Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1FederatedBlock -Subnet '10.1.5.0/24' -NewName "New name" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}

    .EXAMPLE
        PS> Get-B1FederatedBlock -Name "Block-1" -Realm "Realm-1" | Set-B1FederatedBlock -CIDR 15 -Description "Updated to /15" -Tags @{Environment="Test";Owner="Admin"}

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(ParameterSetName="Subnet")]
        [String]$Subnet,
        # [Parameter(ParameterSetName="Name",Mandatory=$true)]
        # [Parameter(ParameterSetName="Subnet",Mandatory=$true)]
        # [String]$Realm,
        [Parameter(ParameterSetName="Name")]
        [String]$Name,
        [String]$NewName,
        [String]$Description,
        [ValidateRange(0,32)]
        [Int]$CIDR,
        [ValidateScript({
            if ($_ -lt $CIDR -or $_ -gt 32) {
                throw "DefaultPrefixLength must be between $CIDR and 32."
            }
            $true
        })]
        [Int]$DefaultPrefixLength,

        [ValidateScript({
            if ($_ -lt $CIDR -or $_ -gt 32) {
                throw "MinimumPrefixLength must be between $CIDR and 32."
            }
            $true
        })]
        [Int]$MinimumPrefixLength,

        [ValidateScript({
            if ($_ -lt $CIDR -or $_ -gt 32) {
                throw "MaximumPrefixLength must be between $CIDR and 32."
            }
            $true
        })]
        [Int]$MaximumPrefixLength,
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
        $ObjectExclusions = @('id','address','allocation_v4','created_at','protocol','state','region','parent','utilization','utilization_v6','metadata','updated_at','network_compliant')
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/federated_block") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/federated_block' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1FederatedBlock -Subnet $Subnet -Name $Name -Strict # -Realm $Realm - Realm check temporarily disabled due to backend API issue.
            if (!($Object)) {
                if ($Name) {
                    Write-Error "Unable to find Federated Block: $($Name)"
                } else {
                    Write-Error "Unable to find Federated Block for Subnet: $($Subnet)"
                }
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Federated Blocks were found, to update more than one Federated Block you should pass those objects using pipe instead."
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty $ObjectExclusions

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($CIDR) {
            $NewObj.cidr = $CIDR
        }
        if ($DefaultPrefixLength) {
            if (-not $NewObj.network_compliance.default_netmask_length) {
                $NewObj.network_compliance | Add-Member -MemberType NoteProperty -Name "default_netmask_length" -Value $DefaultPrefixLength
            } else {
                $NewObj.network_compliance.default_netmask_length = $DefaultPrefixLength
            }
        }
        if ($MinimumPrefixLength) {
            if (-not $NewObj.network_compliance.minimum_netmask_length) {
                $NewObj.network_compliance | Add-Member -MemberType NoteProperty -Name "minimum_netmask_length" -Value $MinimumPrefixLength
            } else {
                $NewObj.network_compliance.minimum_netmask_length = $MinimumPrefixLength
            }
        }
        if ($MaximumPrefixLength) {
            if (-not $NewObj.network_compliance.maximum_netmask_length) {
                $NewObj.network_compliance | Add-Member -MemberType NoteProperty -Name "maximum_netmask_length" -Value $MaximumPrefixLength
            } else {
                $NewObj.network_compliance.maximum_netmask_length = $MaximumPrefixLength
            }
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress
        if($PSCmdlet.ShouldProcess("Update Federated Block:`n$(JSONPretty($JSON))","Update Federated Block: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}
