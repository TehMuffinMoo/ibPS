function Get-B1Export {
    <#
    .SYNOPSIS
        Retrieves a BloxOneDDI Export/Backup

    .DESCRIPTION
        This function is used to retrieve a BloxOneDDI Export/Backup

    .PARAMETER data_ref
        The data_ref provided by the Get-B1BulkOperation function. The job will appear here once started with Start-B1Export

    .PARAMETER filePath
        The local file path where the export should be downloaded to

    .EXAMPLE
        PS> Get-B1Export -data_ref (Get-B1BulkOperation -Name "Backup of all CSP data").data_ref -filePath "C:\Backups"

    .EXAMPLE
        PS> Get-B1Export -Name "Backup" -Description "Backup of all CSP data" -BackupAll -data_ref $data_ref

    .EXAMPLE
        PS> $ExportName = "B1-Export-$((Get-Date).ToString('dd-MM-yy hh-mm-ss'))"

        PS> Start-B1Export -Name $ExportName -BackupAll
        PS> while (($BulkOp = Get-B1BulkOperation -Name $ExportName -Strict).overall_status -ne "Completed") {
              Write-Host "Waiting for export to complete.."
              Wait-Event -Timeout 5
            }
        PS> $BulkOp | Get-B1Export -filePath "/tmp/$($ExportName)"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Backup
    #>
    param(
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
          )]
        [string]$data_ref,
        [Parameter(Mandatory=$true)]
        [string]$filePath
    )
    if ($ENV:IBPSDebug -eq "Enabled") {
        Write-Debug "URI: $(Get-B1CSPUrl)/bulk/v1/storage?data_ref=$data_ref&direction=download"
    }
    $B1Export = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/storage?data_ref=$data_ref&direction=download"
    if ($B1Export.result.url) {
        $JSON = Invoke-RestMethod -Uri $B1Export.result.url
        $JSON.data | ConvertTo-Json -Depth 15 | Out-File $filePath -Force -Encoding utf8
    }
}