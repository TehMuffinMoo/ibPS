function Remove-B1AddressBlock {
    <#
    .SYNOPSIS
        Removes an address block from Universal DDI IPAM

    .DESCRIPTION
        This function is used to remove an address block from Universal DDI IPAM

    .PARAMETER Subnet
        The network address of the address block you want to remove

    .PARAMETER CIDR
        The CIDR suffix of the address block you want to remove

    .PARAMETER Space
        The IPAM space where the address block is located

    .PARAMETER Recurse
        WARNING! Using -Recurse will move all child objects to the recycle bin. By default, child objects are re-parented.

    .PARAMETER NoWarning
        WARNING! This is very dangerous if used inappropriately.
        The -NoWarning parameter is there to be combined with -Recurse. When specified, using -Recurse will not prompt for confirmation before deleting.

    .PARAMETER Object
        The address block object. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

        WARNING! This is very dangerous if used inappropriately with -Recurse.

    .EXAMPLE
        PS> Remove-B1AddressBlock -Subnet "10.0.0.1" -CIDR "24" -Space "Global"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Subnet,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Space,
      [Switch]$Recurse,
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/address_block") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/address_block' objects as input"
            return $null
        }
    } else {
        $Object = Get-B1AddressBlock -Subnet $Subnet -CIDR $CIDR -Space $Space -Name $Name -Strict
        if (!($Object)) {
            Write-Error "Unable to find Address Block: $($Subnet)/$($CIDR) in Space: $($Space)"
            return $null
        }
        if ($Object.count -gt 1) {
            Write-Error "Multiple Address Blocks were found, to remove more than one Address Block you should pass those objects using pipe instead."
            return $null
        }
    }

    if ($Recurse -and -not $Force) {
        Write-Warning "WARNING! -Recurse will remove all child objects that exist within the Address Block: $Subnet/$CIDR. Are you sure you want to do this?" -WarningAction Inquire
        $URI = "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)?_options=recurse=true"
    } else {
        $URI = "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)"
    }

    if($PSCmdlet.ShouldProcess("$($Object.address)/$($Object.cidr) ($($Object.id))")){
      $null = Invoke-CSP -Method "DELETE" -Uri $URI | Out-Null
      $AB = Get-B1AddressBlock -id $($Object.id)
      if ($AB) {
        Write-Host "Failed to remove Address Block: $($AB.Address)/$($AB.cidr)" -ForegroundColor Red
      } else {
        Write-Host "Successfully removed Address Block: $($Object.Address)/$($Object.cidr)" -ForegroundColor Green
      }
    }
  }
}