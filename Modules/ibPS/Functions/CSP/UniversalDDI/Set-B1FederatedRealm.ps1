function Set-B1FederatedRealm {
    <#
    .SYNOPSIS
        Updates an existing federated realm in Universal DDI IPAM

    .DESCRIPTION
        This function is used to update an existing federated realm in Universal DDI IPAM

    .PARAMETER Name
        The name of the federated realm you want to update

    .PARAMETER NewName
        Use -NewName to update the name of the federated realm

    .PARAMETER Description
        The new description for the federated realm

    .PARAMETER Tags
        A list of tags to update on the federated realm. This will replace existing tags, so would normally be a combined list of existing and new tags

    .PARAMETER Object
        The Federated Realm Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1FederatedRealm -Name "Realm-1" -NewName "Realm-2" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}

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
        $ObjectExclusions = @('id','allocation_v4','created_at','metadata','provider','region','updated_at','utilization','utilization_v6')
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "federation/federated_realm") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'federation/federated_realm' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1FederatedRealm -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find Federated Realm: $($Name)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Federated Realms were found, to update more than one Federated Realm you should pass those objects using pipe instead."
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
        if($PSCmdlet.ShouldProcess("Update Federated Realm:`n$(JSONPretty($JSON))","Update Federated Realm: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}
