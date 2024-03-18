function Get-NetworkInfo {
    <#
    .SYNOPSIS
        Used to generate commonly used network information from a subnet
  
    .DESCRIPTION
        This function is used to generate commonly used network information from a subnet
  
        This accepts pipeline input from Get-B1Subnet & Get-B1AddressBlock
  
    .PARAMETER IP
        The network IP of the subnet
  
        This parameter is also aliased to -Address
  
    .PARAMETER MaskBits
        The Mask Bits / CIDR of the subnet
  
        This parameter is also aliased to -CIDR
  
    .PARAMETER GatewayAddress
        When using the -GatewayAddress parameter, an optional Gateway value will be added to the results. Available options are First & Last.
  
    .PARAMETER Force
        Subnets larger than a /16 will take a longer time to generate the list of host addresses. Using -Force will override this limit and generate them anyway.
  
    .EXAMPLE
        PS> Get-NetworkInfo 10.10.10.0/24          
                                                                                                                          
        IPAddress        : 10.10.10.0
        MaskBits         : 24
        NetworkAddress   : 10.10.10.0
        BroadcastAddress : 10.10.10.255
        SubnetMask       : 255.255.255.0
        NetworkClass     : A
        Range            : 10.10.10.0 ~ 10.10.10.255
        HostAddresses    : {10.10.10.1, 10.10.10.2, 10.10.10.3, 10.10.10.4…}
        HostAddressCount : 254
  
    .EXAMPLE
        PS> Get-B1Subnet -Subnet 10.37.34.0 -CIDR 27 | Get-NetworkInfo
                                                                                                                          
        IPAddress        : 10.37.34.0
        MaskBits         : 27
        NetworkAddress   : 10.37.34.0
        BroadcastAddress : 10.37.34.31
        SubnetMask       : 255.255.255.224
        NetworkClass     : A
        Range            : 10.37.34.0 ~ 10.37.34.31
        HostAddresses    : {10.37.34.1, 10.37.34.2, 10.37.34.3, 10.37.34.4…}
        HostAddressCount : 30
  
    .EXAMPLE
        PS> Get-B1AddressBlock -Limit 1 | Get-NetworkInfo                                                                                                                                                                 
                                                                                                                          
        IPAddress        : 10.41.163.0
        MaskBits         : 24
        NetworkAddress   : 10.41.163.0
        BroadcastAddress : 10.41.163.255
        SubnetMask       : 255.255.255.0
        NetworkClass     : A
        Range            : 10.41.163.0 ~ 10.41.163.255
        HostAddresses    : {10.41.163.1, 10.41.163.2, 10.41.163.3, 10.41.163.4…}
        HostAddressCount : 254
   
    .LINK
      https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
    #>
    param ( 
        [parameter(Mandatory=$true,ValueFromPipelineByPropertyName)]
        [Alias('Address')]
        [string]
        $IP,
        [parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(0, 32)]
        [Alias('CIDR')]
        [int]
        $MaskBits,
        [ValidateSet('First','Last')]
        $GatewayAddress,
  
        [switch]
        $Force
    )
    process {
        if ($PSBoundParameters.ContainsKey('MaskBits')) { 
            $Mask = $MaskBits 
        }
  
        if ($IP -match '/\d') { 
            $IPandMask = $IP -Split '/' 
            $IP = $IPandMask[0]
            $Mask = $IPandMask[1]
        }
        
        $Class = Get-NetworkClass -IP $IP
  
        if ($Mask -notin 0..32) {
  
            $Mask = switch ($Class) {
                'A' { 8 }
                'B' { 16 }
                'C' { 24 }
                default { 
                    throw "Subnet mask size was not specified and could not be inferred because the address is Class $Class." 
                }
            }
  
            Write-Warning "Subnet mask size was not specified. Using default subnet size for a Class $Class network of /$Mask."
        }
  
        $IPAddr = [ipaddress]::Parse($IP)
        $MaskAddr = [ipaddress]::Parse((Convert-Int64toIP -int ([convert]::ToInt64(("1" * $Mask + "0" * (32 - $Mask)), 2))))        
        $NetworkAddr = [ipaddress]($MaskAddr.address -band $IPAddr.address) 
        $BroadcastAddr = [ipaddress](([ipaddress]::parse("255.255.255.255").address -bxor $MaskAddr.address -bor $NetworkAddr.address))
        
        $HostStartAddr = (Convert-IPtoInt64 -ip $NetworkAddr.ipaddresstostring) + 1
        $HostEndAddr = (Convert-IPtoInt64 -ip $broadcastaddr.ipaddresstostring) - 1
  
        $HostAddressCount = ($HostEndAddr - $HostStartAddr) + 1
        
        if ($Mask -ge 16 -or $Force) {
            
            Write-Progress "Calculating host addresses for $NetworkAddr/$Mask.."
  
            $HostAddresses = for ($i = $HostStartAddr; $i -le $HostEndAddr; $i++) {
                Convert-Int64toIP -int $i
            }
  
            Write-Progress -Completed -Activity "Clear Progress Bar"
        }
        else {
            Write-Warning "Host address enumeration was not performed because it would take some time for a /$Mask subnet. `nUse -Force if you want it to occur."
        }
  
        $NetworkInfo = [pscustomobject]@{
            IPAddress        = $IPAddr
            MaskBits         = $Mask
            NetworkAddress   = $NetworkAddr
            BroadcastAddress = $broadcastaddr
            SubnetMask       = $MaskAddr
            NetworkClass     = $Class
            Range            = "$networkaddr ~ $broadcastaddr"
            HostAddresses    = $HostAddresses
            HostAddressCount = $HostAddressCount
        }
        
        if ($GatewayAddress) {
          Switch($GatewayAddress) {
            "First" {
              $NetworkInfo | Add-Member -MemberType NoteProperty -Name Gateway -Value (Convert-Int64toIP -Int $HostStartAddr)
            }
            "Last" {
              $NetworkInfo | Add-Member -MemberType NoteProperty -Name Gateway -Value (Convert-Int64toIP -Int $HostEndAddr)
            }
          }
        }
  
        return $NetworkInfo
    }
  }