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

    .PARAMETER id
        The id of the subnet. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global"

    .EXAMPLE
        PS> Get-B1Subnet -Subnet 10.0.0.0 -CIDR 24 -Space "Global" | Remove-B1Subnet
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Subnet,
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Name,
      [Parameter(ParameterSetName="noID",Mandatory=$true)]
      [String]$Space,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {

      if ($id) {
        $SubnetInfo = Get-B1Subnet -id $id
      } else {
        $SubnetInfo = Get-B1Subnet -Subnet $Subnet -CIDR $CIDR -Space $Space -Name $Name -Strict
      }

      if (($SubnetInfo | measure).Count -gt 1) {
        Write-Host "More than one subnets returned. These will not be removed. Please pipe Get-B1Subnet into Remove-B1Subnet to remove multiple objects." -ForegroundColor Red
        $SubnetInfo | Format-Table -AutoSize
      } elseif (($SubnetInfo | measure).Count -eq 1) {
        Write-Host "Removing Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr).." -ForegroundColor Yellow
        Query-CSP -Method "DELETE" -Uri $($SubnetInfo.id) -Data $null | Out-Null
        $SI = Get-B1Subnet -id $($SubnetInfo.id)
        if ($SI) {
          Write-Host "Failed to remove Subnet: $($SI.Address)/$($SI.cidr)" -ForegroundColor Red
        } else {
          Write-Host "Successfully removed Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr)" -ForegroundColor Green
        }
      } else {
        Write-Host "Subnet does not exist." -ForegroundColor Gray
      }
    }
}