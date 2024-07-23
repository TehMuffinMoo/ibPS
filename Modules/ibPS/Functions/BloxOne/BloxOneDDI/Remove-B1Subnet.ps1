function Remove-B1Subnet {
    <#
    .SYNOPSIS
        Removes a subnet from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to remove a subnet from BloxOneDDI IPAM

    .PARAMETER Subnet
        The network address of the subnet you want to remove

    .PARAMETER CIDR
        The CIDR suffix of the subnet you want to remove

    .PARAMETER Name
        The name of the subnet to remove

    .PARAMETER Space
        The IPAM space where the subnet is located

    .PARAMETER Object
        The subnet object to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global"

    .EXAMPLE
        PS> Get-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global" | Remove-B1Subnet

    .FUNCTIONALITY
        BloxOneDDI

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
      [String]$Name,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Space,
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
        if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/subnet") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/subnet' objects as input"
            return $null
        }
      } else {
        $Object = Get-B1Subnet -Subnet $Subnet -CIDR $CIDR -Space $Space -Name $Name -Strict
        if (!($Object)) {
            Write-Error "Unable to find Subnet: $($Subnet)/$($CIDR) in IP Space: $($Space)."
            return $null
        }
      }

      if($PSCmdlet.ShouldProcess("$($Object.address)/$($Object.cidr) ($($Object.id))")){
        Write-Host "Removing Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr).." -ForegroundColor Yellow
        Invoke-CSP -Method "DELETE" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($SubnetInfo.id)" -Data $null | Out-Null
        $SI = Get-B1Subnet -id $($SubnetInfo.id)
        if ($SI) {
          Write-Host "Failed to remove Subnet: $($SI.Address)/$($SI.cidr)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr)" -ForegroundColor Green
        }
      }
    }
}