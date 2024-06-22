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
      $Filters,
      $Type = "and"
    )
    $combinedFilter = $null
    $FilterCount = $Filters.Count
    switch ($Filters.GetType().FullName) {
      "System.Collections.ArrayList" {
        foreach ($filter in $Filters) {
          if ($FilterCount -le 1) {
              $combinedFilter += $Filter
          } else {
              $combinedFilter += $Filter+" $($Type) "
          }
          $FilterCount = $FilterCount - 1
        }
      }
      "System.Object[]" {
        foreach ($filter in $Filters) {
          if ($FilterCount -le 1) {
            $combinedFilter += "$($Filter.Property)$($Filter.Operator)`"$($Filter.Value)`""
          } else {
            $combinedFilter += "$($Filter.Property)$($Filter.Operator)`"$($Filter.Value)`" $($Type) "
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

function Test-ValidIPv4Address ($ip) {
  return ($ip -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" -and [bool]($ip -as [ipaddress]))
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

function ConvertTo-HexString {
  <#
    .LINK
      https://www.powershellgallery.com/packages/Utility.PS/1.0.0.1/Content/ConvertTo-HexString.ps1
  #>
  [CmdletBinding()]
  param (
      # Value to convert
      [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true)]
      [object] $InputObjects,
      # Delimiter between Hex pairs
      [Parameter (Mandatory=$false)]
      [string] $Delimiter = ' ',
      # Encoding to use for text strings
      [Parameter (Mandatory=$false)]
      [ValidateSet('Ascii', 'UTF32', 'UTF7', 'UTF8', 'BigEndianUnicode', 'Unicode')]
      [string] $Encoding = 'Default'
  )

  begin {
      function Transform ([byte[]]$InputBytes) {
          [string[]] $outHexString = New-Object string[] $InputBytes.Count
          for ($iByte = 0; $iByte -lt $InputBytes.Count; $iByte++) {
              $outHexString[$iByte] = $InputBytes[$iByte].ToString('X2')
          }
          return $outHexString -join $Delimiter
      }

      ## Create list to capture byte stream from piped input.
      [System.Collections.Generic.List[byte]] $listBytes = New-Object System.Collections.Generic.List[byte]
  }

  process
  {
      if ($InputObjects -is [byte[]])
      {
          Write-Output (Transform $InputObjects)
      }
      else {
          foreach ($InputObject in $InputObjects) {
              [byte[]] $InputBytes = $null
              if ($InputObject -is [byte]) {
                  ## Populate list with byte stream from piped input.
                  if ($listBytes.Count -eq 0) {
                      Write-Verbose 'Creating byte array from byte stream.'
                      Write-Warning ('For better performance when piping a single byte array, use "Write-Output $byteArray -NoEnumerate | {0}".' -f $MyInvocation.MyCommand)
                  }
                  $listBytes.Add($InputObject)
              }
              elseif ($InputObject -is [byte[]])
              {
                  $InputBytes = $InputObject
              }
              elseif ($InputObject -is [string])
              {
                  $InputBytes = [Text.Encoding]::$Encoding.GetBytes($InputObject)
              }
              elseif ($InputObject -is [bool] -or $InputObject -is [char] -or $InputObject -is [single] -or $InputObject -is [double] -or $InputObject -is [int16] -or $InputObject -is [int32] -or $InputObject -is [int64] -or $InputObject -is [uint16] -or $InputObject -is [uint32] -or $InputObject -is [uint64])
              {
                  $InputBytes = [System.BitConverter]::GetBytes($InputObject)
              }
              elseif ($InputObject -is [guid])
              {
                  $InputBytes = $InputObject.ToByteArray()
              }
              elseif ($InputObject -is [System.IO.FileSystemInfo])
              {
                  if ($PSVersionTable.PSVersion -ge [version]'6.0') {
                      $InputBytes = Get-Content $InputObject.FullName -Raw -AsByteStream
                  }
                  else {
                      $InputBytes = Get-Content $InputObject.FullName -Raw -Encoding Byte
                  }
              }
              else
              {
                  ## Non-Terminating Error
                  $Exception = New-Object ArgumentException -ArgumentList ('Cannot convert input of type {0} to Hex string.' -f $InputObject.GetType())
                  Write-Error -Exception $Exception -Category ([System.Management.Automation.ErrorCategory]::ParserError) -CategoryActivity $MyInvocation.MyCommand -ErrorId 'ConvertHexFailureTypeNotSupported' -TargetObject $InputObject
              }

              if ($null -ne $InputBytes -and $InputBytes.Count -gt 0) {
                  Write-Output (Transform $InputBytes)
              }
          }
      }
  }

  end {
      ## Output captured byte stream from piped input.
      if ($listBytes.Count -gt 0) {
          Write-Output (Transform $listBytes.ToArray())
      }
  }
}

function ConvertFrom-HexString {
  <#
    .LINK
      https://www.powershellgallery.com/packages/MSIdentityTools/1.0.0.3/Content/ConvertFrom-HexString.ps1
  #>
  [CmdletBinding()]
  param (
      # Value to convert
      [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
      [string[]] $InputObject,
      # Delimiter between Hex pairs
      [Parameter (Mandatory=$false)]
      [string] $Delimiter = " ",
      # Output raw byte array
      [Parameter (Mandatory=$false)]
      [switch] $RawBytes,
      # Encoding to use for text strings
      [Parameter (Mandatory=$false)]
      [ValidateSet("Ascii", "UTF32", "UTF7", "UTF8", "BigEndianUnicode", "Unicode")]
      [string] $Encoding = "Default"
  )

  process
  {
      $listBytes = New-Object object[] $InputObject.Count
      for ($iString = 0; $iString -lt $InputObject.Count; $iString++) {
          [string] $strHex = $InputObject[$iString]
          if ($strHex.Substring(2,1) -eq $Delimiter) {
              [string[]] $listHex = $strHex -split $Delimiter
          }
          else {
              [string[]] $listHex = New-Object string[] ($strHex.Length/2)
              for ($iByte = 0; $iByte -lt $strHex.Length; $iByte += 2) {
                  $listHex[[System.Math]::Truncate($iByte/2)] = $strHex.Substring($iByte, 2)
              }
          }

          [byte[]] $outBytes = New-Object byte[] $listHex.Count
          for ($iByte = 0; $iByte -lt $listHex.Count; $iByte++)
          {
              $outBytes[$iByte] = [byte]::Parse($listHex[$iByte],[System.Globalization.NumberStyles]::HexNumber)
          }

          if ($RawBytes) { $listBytes[$iString] = $outBytes }
          else {
              $outString = ([Text.Encoding]::$Encoding.GetString($outBytes))
              Write-Output $outString
          }
      }
      if ($RawBytes) {
          return $listBytes
      }
  }
}

function ConvertTo-Base64Url {
  <#
    .LINK
      https://www.powershellgallery.com/packages/Posh-ACME/2.0.1/Content/Private%5CConvertTo-Base64Url.ps1
  #>
  [CmdletBinding()]
  [OutputType('System.String')]
  param(
      [Parameter(ParameterSetName='String',Mandatory,Position=0,ValueFromPipeline)]
      [AllowEmptyString()]
      [string]$Text,
      [Parameter(ParameterSetName='String')]
      [switch]$FromBase64,
      [Parameter(ParameterSetName='Bytes',Mandatory,Position=0)]
      [AllowEmptyCollection()]
      [byte[]]$Bytes
  )
  Process {
      if (!$FromBase64) {
          if ($PSCmdlet.ParameterSetName -eq 'String') {
              $Bytes = [Text.Encoding]::UTF8.GetBytes($Text)
          }
          $s = [Convert]::ToBase64String($Bytes)
      } else {
          $s = $Text
      }
      $s = $s.Split('=')[0]
      $s = $s.Replace('+','-').Replace('/','_')
      return $s
  }
}

function New-B1Metadata {
  param(
      [IPAddress]$IP,
      [String]$Netmask,
      [IPAddress]$Gateway,
      [String]$DNSServers,
      [String]$DNSSuffix,
      [String]$JoinToken,
      [String]$LocalDebug
  )

  if (($PSBoundParameters.Count -eq 1) -and $($PSBoundParameters.JoinToken)) {
    $JoinTokenOnly = $true
  } else {
    if (!($IP) -or !($Netmask) -or !($Gateway) -or !($DNSServers)) {
      Write-Error "IP, Netmask, Gateway & DNSServers are mandatory parameters."
      return $null
    }
    $CIDR = Convert-NetmaskToCIDR $Netmask
  }

  if (!$JoinTokenOnly) {
    $metadata = @(
        '{'
        '"instance-id": ""'
        '}'
    ) -join "`r`n"
    
    $network = @(
        "ethernets:"
        "  eth0:"
        "    addresses: [ $($IP)/$($CIDR) ]"
        "    dhcp4: False"
        "    gateway4: $($Gateway)"
        "    nameservers:"
        "      addresses: [$($DNSServers)]"
        "    search: [$($DNSSuffix)]"
        "version: 2"
    ) -join "`r`n"
  }
  
  $userdata = @()
  $userdata += "#cloud-config"
  if ($LocalDebug) {
      $userdata += @(
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

  switch($OS) {
    "Windows" {
      $typeDefinition = @'
        public class ISOFile  {
            public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks) {
                int bytes = 0;
                byte[] buf = new byte[BlockSize];
                var ptr = (System.IntPtr)(&bytes);
                var o = System.IO.File.OpenWrite(Path);
                var i = Stream as System.Runtime.InteropServices.ComTypes.IStream;

                if (o != null) {
                    while (TotalBlocks-- > 0) {
                        i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes);
                    }

                    o.Flush(); o.Close();
                }
            }
        }
'@
        if (!('ISOFile' -as [type])) {
          switch ($PSVersionTable.PSVersion.Major) {
            {$_ -ge 7} {
              Write-Verbose ("Adding type for PowerShell 7 or later.")
              Add-Type -CompilerOptions "/unsafe" -TypeDefinition $typeDefinition
            }

            5 {
              Write-Verbose ("Adding type for PowerShell 5.")
              $compOpts = New-Object System.CodeDom.Compiler.CompilerParameters
              $compOpts.CompilerOptions = "/unsafe"
              Add-Type -CompilerParameters $compOpts -TypeDefinition $typeDefinition
            }
            default {
              throw ("Unsupported PowerShell version.")
            }
          }
        }

        try {
          $image = New-Object -ComObject IMAPI2FS.MsftFileSystemImage -Property @{VolumeName=$VolumeName} -ErrorAction Stop
          $image.ChooseImageDefaultsForMediaType(13) ## Defaults to DVDPLUSRW_DUALLAYER
          $image.fileSystemsToCreate = 3
        }
        catch {
          throw ("Failed to initialise image. " + $_.exception.Message)
        }

        if (!($targetFile = New-Item -Path $Destination -ItemType File -Force -ErrorAction SilentlyContinue)) {
                throw ("Cannot create file " + $Destination + ".")
        }

        try {
          $sourceItems = Get-ChildItem -LiteralPath $Source -Exclude *.iso -ErrorAction Stop
        }
        catch {
          throw ("Failed to get source items. " + $_.exception.message)
        }

        foreach($sourceItem in $sourceItems) {
          try {
              $image.Root.AddTree($sourceItem.FullName, $true)
          }
          catch {
              throw ("Failed to add " + $sourceItem.fullname + ". " + $_.exception.message)
          }
        }

        try {
          $result = $image.CreateResultImage()
          [ISOFile]::Create($targetFile.FullName,$result.ImageStream,$result.BlockSize,$result.TotalBlocks)
        }
        catch {
          throw ("Failed to write ISO file. " + $_.exception.Message)
        }

        return $targetFile

    }
    
    "Mac" {
      hdiutil makehybrid -iso -iso-volume-name "$VolumeName" -joliet -joliet-volume-name "$VolumeName" -o "$Destination" "$Source"
    }
  }
}

function Get-B1ServiceLogApplications {
  $Result = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/atlas-logs/v1/applications" | Select-Object -ExpandProperty applications -WA SilentlyContinue -EA SilentlyContinue
  $Result += @(
    [PSCustomObject]@{
      "type" = 1000
      "label" = "Kube"
      "container_name" = "k3s.service"
    }
    [PSCustomObject]@{
      "type" = 1001
      "label" = "NetworkMonitor"
      "container_name" = "host/network-monitor.service"
    }
    [PSCustomObject]@{
      "type" = 1002
      "label" = "CDC-OUT"
      "container_name" = "cdc_siem_out"
    }
    [PSCustomObject]@{
      "type" = 1003
      "label" = "CDC-IN"
      "container_name" = "cdc_rpz_in"
    }
  )
  return $Result
}

function DeprecationNotice {
  param (
    $Date,
    $Command,
    $AlternateCommand
  )
  $ParsedDate = [datetime]::parseexact($Date, 'dd/MM/yy', $null)
  if ($ParsedDate -gt (Get-Date)) {
    Write-Host "Cmdlet Deprecation Notice! $Command will be deprecated on $Date. Please switch to using $AlternateCommand before this date." -ForegroundColor Yellow
  } else {
    Write-Host "Cmdlet was deprecated on $Date. $Command will likely no longer work. Please switch to using $AlternateCommand instead." -ForegroundColor Red
  }
}

function Write-NetworkTopology {
  param(
      [Parameter(
          ValueFromPipeline = $true,
          Mandatory=$true
      )]
      [System.Object[]]$Object,
      [String]$AdditionalSpaces,
      [Int]$Call = 1,
      [Switch]$IncludeAddresses,
      [Switch]$IncludeRanges,
      [Switch]$IncludeSubnets
  )
  process {
    if ($Object.label) {
      $Include = $true
      $ObjectType = $($Object.type.split('/'))[1]
      Switch($ObjectType) {
        "address_block" {
          $Colour = 'green'
          $Prefix = 'AB'
        }
        "subnet" {
          $Colour = 'cyan'
          $Prefix = 'SN'
          if (!($IncludeSubnets)) {
            $Include = $false
          }
        }
        "range" {
          $Colour = 'magenta'
          $Prefix = 'RG'
          if (!($IncludeRanges)) {
            $Include = $false
          }
        }
        "address" {
          $Colour = 'DarkYellow'
          $Prefix = 'AD'
          if (!($IncludeAddresses)) {
            $Include = $false
          }
        }
        default {
          $Colour = 'Red'
        }
      }
      if ($Include) {
        Write-Host "$($AdditionalSpaces) $($Object.label) [$ObjectType]" -ForegroundColor $Colour
      }
    }
    if ($Object.Children -ne $null) {
        $SpacesToAdd = ""
        foreach ($i in 1..$($Call)) {
            $SpacesToAdd += "    "
        }
        $Call += 1
        $Object.Children | Write-NetworkTopology -AdditionalSpaces "$($SpacesToAdd)" -Call $Call -IncludeAddresses:$IncludeAddresses -IncludeRanges:$IncludeRanges -IncludeSubnets:$IncludeSubnets
        $Call -= 1
    }
  }
}

function Build-TopologyChildren {
  param(
      [System.Object[]]$Object,
      [Switch]$IncludeAddresses,
      [Switch]$IncludeRanges,
      [Switch]$IncludeSubnets,
      [Int]$Progress = 0
  )
  process {
      $ParentObjectsToCheck = @("ipam/address_block")
      $ChildObjectsToCheck = @("ipam/address_block")
      if ($IncludeAddresses) {
        $ParentObjectsToCheck += "ipam/range","ipam/subnet"
        $ChildObjectsToCheck += "ipam/address"
      }
      if ($IncludeRanges) {
        if ("ipam/subnet" -notin $ChildObjectsToCheck) {
          $ParentObjectsToCheck += "ipam/subnet"
        }
        $ChildObjectsToCheck += "ipam/range"
      }
      if ($IncludeSubnets) {
        $ChildObjectsToCheck += "ipam/subnet"
      }
      $FunctionDefinition = ${function:Build-TopologyChildren}.ToString()
      if ($PSVersionTable.PSVersion -gt [Version]'7.0') {
        $Object | Foreach-Object -ThrottleLimit 10 -Parallel {
          ${function:Build-TopologyChildren} = $($using:FunctionDefinition)
          Write-Host -NoNewLine "`rSearched: $($_.label)          "
          $Children = $_ | Get-B1IPAMChild -Limit 10000 -Fields 'id,type,label' -Type $($using:ChildObjectsToCheck) -Strict -OrderBy 'label' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
          if ($Children -ne $null) {
              $_ | Add-Member -Type NoteProperty -Name 'Children' -Value $Children -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
              Build-TopologyChildren -Object ($_.Children | Where-Object {$_.type -in $($using:ParentObjectsToCheck)}) -IncludeAddresses:$($using:IncludeAddresses) -IncludeRanges:$($using:IncludeRanges) -IncludeSubnets:$($using:IncludeSubnets)
          }
        }
      } else {
        foreach ($ChildObject in $Object) {
          Write-Host -NoNewLine "`rSearched: $($_.label)          "
          $Children = $ChildObject | Get-B1IPAMChild -Limit 10000 -Fields 'id,type,label' -Type $($ChildObjectsToCheck) -Strict -OrderBy 'label' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
          if ($Children -ne $null) {
            $ChildObject | Add-Member -Type NoteProperty -Name 'Children' -Value $Children -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            Build-TopologyChildren -Object ($ChildObject.Children | Where-Object {$_.type -in $($ParentObjectsToCheck)}) -IncludeAddresses:$($IncludeAddresses) -IncludeRanges:$($IncludeRanges) -IncludeSubnets:$($IncludeSubnets)
          }
        }
      }
  }
}

function Build-HTMLTopologyChildren {
  param(
      [System.Object[]]$Object,
      [Int]$Call,
      [Switch]$IncludeAddresses,
      [Switch]$IncludeRanges,
      [Switch]$IncludeSubnets
  )
  process {
    if ($Call -eq 0) {
      Switch ($Object.id.split('/')[1]) {
        "ip_space" {
          $ParentDescription = "$($Object.name)"
        }
        "address_block" {
          $ParentDescription = "$(($Object | Select-Object address).address)/$($Object.cidr)"
        }
        "subnet" {
          $ParentDescription = "$(($Object | Select-Object address).address)/$($Object.cidr)"
        }
      }
    } else {
        $ParentDescription = $null
    }
    $Call += 1
    foreach ($ChildObject in $Object.Children) {
      $Include = $true
      $ObjectType = $($ChildObject.type.split('/'))[1]
      $Colour = $null
      $Icon = $null
      Switch($ObjectType) {
        "address_block" {
          $Colour = 'LightGreen'
          $Icon = 'cube'
        }
        "subnet" {
          $Colour = 'LightBlue'
          $Icon = 'network-wired'
          if (!($IncludeSubnets)) {
            $Include = $false
          }
        }
        "range" {
          $Colour = 'Magenta'
          $Icon = 'ellipsis-h'
          if (!($IncludeRanges)) {
            $Include = $false
          }
        }
        "address" {
          $Colour = 'LightYellow'
          if (!($IncludeAddresses)) {
            $Include = $false
          }
        }
        default {
          $Colour = 'Red'
        }
      }
      if ($Include) {
        if ($ParentDescription) {
          if ($Icon) {
            New-DiagramNode -Label $($ChildObject.label) -Id $_.Id -To $ParentDescription -IconColor $Colour -IconSolid $Icon
          } else {
            New-DiagramNode -Label $($ChildObject.label) -Id $_.Id -To $ParentDescription -ColorBackground $Colour
          }
        } else {
          if ($Icon) {
            New-DiagramNode -Label $($ChildObject.label) -Id $_.Id -To $($Object.label) -IconColor $Colour -IconSolid $Icon
          } else {
            New-DiagramNode -Label $($ChildObject.label) -Id $_.Id -To $($Object.label) -ColorBackground $Colour           
          }
        }
      }
      if ($ChildObject.Children -ne $null) {
        Build-HTMLTopologyChildren -Object $ChildObject -Call $Call -IncludeAddresses:$IncludeAddresses -IncludeRanges:$IncludeRanges -IncludeSubnets:$IncludeSubnets
      }
    }
    $ParentDescription = $null
  }
}

function Write-DebugMsg {
  param(
    $URI,
    $Filters,
    $Query,
    $Body
  )

  if ($ENV:IBPSDebug -eq "Enabled") {
    if ($URI) {
      Write-Debug "$($URI)"
    }
    if ($Filters) {
      Write-Debug "Filter(s):`n$($Filters | Out-String)"
    }
    if ($Query) {
      Write-Debug "Query:`n$($Query | Out-String)"
    }
    if ($Body) {
      Write-Debug "Body:`n$($Body | Out-String)"
    }
  }
}

function DevelopmentFunctions {
  return @(
    "Get-B1CSPUrl"
    "Get-B1CSPAPIKey"
    "Detect-OS"
    "Combine-Filters"
    "ConvertTo-QueryString"
    "Match-Type"
    "Convert-CIDRToNetmask"
    "Test-NetmaskString"
    "Test-ValidIPv4Address"
    "Convert-NetmaskToCIDR"
    "Convert-Int64toIP"
    "Convert-IPtoInt64"
    "Get-NetworkClass"
    "New-B1Metadata"
    "New-ISOFile"
    "DeprecationNotice"
    "Write-NetworkTopology"
    "Build-TopologyChildren"
    "Build-HTMLTopologyChildren"
    "Write-DebugMsg"
    "Write-Colour"
    "New-ibPSTelemetry"
    "ConvertFrom-HexString"
    "ConvertTo-HexString"
    "ConvertTo-Base64Url"
  )
}

function Write-Colour {
  param(
    [String[]]$Message,
    [String[]]$Colour
  )
  $Count = 0
  foreach ($M in $Message) {
    Write-Host "$M" -ForegroundColor $Colour[$Count] -NoNewLine
    $Count += 1
  }
  Write-Host "`r"
}

function New-ibPSTelemetry {
  param(
    $Method = 'GET'
  )
  if ($ENV:IBPSTelemetry -eq "Enabled") {
    $PSCallStack = Get-PSCallStack
    if (!($ENV:IBPSID)) {
      $Random = $(Get-Random)
      $Platform = Detect-OS
      if ($Platform -eq "Windows") {
        [System.Environment]::SetEnvironmentVariable('IBPSID',$($Random),[System.EnvironmentVariableTarget]::User)
      } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
        if (!(Test-Path ~/.zshenv)) {
          touch ~/.zshenv
        }
        sed -i '' -e '/IBPSID/d' ~/.zshenv
        echo "export IBPSID=$($Random)" >> ~/.zshenv
      }
      $ENV:IBPSID = $($Random)
    }
    $Query = @(
      "v=2" ## Version
      "tid=G-NQTBLB6HTQ" ## Google Analytics Tracking ID
      "cid=$($ENV:IBPSID)" ## Client ID
      "_p=$(Get-Random)" ## Random Page Load Hash
      "ul=en-gb" ## User Language
      "uafvl=ibPS-v$(Get-ibPSVersion)" ## ibPS Version
      #"uaa=arm" ## Architecture
      #"uab=64" ## Architecture bits
      #"uap=macOS" ## User Agent Platform
      #"uapv=14.3.1" ## User Agent Platform Version
      "_s=1" ## Hit Counter
      "sct=1" ## Session Count
      "seg=1" ## Session Engagement
      "dt=$($PSCallStack[2].Command)" ## Document Title
      "en=$($Method)" ## Event Name
      "_ee=1" ## External Event
    )
    $QueryString = ConvertTo-QueryString $Query
    $OutNull = Invoke-WebRequest -Method POST -Uri "https://google-analytics.com/g/collect$($QueryString)" -UseBasicParsing | Out-Null
  }
}