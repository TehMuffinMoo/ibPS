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

    .PARAMETER Space
        The IPAM space where the subnet is located

    .PARAMETER Name
        The name of the subnet to remove

    .Example
        Remove-B1Subnet -Subnet 10.0.0.1 -CIDR 24 -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Subnet,
      [Parameter(Mandatory=$true)]
      [ValidateRange(0,32)]
      [Int]$CIDR,
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Space
    )

    $SubnetInfo = Get-B1Subnet -Subnet $Subnet -CIDR $CIDR -Space $Space -Name $Name -Strict

    if (($SubnetInfo | measure).Count -gt 1) {
        Write-Host "More than one subnets returned. These will not be removed." -ForegroundColor Red
        $SubnetInfo | ft -AutoSize
    } elseif (($SubnetInfo | measure).Count -eq 1) {
        Write-Host "Removing Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr).." -ForegroundColor Yellow
        $Result = Query-CSP -Method "DELETE" -Uri $($SubnetInfo.id) -Data $null
        if (Get-B1Subnet -Subnet $($SubnetInfo.Address) -CIDR $CIDR -Space $Space) {
            Write-Host "Failed to remove Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr)" -ForegroundColor Red
        } else {
            Write-Host "Successfully removed Subnet: $($SubnetInfo.Address)/$($SubnetInfo.cidr)" -ForegroundColor Green
        }
    } else {
        Write-Host "Subnet does not exist." -ForegroundColor Gray
    }
}