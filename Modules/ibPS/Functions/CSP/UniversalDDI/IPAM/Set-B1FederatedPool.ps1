function Set-B1FederatedPool {
    <#
    .SYNOPSIS
        Updates an existing federated pool in Universal DDI IPAM

    .DESCRIPTION
        This function is used to update an existing federated pool in Universal DDI IPAM

    .PARAMETER Name
        The name of the federated pool you want to update

    .PARAMETER Realm
        The name of the federated realm the federated pool is associated with

    .PARAMETER NewName
        Use -NewName to update the name of the federated pool

    .PARAMETER Description
        The new description for the federated pool

    .PARAMETER Tags
        A list of tags to update on the federated pool. This will replace existing tags, so would normally be a combined list of existing and new tags

    .PARAMETER Object
        The Federated Pool Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1FederatedPool -Name "Pool-1" -Realm "Realm-1" -NewName "Pool-2" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}

    .EXAMPLE
        PS> Get-B1FederatedPool -Name "Pool-1" -Realm "Realm-1" | Set-B1FederatedPool -NewName "Pool-2" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}

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
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Realm,
      [String]$NewName,
      [String]$Description,
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
        $ObjectExclusions = @('id','allocation','created_at','federated_realm','metadata','parent','protocol','provider','region','state','updated_at','utilization','utilization_v6')
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/federated_pool") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/federated_pool' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1FederatedPool -Name $Name -Realm $Realm -Strict
            if (!($Object)) {
                Write-Error "Unable to find Federated Pool: $($Name)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Federated Pools were found, to update more than one Federated Pool you should pass those objects using pipe instead."
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
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress
        if($PSCmdlet.ShouldProcess("Update Federated Pool:`n$(JSONPretty($JSON))","Update Federated Pool: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}
