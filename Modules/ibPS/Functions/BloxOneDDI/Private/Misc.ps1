function Combine-Filters {
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
            $combinedFilter += $Filter+" and "
        }
        $FilterCount = $FilterCount - 1
    }
    $combinedFilter
}

function Combine-Filters2 {
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

function ConvertTo-IPv4MaskString {
  param(
    [parameter(Mandatory=$true)]
    [ValidateRange(0,32)]
    [Int] $MaskBits
  )
  $mask = ([Math]::Pow(2, $MaskBits) - 1) * [Math]::Pow(2, (32 - $MaskBits))
  $bytes = [BitConverter]::GetBytes([UInt32] $mask)
  (($bytes.Count - 1)..0 | ForEach-Object { [String] $bytes[$_] }) -join "."
}

function Test-IPv4MaskString {
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

function ConvertTo-IPv4MaskBits {
  param(
    [parameter(Mandatory=$true)]
    [ValidateScript({Test-IPv4MaskString $_})]
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
        "Application" = "DC"
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