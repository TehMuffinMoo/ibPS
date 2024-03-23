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

    .EXAMPLE
        PS> Get-B1AddressBlockNextAvailable -ParentAddressBlock 10.0.0.0/16 -Space my-ipspace -CIDRSize 24 -Count 5 | ft address,cidr
        
        address  cidr
        -------  ----
        10.0.0.0   24
        10.0.2.0   24
        10.0.3.0   24
        10.0.4.0   24
        10.0.5.0   24
    
    .EXAMPLE
        PS> Get-B1AddressBlock -Subnet 10.10.10.0/16 -Space my-ipspace | Get-B1AddressBlockNextAvailable -CIDRSize 29 -Count 2
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
            $PermittedInputs = "address_block","subnet"
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
            Write-Host "$($Parent.id)/nextavailableip?contiguous=$($Contiguous.ToString())&count=$Count"
            Query-CSP -Method "GET" -Uri "$($Parent.id)/nextavailableip?contiguous=$($Contiguous.ToString())&count=$Count" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Write-Host "Unable to find Parent: $($ParentAddressBlock)$($ParentSubnet)" -ForegroundColor Red
        }
    }
}