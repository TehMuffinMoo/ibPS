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

    .Example
        Get-B1Export -data_ref (Get-B1BulkOperation -Name "Backup of all CSP data").data_ref -filePath "C:\Backups"

    .Example
        Get-B1Export -Name "Backup" -Description "Backup of all CSP data" -BackupAll -data_ref $data_ref
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Backup
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string]$data_ref,
        [Parameter(Mandatory=$true)]
        [string]$filePath
    )
    $B1Export = Query-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/storage?data_ref=$data_ref&direction=download"
    if ($B1Export.result.url) {
        $JSON = Invoke-RestMethod -Uri $B1Export.result.url
        $JSON.data | ConvertTo-Json -Depth 15 | Out-File $filePath -Force -Encoding utf8
    }
}