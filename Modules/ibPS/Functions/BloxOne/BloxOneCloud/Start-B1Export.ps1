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

    .PARAMETER DNSConfig
        Use this switch to enable DNS Configuration to be included in the export/backup

    .PARAMETER DNSData
        Use this switch to enable DNS Data to be included in the export/backup

    .PARAMETER NTPData
        Use this switch to enable NTP Data to be included in the export/backup

    .PARAMETER IPAMData
        Use this switch to enable IPAM Data to be included in the export/backup

    .PARAMETER KeyData
        Use this switch to enable Key Data to be included in the export/backup

    .PARAMETER ThreatDefense
        Use this switch to enable Threat Defense Configuration to be included in the export/backup

    .PARAMETER Bootstrap
        Use this switch to enable BloxOne Host Bootstrap Configuration to be included in the export/backup

    .PARAMETER B1Hosts
        Use this switch to enable BloxOne Host Configuration to be included in the export/backup

    .PARAMETER Redirects
        Use this switch to enable Custom Redirects to be included in the export/backup

    .PARAMETER Tags
        Use this switch to enable Tag Configuration to be included in the export/backup

    .PARAMETER BackupAll
        Use this switch to enable all configuration & data types to be included in the export/backup

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

    .EXAMPLE
        PS> Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -DNSConfig -DNSData -IPAMData -KeyData -ThreatDefense -Bootstrap -B1Hosts -Redirects -Tags

    .EXAMPLE
        PS> Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -BackupAll

    .EXAMPLE
        PS> $ExportName = "B1-Export-$((Get-Date).ToString('dd-MM-yy hh-mm-ss'))"

        PS> Start-B1Export -Name $ExportName -BackupAll
        PS> while (($BulkOp = Get-B1BulkOperation -Name $ExportName -Strict).overall_status -ne "Completed") {
                Write-Host "Waiting for export to complete.."
                Wait-Event -Timeout 5
            }
        PS> $BulkOp | Get-B1Export -filePath "/tmp/$($ExportName)"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Backup
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Low'
    )]
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
      [Alias('OnPremHosts')]
      [Switch]$B1Hosts,
      [Switch]$Redirects,
      [Switch]$Tags,
      [Switch]$BackupAll,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $splat = @{
        "name" = $Name
        "description" = $Description
        "export_format" = "json"
        "error_handling_id" = "1"
    }

    $dataTypes = @()

    if ($DNSConfig -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'dnsconfig').DataType ## Authoritative Zones / Forward Zones / DNS Config Profiles / DNS Views
    }
    if ($DNSData -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'dnsdata').DataType ## DNS Records
    }
    if ($NTPData -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'ntpserviceconfigs').DataType ## NTP Configuration
    }
    if ($IPAMData -or $BackupAll) {
        ### Includes;
        ## IPAM Address Blocks
        ## Addresses
        ## Fixed Addresses
        ## Hardware Filters
        ## HA Groups
        ## IP Spaces
        ## DHCP Option Codes
        ## DHCP Option Filters
        ## DHCP Option Groups
        ## DHCP Option Spaces
        ## DHCP Ranges
        ## IPAM Subnets
        ## DHCP Hosts
        ## DHCP Config Profiles
		$dataTypes += (Build-BulkExportTypes -Types 'ipamdhcp').DataType
    }
    if ($KeyData -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'tsigkeys').DataType ## TSIG Keys
    }
    if ($ThreatDefense -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'atcapi').DataType ## Threat Defense Types
    }
    if ($Bootstrap -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'bootstrap').DataType ## Bootstrap / Host Config
    }
    if ($B1Hosts -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'hosts').DataType ## B1 Host Config / Host Config
    }
    if ($Redirects -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'customredirects').DataType ## Custom Redirects
    }
    if ($Tags -or $BackupAll) {
        $dataTypes += (Build-BulkExportTypes -Types 'tagging').DataType ## Tagging
    }
    if ($dataTypes) {
        $splat | Add-Member -Name "data_types" -Value $dataTypes -MemberType NoteProperty
    }
    $splat = $splat | ConvertTo-Json
    if($PSCmdlet.ShouldProcess("Start BloxOne Data Export`n$(JSONPretty($splat))","Start BloxOne Data Export",$MyInvocation.MyCommand)){
        $Export = Invoke-CSP -Method "POST" -Uri "$(Get-B1CSPUrl)/bulk/v1/export" -Data $splat
        if ($Export.success.message -eq "Export pending") {
            Write-Host "Data Export initalised successfully." -ForegroundColor Green
            $Export
        } else {
            Write-Host "Data Export failed to initialise." -ForegroundColor Red
        }
    }
}