function Detect-OS {
  if ($PSVersionTable.PSVersion.ToString() -gt 6) {
    if ($IsWindows) {
      return "Windows"
    } elseif ($IsMacOS) {
      return "Mac"
    }
  } else {
    $Platform = [System.Environment]::OSVersion.Platform
    if ($Platform -like "Win*") {
      return "Windows"
    } elseif ($Platform -like "Unix*") {
      return "Unix"
    }
  }
}

function Combine-Filters {
    param(
    [parameter(Mandatory=$true)]  
    $Filters
    )
    $combinedFilter = $null
    $FilterCount = $Filters.Count
    switch ($Filters.GetType().FullName) {
      "System.Collections.ArrayList" {
        foreach ($filter in $Filters) {
          if ($FilterCount -le 1) {
              $combinedFilter += $Filter
          } else {
              $combinedFilter += $Filter+" and "
          }
          $FilterCount = $FilterCount - 1
        }
      }
      "System.Object[]" {
        foreach ($filter in $Filters) {
          if ($FilterCount -le 1) {
            $combinedFilter += "$($Filter.Property)$($Filter.Operator)`"$($Filter.Value)`""
          } else {
            $combinedFilter += "$($Filter.Property)$($Filter.Operator)`"$($Filter.Value)`" and "
          }
          $FilterCount = $FilterCount - 1
        }
      }
      "System.String" {
        return $Filters
      }
      default {
        Write-Error "Unsupported Filter input"
      }
    }
    return $combinedFilter
}

function ConvertTo-QueryString {
    param(
      [parameter(mandatory=$true)]
      [System.Collections.ArrayList]$Filters
    )
    $combinedFilter = $null
    $FilterCount = $Filters.Count
    foreach ($filter in $Filters) {
        if ($FilterCount -le 1) {
            $combinedFilter += $Filter
        } else {
            $combinedFilter += $Filter+"&"
        }
        $FilterCount = $FilterCount - 1
    }
    $combinedFilter = "?$combinedFilter"
    return $combinedFilter
}

function Match-Type {
    param(
      [parameter(mandatory=$true)]
      [bool]$Strict
    )
	if ($Strict) {
        $MatchType = "=="
    } else {
        $MatchType = "~"
    }
    return $MatchType
}

function Convert-CIDRToNetmask {
  param(
    [parameter(Mandatory=$true)]
    [ValidateRange(0,32)]
    [Int] $MaskBits
  )
  $mask = ([Math]::Pow(2, $MaskBits) - 1) * [Math]::Pow(2, (32 - $MaskBits))
  $bytes = [BitConverter]::GetBytes([UInt32] $mask)
  (($bytes.Count - 1)..0 | ForEach-Object { [String] $bytes[$_] }) -join "."
}

function Test-NetmaskString {
  param(
    [parameter(Mandatory=$true)]
    [String] $MaskString
  )
  $validBytes = '0|128|192|224|240|248|252|254|255'
  $maskPattern = ('^((({0})\.0\.0\.0)|'      -f $validBytes) +
         ('(255\.({0})\.0\.0)|'      -f $validBytes) +
         ('(255\.255\.({0})\.0)|'    -f $validBytes) +
         ('(255\.255\.255\.({0})))$' -f $validBytes)
  $MaskString -match $maskPattern
}

function Convert-NetmaskToCIDR {
  param(
    [parameter(Mandatory=$true)]
    [ValidateScript({Test-NetmaskString $_})]
    [String] $MaskString
  )
  $mask = ([IPAddress] $MaskString).Address
  for ( $bitCount = 0; $mask -ne 0; $bitCount++ ) {
    $mask = $mask -band ($mask - 1)
  }
  $bitCount
}

$CompositeStateSpaces = @(
    @{
        "Application" = "DFP"
        "FriendlyName" = "DNS Forwarding Proxy"
        "AppType" = "1"
        "Composite" = "9"
        "Service_Type" = "dfp"
    },
    @{
        "Application" = "DNS"
        "FriendlyName" = "DNS"
        "AppType" = "2"
        "Composite" = "12"
        "Service_Type" = "dns"
    },
    @{
        "Application" = "DHCP"
        "FriendlyName" = "DHCP"
        "AppType" = "3"
        "Composite" = "15"
        "Service_Type" = "dhcp"
    },
    @{
        "Application" = "CDC"
        "FriendlyName" = "Data Connector"
        "AppType" = "7"
        "Composite" = "24"
        "Service_Type" = "cdc"
    },
    @{
        "Application" = "AnyCast"
        "FriendlyName" = "AnyCast"
        "AppType" = "9"
        "Composite" = "30"
        "Service_Type" = "anycast"
    },
    @{
        "Application" = "NGC"
        "FriendlyName" = "NIOS Grid Connector"
        "AppType" = "10"
        "Composite" = "34"
        "Service_Type" = "orpheus"
    },
    @{
        "Application" = "MSADC"
        "FriendlyName" = "MS AD Collector"
        "AppType" = "12"
        "Composite" = "40"
        "Service_Type" = "msad"
    },
    @{
        "Application" = "AAUTH"
        "FriendlyName" = "Access Authentication"
        "AppType" = "13"
        "Composite" = "43"
        "Service_Type" = "authn"
    },
    @{
        "Application" = "NTP"
        "FriendlyName" = "NTP"
        "AppType" = "20"
        "Composite" = "64"
        "Service_Type" = "ntp"
    }
) | ConvertTo-Json | ConvertFrom-Json

function Get-NetworkInfo {
  <#
    .LINK
      https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
  #>
  param ( 
      [parameter(ValueFromPipeline)]
      [string]
      $IP,
      [ValidateRange(0, 32)]
      [Alias('CIDR')]
      [int]
      $MaskBits,

      [switch]
      $Force
  )
  process {

      if ($PSBoundParameters.ContainsKey('MaskBits')) { 
          $Mask = $MaskBits 
      }

      if (-not $IP) { 
          $LocalIP = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -ne 'WellKnown' })

          $IP = $LocalIP.IPAddress
          If ($Mask -notin 0..32) { $Mask = $LocalIP.PrefixLength }
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

      [pscustomobject]@{
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
  }
}

function Convert-Int64toIP ([int64]$int) {
  <#
    .LINK
      https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Private%5CConvert-Int64toIP.ps1
  #>
  (([math]::truncate($int / 16777216)).tostring() + "." + ([math]::truncate(($int % 16777216) / 65536)).tostring() + "." + ([math]::truncate(($int % 65536) / 256)).tostring() + "." + ([math]::truncate($int % 256)).tostring() )
}

function Convert-IPtoInt64 ($ip) { 
  <#
    .LINK
      https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Private%5CConvert-IPtoInt64.ps1
  #>
  $octets = $ip.split(".") 
  [int64]([int64]$octets[0] * 16777216 + [int64]$octets[1] * 65536 + [int64]$octets[2] * 256 + [int64]$octets[3]) 
}

function Get-NetworkClass {
  <#
    .LINK
      https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-NetworkClass.ps1
  #>
  param(
      [parameter(Mandatory,ValueFromPipeline)]
      [string]
      $IP
  )
  process {

      switch ($IP.Split('.')[0]) {
          { $_ -in 0..127 } { 'A' }
          { $_ -in 128..191 } { 'B' }
          { $_ -in 192..223 } { 'C' }
          { $_ -in 224..239 } { 'D' }
          { $_ -in 240..255 } { 'E' }
      }
  }
}

function New-B1Metadata {
  param(
      [Parameter(Mandatory=$true)]
      [IPAddress]$IP,
      [Parameter(Mandatory=$true)]
      [String]$Netmask,
      [Parameter(Mandatory=$true)]
      [IPAddress]$Gateway,
      [Parameter(Mandatory=$true)]
      [String]$DNSServers,
      [Parameter(Mandatory=$true)]
      [String]$JoinToken,
      [String]$LocalDebug
  )
  $CIDR = Convert-NetmaskToCIDR $Netmask

  $metadata = @{
      "instance-id" = ""
  } | ConvertTo-Json
  
  $network = @{
      "ethernets" = @{
          "eth0" = @{
              addresses = @(
                  "$($IP)/$($CIDR)"
              )
              dhcp4 = "False"
              gateway4 = "$($Gateway)"
              nameservers = @{
                  addresses = @(
                      $DNSServers
                  )
              }
          }
      }
      version = 2
  } | ConvertTo-Json -Depth 5
  
  $userdata = @()
  if ($LocalDebug) {
      $userdata += @(
          "#cloud-config"
          "bootcmd:"
          "- sed -i '5i -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT' /etc/firewall.d/firewall.4.rules"
          "- systemctl restart firewalld.service"
          "- sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"
          "- sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config"
          "- systemctl enable ssh"
          "- systemctl --no-block restart ssh"
          "- echo 'root:$($LocalDebug)' | chpasswd"
      )
  }
  $userdata += @(
      "host_setup:"
      "  jointoken: $($JoinToken)"
  )
  $userdataAggr = $userdata -join "`r`n"

  $Results = @{
      "metadata" = $metadata
      "network" = $network
      "userdata" = $userdataAggr
  }

  return $Results
}

function New-ISOFile {
  param(
      [Parameter(Mandatory=$true)]
      [String]$Source,
      [Parameter(Mandatory=$true)]
      [String]$Destination,
      [Parameter(Mandatory=$true)]
      [String]$VolumeName
  )
  $OS = Detect-OS

  if ($OS -eq "Windows") {

  }

  if ($OS -eq "Mac") {
      hdiutil makehybrid -iso -iso-volume-name "$VolumeName" -joliet -joliet-volume-name "$VolumeName" -o "$Destination" "$Source"
  }
}