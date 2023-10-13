function Copy-NIOSSubzoneToBloxOne {
    <#
    .SYNOPSIS
        Used to copy/migrate Authoritative Zone data from NIOS to BloxOneDDI

    .DESCRIPTION
        This function is used to copy/migrate Authoritative Zone data from NIOS to BloxOneDDI

    .PARAMETER Server
        The NIOS Grid Master FQDN

    .PARAMETER Subzone
        The name of the subzone to copy/migrate

    .PARAMETER NIOSView
        The DNS View within NIOS where the subzone is located

    .PARAMETER B1View
        The DNS View within BloxOne where the subzone is to be copied/migrated to

    .PARAMETER RecordTypes
        A list of one or more record types to copy. If not specified, all supported record types will be copied.

    .PARAMETER Confirm
        Set this parameter to false to ignore confirmation prompts

    .PARAMETER IncludeDHCP
        Use this option to include DHCP addresses when copying/migrating the subzone. This is not recommended as these records will be created as static A records, not dynamic.

    .PARAMETER Test
        Specify -Test to verify what will be created, without actually creating it

    .PARAMETER CreateZones
        Use the -CreateZones parameter to indicate if missing zones should be first created in BloxOne. This required either -DNSHosts or -AuthNSGs to be specified.

    .PARAMETER DNSHosts
        Used in combination with -CreateZones to specify which DNS Host(s) the zone should be assigned to.

    .PARAMETER AuthNSGs
        Used in combination with -CreateZones to specify which Authoriative Name Server Group(s) the zone should be assigned to.

    .PARAMETER Creds
        Used when specifying NIOS credentials explicitly, if they have not been pre-defined using Store-NIOSCredentials

    .EXAMPLE
        Copy-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -Test

    .EXAMPLE
        Copy-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -Confirm:$false

    .EXAMPLE
        Copy-NIOSSubzoneToBloxOne -Server gridmaster.domain.corp -Subzone my-dns.zone -NIOSView External -B1View my-b1dnsview -CreateZones -AuthNSGs "Core DNS Group"

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Migration
    #>
    [Alias("Migrate-NIOSSubzoneToBloxOne")]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [String]$Subzone,
      [Parameter(Mandatory=$true)]
      [String]$NIOSView,
      [Parameter(Mandatory=$true)]
      [String]$B1View,
      [ValidateSet("A","CNAME","PTR","TXT","SRV","MX","AAAA","CAA")] ## To be added "NAPTR","NS"
      [String[]]$RecordTypes,
      [switch]$Confirm = $true,
      [switch]$IncludeDHCP = $false,
      [switch]$Test = $false,
      [switch]$CreateZones = $false,
      [System.Object]$DNSHosts,
      [System.Object]$AuthNSGs,
      [PSCredential]$Creds
    )

    $Export = @()
    $SubzoneData = @()

    if (!(Get-NIOSAuthoritativeZone -Server $Server -Creds $Creds -FQDN $Subzone -View $NIOSView)) {
        Write-Host "Error. Authorative zone does not exist in NIOS." -ForegroundColor Red
    } else {
        Write-Host "Obtaining list of records from $Subzone..." -ForegroundColor Cyan
        if (!$RecordTypes) {
          [String[]]$RecordTypes = "host","a","cname","srv","txt","mx","aaaa","caa"
        }
        foreach ($RT in $RecordTypes.toLower()) {
            Write-Host "Querying $RT records" -ForegroundColor Cyan
            $ReturnFields = "&_return_fields%2b=comment"
            if ($RT -in ("a","cname")) {
                $ReturnFields = $ReturnFields + ",creator"
            }
            if ($RT -in "caa") {
                $ReturnFields = $ReturnFields + ",ca_flag,ca_tag,ca_value"
            }
            $SubzoneData += Query-NIOS -Method GET -Server $Server -Uri "record:$($RT)?zone=$($Subzone)&view=$($NIOSView)&_return_as_object=1$ReturnFields" -Creds $Creds | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }

        if (!$IncludeDHCP) {
            $SubzoneData = $SubzoneData | Where-Object {$_.Creator -eq "STATIC" -or (!$_.Creator)}
        }

        foreach ($SubzoneItem in $SubzoneData) {
            $SubzoneItem._ref -match "(record\:\w+)\/.*" | Out-Null
            $RecordType = $Matches[1]

            if ($Debug) {Write-Host "$($RecordType)?name=$($SubzoneItem.name+"."+$SubzoneItem.zone)&_return_as_object=1"}

            switch ($RecordType) {
                "record:host" {
                    $HostData = $SubzoneItem.ipv4addrs.ipv4addr
                }
                "record:a" {
                    $HostData = $SubzoneItem.ipv4addr
                }
                "record:aaaa" {
                    $HostData = $SubzoneItem.ipv6addr
                }
                "record:cname" {
                    $HostData = $SubzoneItem.canonical+"."
                }
                "record:srv" {
                    $HostData = "$($SubzoneItem.target):$($SubzoneItem.port):$($SubzoneItem.priority):$($SubzoneItem.weight)"
                }
                "record:txt" {
                    $HostData = $SubzoneItem.text
                }
                "record:mx" {
                    $HostData = "$($SubzoneItem.mail_exchanger):$($SubzoneItem.preference)"
                }
                "record:caa" {
                    $HostData = "$($SubzoneItem.ca_flag):$($SubzoneItem.ca_tag):$($SubzoneItem.ca_value)"
                }
                "default" {
                    $HostData = $null
                }
            }

            if (($SubzoneItem.name -split ("\.$($Subzone)") | Select-Object -First 1) -eq $Subzone) {
              $SubzoneItem.name = ""
            }
            $splat = @{
                "Type" = $RecordType
                "Name" = $SubzoneItem.name -split ("\.$($Subzone)") | Select-Object -First 1
                "Comment" = $SubzoneItem.comment
                "Data" = $HostData
            }

            $Export += $splat
        }
        Write-Host "The following records are ready to copy." -ForegroundColor Green
        $Export | ConvertTo-Json | ConvertFrom-Json | Format-Table -AutoSize
    }

    if ($Confirm -and -not $Test) {
        Write-Host "Review Information" -ForegroundColor Yellow
        Write-Warning "Are you sure you want to continue with copying this DNS Zone to BloxOne?" -WarningAction Inquire
    }

    if (!(Get-B1AuthoritativeZone -FQDN $Subzone -View $B1View)) {
        if ($CreateZones) {
            if ($DNSHosts -or $AuthNSGs) {
                New-B1AuthoritativeZone -FQDN $Subzone -View $B1View -DNSHosts $DNSHosts -AuthNSGs $AuthNSGs
                Wait-Event -Timeout 10
            } else {
                Write-Host "Error. You must specify -DNSHosts or -AuthNSGs when -CreateZones is $true" -ForegroundColor Red
                break
            }
        } else {
            Write-Host "Error. Authorative Zone $Subzone not found in BloxOne." -ForegroundColor Red
            break
        }
    }

    if (!($Test)) {
        Write-Host "Syncing $($Subzone) to BloxOneDDI in View $B1View.." -ForegroundColor Magenta
        $Records = Get-B1Record -Zone $Subzone -View $B1View
        foreach ($ExportedItem in $Export) {
            switch ($ExportedItem.type) {
                "record:host" {
                    $FoundRecords = $Records | Where-Object {$_.type -eq "A" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?"}
                    if ($FoundRecords) {
                        Write-Host "A Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $CreateResult = New-B1Record -Type "A" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -CreatePTR:$true -SkipExistsErrors -Description $ExportedItem.Comment
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
                "record:a" {
                    $FoundRecords = $Records | Where-Object {$_.type -eq "A" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?"}
                    if ($FoundRecords) {
                        Write-Host "A Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $CreateResult = New-B1Record -Type "A" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -CreatePTR:$true -SkipExistsErrors -Description $ExportedItem.Comment
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
                "record:aaaa" {
                    $FoundRecords = $Records | Where-Object {$_.type -eq "AAAA" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?"}
                    if ($FoundRecords) {
                        Write-Host "AAAA Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $CreateResult = New-B1Record -Type "AAAA" -Name $ExportedItem.Name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -Description $ExportedItem.Comment
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as AAAA Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
                "record:cname" {
                    $FoundRecords = $Records | Where-Object {$_.type -eq "CNAME" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?"}
                    if ($FoundRecords) {
                        Write-Host "A Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $CreateResult = New-B1Record -Type "CNAME" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -CreatePTR:$false -SkipExistsErrors -Description $ExportedItem.Comment
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as CNAME Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
                "record:srv" {
                    $FoundRecords = $Records | Where-Object {$_.type -eq "SRV" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?"}
                    if ($FoundRecords) {
                        Write-Host "SRV Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $ExportedData = $ExportedItem.data.split(":")
                      $CreateResult = New-B1Record -Type "SRV" -Name $ExportedItem.Name -Zone $Subzone -rdata $ExportedData[0] -Port $ExportedData[1] -Priority $ExportedData[2] -Weight $ExportedData[3] -view $B1View -CreatePTR:$false -SkipExistsErrors
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as SRV Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
                "record:txt" {
                    $FoundRecords = $Records | Where-Object {$_.type -eq "TXT" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?" -and $_.rdata.text -eq $ExportedItem.data}
                    if ($FoundRecords) {
                        Write-Host "TXT Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $CreateResult = New-B1Record -Type "TXT" -Name $ExportedItem.Name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -CreatePTR:$false -SkipExistsErrors -Description $ExportedItem.Comment
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as TXT Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
                "record:mx" {
                    $ExportedData = $ExportedItem.data.split(":")
                    $FoundRecords = $Records | Where-Object {$_.type -eq "MX" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?" -and $_.rdata.exchange -match "$($ExportedData[0])(\.)?"}
                    if ($FoundRecords) {
                        Write-Host "MX Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $CreateResult = New-B1Record -Type "MX" -Name $ExportedItem.Name -Zone $Subzone -rdata $ExportedData[0] -Preference $ExportedData[1] -view $B1View -Description $ExportedItem.Comment -SkipExistsErrors -IgnoreExists
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as MX Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
                "record:caa" {
                    $ExportedData = $ExportedItem.data.split(":")
                    $FoundRecords = $Records | Where-Object {$_.type -eq "CAA" -and $_.name_in_zone -eq $ExportedItem.name -and $_.absolute_zone_name -match "$Subzone(\.)?" -and $_.rdata.value -eq $ExportedData[2]}
                    if ($FoundRecords) {
                        Write-Host "CAA Record already exists: $($FoundRecords.absolute_name_spec)" -ForegroundColor DarkYellow
                    } else {
                      $CreateResult = New-B1Record -Type "CAA" -Name $ExportedItem.Name -Zone $Subzone -rdata "" -CAFlag $ExportedData[0] -CATag $ExportedData[1] -CAValue $ExportedData[2] -view $B1View -Description $ExportedItem.Comment -IgnoreExists
                      if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as CAA Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                    }
                }
            }
        }
        Write-Host "Completed Syncing $($Subzone) to BloxOneDDI in View $B1View.." -ForegroundColor Green
    }
}