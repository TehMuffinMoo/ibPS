function Set-B1Range {
    <#
    .SYNOPSIS
        Updates an existing DHCP Range in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to update an existing DHCP Range in BloxOneDDI IPAM

    .PARAMETER StartAddress
        The start address of the DHCP Range you want to update

    .PARAMETER EndAddress
        The end address of the DHCP Range you want to update

    .PARAMETER Space
        The IPAM space where the DHCP Range is located

    .PARAMETER Name
        The name of the range. If more than one range object within the selected space has the same name, this will error and you will need to use Pipe as shown in the second example.

    .PARAMETER NewName
        Use -NewName to update the name of the range

    .PARAMETER Description
        The description to update the DHCP Range to

    .PARAMETER HAGroup
        The name of the HA group to apply to this DHCP Range. This will overwrite the existing HA Group. Using the value 'None' will clear the HA Group.

    .PARAMETER Tags
        Any tags you want to apply to the DHCP Range. This will overwrite existing tags.

    .PARAMETER Object
        The Range Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 -Description "Some Description" -Tags @{"siteCode"="12345"}

    .EXAMPLE
        PS> Get-B1Range -StartAddress 10.250.20.20 -EndAddress 10.250.20.100 | Set-B1Range -Description "Some Description" -Tags @{"siteCode"="12345"}

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
      [Parameter(ParameterSetName="Range",Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(ParameterSetName="Range",Mandatory=$false)]
      [String]$EndAddress,
      [Parameter(ParameterSetName="Range",Mandatory=$true)]
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Space,
      [Parameter(ParameterSetName="Name",Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [String]$HAGroup,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    begin {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($HAGroup) {
            $HAGroupID = (Get-B1HAGroup -Name $HAGroup -Strict).id
            if (!($HAGroupID)) {
                Write-Error "Unable to find HA Group: $($HAGroup)"
                return $null
            }
        }
    }

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/range") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/range' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1Range -StartAddress $StartAddress -EndAddress $EndAddress -Space $Space -Name $Name
            if (!($Object)) {
                Write-Error "Unable to find DHCP Range: $($StartAddress) - $($EndAddress)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple Subnet were found, to update more than one Subnet you should pass those objects using pipe instead."
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty utilization,utilization_v6,id,inheritance_assigned_hosts,inheritance_parent,parent,protocol,space,inheritance_sources

        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($HAGroupID) {
            $NewObj.dhcp_host = $HAGroupID
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        if($PSCmdlet.ShouldProcess("Update DHCP Range:`n$(JSONPretty($JSON))","Update DHCP Range: $($Object.start) - $($Object.end) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}