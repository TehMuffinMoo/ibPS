function Get-B1AddressBlockNextAvailable {
    <#
    .SYNOPSIS
        Gets one or more next available address blocks from IPAM

    .DESCRIPTION
        This function is used to get one or more next available address blocks from IPAM based on the criteria entered

    .PARAMETER ParentAddressBlock
        Parent Address Block in CIDR format (i.e 10.0.0.0/8)

    .PARAMETER Space
        Use this parameter to filter the list of Address Blocks by Space

    .PARAMETER SubnetCIDRSize
        The size of the desired subnet specified using CIDR suffix

    .PARAMETER SubnetCount
        The desired number of subnets to return

    .EXAMPLE
        PS>  Get-B1AddressBlockNextAvailable -ParentAddressBlock 10.0.0.0/16 -Space mcox-ipspace -SubnetCIDRSize 24 -SubnetCount 5 | ft address,cidr
        
        address  cidr
        -------  ----
        10.0.0.0   24
        10.0.2.0   24
        10.0.3.0   24
        10.0.4.0   24
        10.0.5.0   24
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$ParentAddressBlock,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [Parameter(Mandatory=$true)]
      [Int]$SubnetCIDRSize,
      [Int]$SubnetCount = 1
    )

    $ParentAddressBlockCIDRPair = $ParentAddressBlock.Split("/")
    if ($ParentAddressBlockCIDRPair[0] -and $ParentAddressBlockCIDRPair[1]) {
        $Parent = Get-B1AddressBlock -Subnet $ParentAddressBlockCIDRPair[0] -CIDR $ParentAddressBlockCIDRPair[1] -Space $Space
        if ($Parent) {
            Query-CSP -Method "GET" -Uri "$($Parent.id)/nextavailableaddressblock?cidr=$SubnetCIDRSize&count=$SubnetCount" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Write-Host "Unable to find Parent Address Block: $ParentAddressBlock" -ForegroundColor Red
        }
    } else {
        Write-Host "Invalid Parent Address Block format: $ParentAddressBlock. Ensure you enter it as a full IP including the CIDR notation (i.e 10.192.0.0/12)" -ForegroundColor Red
    }
}