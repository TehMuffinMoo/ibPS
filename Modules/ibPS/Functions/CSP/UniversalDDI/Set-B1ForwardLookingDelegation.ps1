function Set-B1ForwardLookingDelegation {
    <#
    .SYNOPSIS
        Updates an existing forward looking delegation in Universal DDI IPAM

    .DESCRIPTION
        This function is used to update an existing forward looking delegation in Universal DDI IPAM

    .PARAMETER Subnet
        The subnet of the forward looking delegation you want to update in CIDR notation

    # .PARAMETER Realm
    #     The name of the forward looking delegation realm the forward looking delegation is associated with

    .PARAMETER Name
        The name of the forward looking delegation you want to update

    .PARAMETER NewName
        Use -NewName to update the name of the forward looking delegation

    .PARAMETER Description
        The new description for the forward looking delegation

    .PARAMETER CIDR
        The new CIDR of the forward looking delegation you are updating

    .PARAMETER Tags
        A list of tags to update on the forward looking delegation. This will replace existing tags, so would normally be a combined list of existing and new tags

    .PARAMETER Object
        The Forward Looking Delegation Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1ForwardLookingDelegation -Subnet '10.1.5.0/24' -NewName "New name" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}

    .EXAMPLE
        PS> Get-B1ForwardLookingDelegation -Name "Delegation-1" -Realm "Realm-1" | Set-B1ForwardLookingDelegation -CIDR 15 -Description "Updated to /15" -Tags @{Environment="Test";Owner="Admin"}

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
        $ObjectExclusions = @('id','address','created_at','protocol','state','region','parent','metadata','updated_at','network_compliant','federated_pool_id')
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/forward_looking_delegation") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/forward_looking_delegation' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1ForwardLookingDelegation -Subnet $Subnet -Name $Name -Strict # -Realm $Realm - Realm check temporarily disabled due to backend API issue.
            if (!($Object)) {
                if ($Name) {
                    Write-Error "Unable to find Forward Looking Delegation: $($Name)"
                } else {
                    Write-Error "Unable to find Forward Looking Delegation for Subnet: $($Subnet)"
                }
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Forward Looking Delegations were found, to update more than one Forward Looking Delegation you should pass those objects using pipe instead."
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
        if($PSCmdlet.ShouldProcess("Update Forward Looking Delegation:`n$(JSONPretty($JSON))","Update Forward Looking Delegation: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}
