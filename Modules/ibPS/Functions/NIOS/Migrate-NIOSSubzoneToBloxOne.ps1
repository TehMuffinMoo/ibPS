function Migrate-NIOSSubzoneToBloxOne {
    param(
      [Parameter(Mandatory=$true)]
      [String]$Server,
      [Parameter(Mandatory=$true)]
      [String]$Subzone,
      [Parameter(Mandatory=$true)]
      [String]$NIOSView,
      [Parameter(Mandatory=$true)]
      [String]$B1View,
      [switch]$Confirm = $true,
      [switch]$IncludeDHCP = $false,
      [switch]$Test = $false,
      [switch]$CreateZones = $false,
      [System.Object]$DNSHosts,
      [System.Object]$AuthNSGs,
      $Creds
    )

    $Export = @()

    if (!(Get-NIOSAuthoritativeZone -Server $Server -Creds $Creds -FQDN $Subzone -View $NIOSView)) {
        Write-Host "Error. Authorative zone does not exist in NIOS." -ForegroundColor Red
    } else {
        Write-Host "Obtaining list of records from $Subzone..." -ForegroundColor Cyan
        $SubzoneData = Query-NIOS -Method GET -Server $Server -Uri "allrecords?zone=$Subzone&view=$NIOSView&_return_as_object=1&_return_fields%2B=creator" -Creds $Creds | Select -ExpandProperty results -ErrorAction SilentlyContinue

        if (!$IncludeDHCP) {
            $SubzoneData = $SubzoneData | where {$_.Creator -eq "STATIC"}
        }

        $UnsupportedRecords = $SubzoneData | where {$_.type -eq "UNSUPPORTED"}
        if ($UnsupportedRecords) {
            Write-Host "Unsupported records found. These may need to be re-created in BloxOne." -ForegroundColor Red
            $UnsupportedRecords | ft name,zone,type,comment,view -AutoSize
        }
        $SubzoneData = $SubzoneData | where {$_.type -ne "UNSUPPORTED"}

        foreach ($SubzoneItem in $SubzoneData) {
            if ($SubzoneItem.type -eq "record:host_ipv4addr") {
                $SubzoneItem.type = "record:host"
            }
            if ($Debug) {Write-Host "$($SubzoneItem.type)?name=$($SubzoneItem.name+"."+$SubzoneItem.zone)&_return_as_object=1"}

            $ReturnData = Query-NIOS -Method GET -Server $Server -Uri "$($SubzoneItem.type)?name=$($SubzoneItem.name+"."+$SubzoneItem.zone)&_return_as_object=1" -Creds $Creds | Select -ExpandProperty results -ErrorAction SilentlyContinue | Select -First 1 -ErrorAction SilentlyContinue

            switch ($SubzoneItem.type) {
                "record:host" {
                    $HostData = $ReturnData.ipv4addrs.ipv4addr
                }
                "record:a" {
                    $HostData = $ReturnData.ipv4addr
                }
                "record:cname" {
                    $HostData = $ReturnData.canonical+"."
                }
                "record:srv" {
                    $HostData = "$($ReturnData.target):$($ReturnData.port):$($ReturnData.priority):$($ReturnData.weight)"
                }
            }

            $splat = @{
                "Type" = $SubzoneItem.type
                "Name" = $SubzoneItem.name
                "Data" = $HostData
            }

            $Export += $splat
        }
        Write-Host "The following records are ready to copy." -ForegroundColor Green
        $Export | ConvertTo-Json | ConvertFrom-Json | ft -AutoSize
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
        Write-Host "Syncing $($Subzone) to BloxOneDDI in View $B1View.." -ForegroundColor Yellow
        foreach ($ExportedItem in $Export) {
            switch ($ExportedItem.type) {
                "record:host" {
                    $CreateResult = New-B1Record -Type "A" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -CreatePTR:$true -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                }
                "record:a" {
                    $CreateResult = New-B1Record -Type "A" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -CreatePTR:$true -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                }
                "record:cname" {
                    $CreateResult = New-B1Record -Type "CNAME" -Name $ExportedItem.name -Zone $Subzone -rdata $ExportedItem.data -view $B1View -CreatePTR:$false -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                }
                "record:srv" {
                    $ExportedData = $ExportedItem.data.split(":")
                    $CreateResult = New-B1Record -Type "SRV" -Name $ExportedItem.Name -Zone $Subzone -rdata $ExportedData[0] -Port $ExportedData[1] -Priority $ExportedData[2] -Weight $ExportedData[3] -view $B1View -CreatePTR:$false -SkipExistsErrors
                    if ($CreateResult) { Write-Host "Created $($ExportedItem.name) as A Record with data $($ExportedItem.data) in View $B1View." -ForegroundColor Green }
                }
            }
        }
        Write-Host "Completed Syncing $($Subzone) to BloxOneDDI in View $B1View.." -ForegroundColor Green
    }
}