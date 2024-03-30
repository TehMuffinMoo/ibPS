function Get-B1AddressNextAvailable {
    <#
    .SYNOPSIS
        Gets one or more next available IP addresses from IPAM

    .DESCRIPTION
        This function is used to get one or more next available IP addresses from IPAM based on the criteria entered

    .PARAMETER ParentAddressBlock
        Parent Address Block in CIDR format (i.e 10.0.0.0/8)

        -ParentAddressBlock and -ParentSubnet are mutually exclusive parameters.

    .PARAMETER ParentSubnet
        Parent Subnet in CIDR format (i.e 10.0.0.0/8)

        -ParentSubnet and -ParentAddressBlock are mutually exclusive parameters.

    .PARAMETER Space
        Use the -Space parameter to determine which IP Space the parent Subnet or Address Block is in

    .PARAMETER Count
        The desired number of IP addresses to return

    .PARAMETER Contiguous
        Use the -Contiguous switch to indicate whether the IP addresses should belong to a contiguous block. Default is false

    .PARAMETER ID
        The ID of the Subnet or Address Block. This accepts pipeline input from Get-B1AddressBlock & Get-B1Subnet

    .EXAMPLE
        PS> Get-B1Subnet -Subnet 10.37.34.0/24 | Get-B1AddressNextAvailable -Count 10 -Contiguous | ft address

            address
            -------
            10.37.34.16
            10.37.34.17
            10.37.34.18
            10.37.34.19
            10.37.34.20
            10.37.34.21
            10.37.34.22
            10.37.34.23
            10.37.34.24
            10.37.34.25
    
    .EXAMPLE
        PS> Get-B1AddressBlock -Subnet 10.57.124.0/24 | Get-B1AddressNextAvailable -Count 5 -Contiguous | ft address

            address
            -------
            10.57.124.83
            10.57.124.84
            10.57.124.85
            10.57.124.86
            10.57.124.87

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Int]$Count = 1,
      [Switch]$Contiguous = $false,
      [Parameter(ParameterSetName="Address Block",Mandatory=$true)]
      [String]$ParentAddressBlock,
      [Parameter(ParameterSetName="Subnet",Mandatory=$true)]
      [String]$ParentSubnet,
      [Parameter(ParameterSetName="Address Block",Mandatory=$true)]
      [Parameter(ParameterSetName="Subnet",Mandatory=$true)]
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
            $PermittedInputs = "address_block","subnet","range"
            if (($ID.split('/')[1]) -notin $PermittedInputs) {
                Write-Error "Error. Unsupported pipeline object. The input must be of type: address_block or subnet"
                return $null
            } else {
                $Parent = [PSCustomObject]@{
                    id = $ID
                }
            }
        } else {
            if ($ParentAddressBlock) {
                $ParentCIDRPair = $ParentAddressBlock.Split("/")
                $Parent = Get-B1AddressBlock -Subnet $ParentCIDRPair[0] -CIDR $ParentCIDRPair[1] -Space $Space
                if (!($ParentCIDRPair[0] -and $ParentCIDRPair[1])) {
                    Write-Error "Invalid Parent Address Block format: $ParentAddressBlock. Ensure you enter it as a full IP including the CIDR notation (i.e 10.192.0.0/12)" -ForegroundColor Red
                    return $null
                }
            } elseif ($ParentSubnet) {
                $ParentCIDRPair = $ParentSubnet.Split("/")
                $Parent = Get-B1Subnet -Subnet $ParentCIDRPair[0] -CIDR $ParentCIDRPair[1] -Space $Space
                if (!($ParentCIDRPair[0] -and $ParentCIDRPair[1])) {
                    Write-Error "Invalid Parent Subnet format: $ParentAddressBlock. Ensure you enter it as a full IP including the CIDR notation (i.e 10.192.0.0/12)" -ForegroundColor Red
                    return $null
                }
            }
        }



        if ($Parent) {
            Query-CSP -Method "GET" -Uri "$($Parent.id)/nextavailableip?contiguous=$($Contiguous.ToString())&count=$Count" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Write-Host "Unable to find Parent: $($ParentAddressBlock)$($ParentSubnet)" -ForegroundColor Red
        }
    }
}