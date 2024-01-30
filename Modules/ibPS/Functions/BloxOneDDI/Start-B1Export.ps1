function Start-B1Export {
    <#
    .SYNOPSIS
        Initiates a BloxOneDDI Export/Backup

    .DESCRIPTION
        This function is used to initiate a BloxOneDDI Export/Backup

    .PARAMETER Name
        The name to give the export/backup

    .PARAMETER Description
        The description to give the export/backup

    .PARAMETER $DNSConfig
        Use this switch to enable DNS Configuration to be included in the export/backup

    .PARAMETER $DNSData
        Use this switch to enable DNS Data to be included in the export/backup

    .PARAMETER $NTPData
        Use this switch to enable NTP Data to be included in the export/backup

    .PARAMETER $IPAMData
        Use this switch to enable IPAM Data to be included in the export/backup

    .PARAMETER $KeyData
        Use this switch to enable Key Data to be included in the export/backup

    .PARAMETER $ThreatDefense
        Use this switch to enable Threat Defense Configuration to be included in the export/backup

    .PARAMETER $Bootstrap
        Use this switch to enable BloxOne Host Bootstrap Configuration to be included in the export/backup

    .PARAMETER $OnPremHosts
        Use this switch to enable BloxOne Host Configuration to be included in the export/backup

    .PARAMETER $Redirects
        Use this switch to enable Custom Redirects to be included in the export/backup

    .PARAMETER $Tags
        Use this switch to enable Tag Configuration to be included in the export/backup

    .PARAMETER $BackupAll
        Use this switch to enable all configuration & data types to be included in the export/backup

    .EXAMPLE
        Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -DNSConfig -DNSData -IPAMData -KeyData -ThreatDefense -Bootstrap -OnPremHosts -Redirects -Tags

    .EXAMPLE
        Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -BackupAll

    .EXAMPLE
        $ExportName = "B1-Export-$((Get-Date).ToString('dd-MM-yy hh-mm-ss'))"

        Start-B1Export -Name $ExportName -BackupAll
        while (($BulkOp = Get-B1BulkOperation -Name $ExportName -Strict).overall_status -ne "Completed") {
            Write-Host "Waiting for export to complete.."
            Wait-Event -Timeout 5
        }
        $BulkOp | Get-B1Export -filePath "/tmp/$($ExportName)"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Backup
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [Switch]$DNSConfig,
      [Switch]$DNSData,
      [Switch]$NTPData,
      [Switch]$IPAMData,
      [Switch]$KeyData,
      [Switch]$ThreatDefense,
      [Switch]$Bootstrap,
      [Switch]$OnPremHosts,
      [Switch]$Redirects,
      [Switch]$Tags,
      [Switch]$BackupAll
    )

    $splat = @{
        "name" = $Name
        "description" = $Description
        "export_format" = "json"
        "error_handling_id" = "1"
    }

    $dataTypes = New-Object System.Collections.ArrayList

    if ($DNSConfig -or $BackupAll) {
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v2/authzonev2s.v2.dnsconfig.bulk.infoblox.com") | Out-Null ## Authoritative Zones
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v2/forwardzonev2s.v2.dnsconfig.bulk.infoblox.com") | Out-Null ## Forward Zones
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v2/serverv2s.v2.dnsconfig.bulk.infoblox.com") | Out-Null ## DNS Config Profiles
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v2/viewv2s.v2.dnsconfig.bulk.infoblox.com") | Out-Null ## DNS Views
    }
    if ($DNSData -or $BackupAll) {
        $dataTypes.Add("dnsdata.bulk.infoblox.com/v2/recordv2s.v2.dnsdata.bulk.infoblox.com") | Out-Null ## DNS Records
    }
    if ($NTPData -or $BackupAll) {
        $dataTypes.Add("ntp.bulk.infoblox.com/v1alpha1/ntpserviceconfigs.v1alpha1.ntp.bulk.infoblox.com") | Out-Null ## NTP Configuration
    }
    if ($IPAMData -or $BackupAll) {
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/addressblockv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## IPAM Address Blocks
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/addressv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## Addresses
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/fixedaddressv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## Fixed Addresses
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/hagroupv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## HA Groups
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/hardwarefilterv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## Hardware Filters
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/ipspacev3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## IP Spaces
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/optioncodev3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## DHCP Option Codes
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/optionfilterv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## DHCP Option Filters
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/optiongroupv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## DHCP Option Groups
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/optionspacev3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## DHCP Option Spaces
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/rangev3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## DHCP Ranges
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/subnetv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## IPAM Subnets
        $dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/ipamhostv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## DHCP Hosts
        $dataTypes.Add("ipamdhcp.bulk.infoblox.com/v3/serverv3s.v3.ipamdhcp.bulk.infoblox.com") | Out-Null ## DHCP Config Profiles
    }
    if ($KeyData -or $BackupAll) {
        $dataTypes.Add("keys.bulk.infoblox.com/v1/tsigkeys.v1.keys.bulk.infoblox.com") | Out-Null
    }
    if ($ThreatDefense -or $BackupAll) {
        $dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/applicationfilters.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/b1endpoints.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/categoryfilters.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/customdomains.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/endpointgroups.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/externalsubnets.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/internaldomains.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("atcapi.bulk.infoblox.com/v1alpha1/securitypolicies.v1alpha1.atcapi.bulk.infoblox.com") | Out-Null
    }
    if ($Bootstrap -or $BackupAll) {
        $dataTypes.Add("bootstrap.bulk.infoblox.com/v1alpha1/hostconfigs.v1alpha1.bootstrap.bulk.infoblox.com") | Out-Null
    }
    if ($OnPremHosts -or $BackupAll) {
        $dataTypes.Add("onprem.bulk.infoblox.com/v1alpha1/hosts.v1alpha1.onprem.bulk.infoblox.com") | Out-Null
    }
    if ($Redirects -or $BackupAll) {
        $dataTypes.Add("redirect.bulk.infoblox.com/v1alpha1/customredirects.v1alpha1.redirect.bulk.infoblox.com") | Out-Null
    }
    if ($Tags -or $BackupAll) {
        $dataTypes.Add("tagging.bulk.infoblox.com/v1alpha1/tags.v1alpha1.tagging.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("tagging.bulk.infoblox.com/v1alpha1/values.v1alpha1.tagging.bulk.infoblox.com") | Out-Null
    }
    if ($dataTypes) {
        $splat | Add-Member -Name "data_types" -Value $dataTypes -MemberType NoteProperty
    }
    $splat = $splat | ConvertTo-Json
    if ($Debug) {$splat}
    $Export = Query-CSP -Method "POST" -Uri "$(Get-B1CSPUrl)/bulk/v1/export" -Data $splat

    if ($Export.success.message -eq "Export pending") {
        Write-Host "Data Export initalised successfully." -ForegroundColor Green
    } else {
        Write-Host "Data Export failed to initialise." -ForegroundColor Red
    }
}