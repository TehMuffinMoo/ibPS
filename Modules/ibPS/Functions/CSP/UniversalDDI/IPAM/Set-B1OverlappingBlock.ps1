function Set-B1OverlappingBlock {
    <#
    .SYNOPSIS
        Updates an existing overlapping block in Universal DDI IPAM

    .DESCRIPTION
        This function is used to update an existing overlapping block in Universal DDI IPAM

    .PARAMETER Subnet
        The subnet of the overlapping block you want to update in CIDR notation

    # .PARAMETER Realm
    #     The name of the overlapping realm the overlapping block is associated with

    .PARAMETER Name
        The name of the overlapping block you want to update

    .PARAMETER NewName
        Use -NewName to update the name of the overlapping block

    .PARAMETER Description
        The new description for the overlapping block

    .PARAMETER CIDR
        The new CIDR of the overlapping block you are updating

    .PARAMETER Tags
        A list of tags to update on the overlapping block. This will replace existing tags, so would normally be a combined list of existing and new tags

    .PARAMETER Object
        The Overlapping Block Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1OverlappingBlock -Subnet '10.1.5.0/24' -NewName "New name" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}

    .EXAMPLE
        PS> Get-B1OverlappingBlock -Name "Block-1" -Realm "Realm-1" | Set-B1OverlappingBlock -CIDR 15 -Description "Updated to /15" -Tags @{Environment="Test";Owner="Admin"}

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
        $ObjectExclusions = @('id','address','created_at','protocol','state','region','parent','metadata','updated_at','network_compliant','federated_pool_id')
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/overlapping_block") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/overlapping_block' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1OverlappingBlock -Subnet $Subnet -Name $Name -Strict # -Realm $Realm - Realm check temporarily disabled due to backend API issue.
            if (!($Object)) {
                if ($Name) {
                    Write-Error "Unable to find Overlapping Block: $($Name)"
                } else {
                    Write-Error "Unable to find Overlapping Block for Subnet: $($Subnet)"
                }
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Overlapping Blocks were found, to update more than one Overlapping Block you should pass those objects using pipe instead."
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
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress
        if($PSCmdlet.ShouldProcess("Update Overlapping Block:`n$(JSONPretty($JSON))","Update Overlapping Block: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}
