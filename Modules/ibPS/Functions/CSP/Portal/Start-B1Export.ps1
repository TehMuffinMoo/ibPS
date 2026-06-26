function Start-B1Export {
    <#
    .SYNOPSIS
        Initiates an Infoblox Portal Export/Backup

    .DESCRIPTION
        This function is used to initiate an Infoblox Portal Export/Backup

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
        Use this switch to enable NIOS-X Host Bootstrap Configuration to be included in the export/backup

    .PARAMETER B1Hosts
        Use this switch to enable NIOS-X Host Configuration to be included in the export/backup

    .PARAMETER Redirects
        Use this switch to enable Custom Redirects to be included in the export/backup

    .PARAMETER Tags
        Use this switch to enable Tag Configuration to be included in the export/backup

    .PARAMETER BackupAll
        Use this switch to enable all configuration & data types to be included in the export/backup

    .PARAMETER Format
        The format to use for the export/backup. Valid values are "json" or "csv". Default is "json"

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
        PS> $BulkOp | Receive-B1Export -filePath "/tmp/$($ExportName)"

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
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$DNSData,
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$NTPData,
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$IPAMData,
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$KeyData,
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$ThreatDefense,
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$Bootstrap,
      [parameter(ParameterSetName="BackupSelective")]
      [Alias('OnPremHosts')]
      [Switch]$B1Hosts,
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$Redirects,
      [parameter(ParameterSetName="BackupSelective")]
      [Switch]$Tags,
      [parameter(ParameterSetName="BackupAll")]
      [Switch]$BackupAll,
      [ValidateSet("json","csv")]
      [String]$Format = "json",
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $splat = @{
        "name" = $Name
        "description" = $Description
        "export_format" = $Format
        "error_handling_id" = "1"
    }

    $dataTypes = @()

    if ($DNSConfig -or $BackupAll) {
        ## Only add if value is returned, to avoid null being added to array
        Build-BulkExportTypes -Types 'dnsconfig' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($DNSData -or $BackupAll) {
        Build-BulkExportTypes -Types 'dnsdata' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($NTPData -or $BackupAll) {
        Build-BulkExportTypes -Types 'ntpserviceconfigs' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($IPAMData -or $BackupAll) {
		Build-BulkExportTypes -Types 'ipamdhcp' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($KeyData -or $BackupAll) {
        Build-BulkExportTypes -Types 'tsigkeys' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($ThreatDefense -or $BackupAll) {
        Build-BulkExportTypes -Types 'atcapi' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($Bootstrap -or $BackupAll) {
        Build-BulkExportTypes -Types 'bootstrap' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($B1Hosts -or $BackupAll) {
        Build-BulkExportTypes -Types 'hosts' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($Redirects -or $BackupAll) {
        Build-BulkExportTypes -Types 'customredirects' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($Tags -or $BackupAll) {
        Build-BulkExportTypes -Types 'tagging' -Format $Format | ForEach-Object {
            if ($_.DataType) {
                $dataTypes += $_.DataType
            }
        }
    }
    if ($dataTypes) {
        $splat | Add-Member -Name "data_types" -Value $dataTypes -MemberType NoteProperty
    }

    $splat = $splat | ConvertTo-Json
    if($PSCmdlet.ShouldProcess("Start Data Export`n$(JSONPretty($splat))","Start Data Export",$MyInvocation.MyCommand)){
        $Export = Invoke-CSP -Method "POST" -Uri "$(Get-B1CSPUrl)/bulk/v1/export" -Data $splat
        if ($Export.success.message -eq "Export pending") {
            Write-Host "Data Export initalised successfully." -ForegroundColor Green
            $Export
        } else {
            Write-Host "Data Export failed to initialise." -ForegroundColor Red
        }
    }
}