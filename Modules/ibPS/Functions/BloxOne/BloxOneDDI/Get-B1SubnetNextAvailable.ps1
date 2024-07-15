function Get-B1SubnetNextAvailable {
    <#
    .SYNOPSIS
        Gets one or more next available subnets from IPAM

    .DESCRIPTION
        This function is used to get one or more next available subnets from IPAM based on the criteria entered

    .PARAMETER ParentAddressBlock
        Parent Address Block in CIDR format (i.e 10.0.0.0/8)

    .PARAMETER Space
        Use the -Space parameter to determine which IP Space the parent is located in

    .PARAMETER CIDRSize
        The size of the desired subnet specified using CIDR suffix

    .PARAMETER Count
        The desired number of subnets to return

    .PARAMETER ID
        The ID of the Parent Address Block. This accepts pipeline input from Get-B1AddressBlock

    .EXAMPLE
        PS> Get-B1SubnetNextAvailable -ParentAddressBlock 10.0.0.0/16 -Space my-ipspace -CIDRSize 24 -Count 5 | ft address,cidr

        address  cidr
        -------  ----
        10.0.0.0   24
        10.0.2.0   24
        10.0.3.0   24
        10.0.4.0   24
        10.0.5.0   24

    .EXAMPLE
        PS> Get-B1AddressBlock -Subnet 10.10.10.0/16 -Space my-ipspace | Get-B1SubnetNextAvailable -CIDRSize 24 -Count 5 | ft address,cidr

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
      [Int]$CIDRSize,
      [Int]$Count = 1,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$ParentAddressBlock,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Space,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName = "ID",
        Mandatory=$true
      )]
      [String[]]$ID
    )

    process {
        if ($ID) {
            if (($ID.split('/')[1]) -ne "address_block") {
                Write-Error "Error. Unsupported pipeline object. The input must be of type: address_block"
                return $null
            } else {
                $Parent = [PSCustomObject]@{
                    id = $ID
                }
            }
        } else {
            $ParentAddressBlockCIDRPair = $ParentAddressBlock.Split("/")
            if ($ParentAddressBlockCIDRPair[0] -and $ParentAddressBlockCIDRPair[1]) {
                $Parent = Get-B1AddressBlock -Subnet $ParentAddressBlockCIDRPair[0] -CIDR $ParentAddressBlockCIDRPair[1] -Space $Space
            } else {
                Write-Host "Invalid Parent Address Block format: $ParentAddressBlock. Ensure you enter it as a full IP including the CIDR notation (i.e 10.192.0.0/12)" -ForegroundColor Red
            }
        }

        if ($Parent) {
            Invoke-CSP -Method "GET" -Uri "$($Parent.id)/nextavailablesubnet?cidr=$CIDRSize&count=$Count" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Write-Host "Unable to find Parent Address Block: $ParentAddressBlock" -ForegroundColor Red
        }
    }
}