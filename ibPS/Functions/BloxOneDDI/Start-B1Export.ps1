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

    .Example
        Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -DNSConfig -DNSData -IPAMData -KeyData -ThreatDefense -Bootstrap -OnPremHosts -Redirects -Tags

    .Example
        Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -BackupAll
   
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
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/authzones.v1.dnsconfig.bulk.infoblox.com") | Out-Null
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/forwardzones.v1.dnsconfig.bulk.infoblox.com") | Out-Null
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/servers.v1.dnsconfig.bulk.infoblox.com") | Out-Null
        $dataTypes.Add("dnsconfig.bulk.infoblox.com/v1/views.v1.dnsconfig.bulk.infoblox.com") | Out-Null
    }
    if ($DNSData -or $BackupAll) {
        $dataTypes.Add("dnsdata.bulk.infoblox.com/v1/records.v1.dnsdata.bulk.infoblox.com") | Out-Null
    }
    if ($NTPData -or $BackupAll) {
        $dataTypes.Add("ntp.bulk.infoblox.com/v1alpha1/ntpserviceconfigs.v1alpha1.ntp.bulk.infoblox.com") | Out-Null
    }
    if ($IPAMData -or $BackupAll) {
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/addressblocks.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/addresses.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/fixedaddresses.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/hagroups.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/hardwarefilters.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/ipspaces.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optioncodes.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optionfilters.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optiongroups.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/optionspaces.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/ranges.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/servers.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
		$dataTypes.Add("ipamdhcp.bulk.infoblox.com/v1/subnets.v1.ipamdhcp.bulk.infoblox.com") | Out-Null
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
    $Export = Query-CSP -Method "POST" -Uri "https://csp.infoblox.com/bulk/v1/export" -Data $splat

    if ($Export.success.message -eq "Export pending") {
        Write-Host "Data Export initalised successfully." -ForegroundColor Green
    } else {
        Write-Host "Data Export failed to initialise." -ForegroundColor Red
    }

}