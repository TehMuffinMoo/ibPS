function Receive-B1Export {
    <#
    .SYNOPSIS
        Retrieves an Infoblox Portal Export/Backup

    .DESCRIPTION
        This function is used to retrieve a Infoblox Portal Export/Backup

    .PARAMETER filePath
        The local file path where the export should be saved to.

    .PARAMETER data_ref
        The data_ref provided by the Get-B1BulkOperation or Get-B1Export function. This accepts pipeline input.

    .EXAMPLE
        PS> Receive-B1Export -filePath "C:\Backups" -data_ref (Get-B1BulkOperation -Name "Backup of all CSP data").data_ref

    .EXAMPLE
        PS> $ExportName = "B1-Export-$((Get-Date).ToString('dd-MM-yy hh-mm-ss'))"

        PS> Start-B1Export -Name $ExportName -BackupAll
        PS> while (($ExportJob = Get-B1Export -Name $ExportName -Strict).overall_status -ne "Completed") {
              Write-Host "Waiting for export to complete.."
              Wait-Event -Timeout 5
            }
        PS> $ExportJob | Receive-B1Export -filePath "/tmp/$($ExportName)"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Backup
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$filePath,
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
        )]
        [string]$data_ref
    )
    process {
        $B1Export = Invoke-CSP -Method "GET" -Uri "$(Get-B1CSPUrl)/bulk/v1/storage?data_ref=$data_ref&direction=download"
        if ($B1Export.result.url) {
            $FileDownload = Invoke-RestMethod -Uri $B1Export.result.url
            if ($filePath | Test-Path -PathType Container) {
                $filePathSafe = "$($filePath)/$($data_ref.Split([IO.Path]::GetInvalidFileNameChars()) -join '_' -replace ' ','_')"
            } else {
                $filePathSafe = $filePath
            }

            switch ($data_ref.split('.')[1]) {
                "csv" {
                    $FileDownload | ConvertFrom-Csv | ConvertTo-Csv -NoTypeInformation | Out-File $filePathSafe -Force -Encoding utf8
                    break
                }
                "json" {
                    $FileDownload | ConvertTo-Json -Depth 15 | Out-File $filePathSafe -Force -Encoding utf8
                    break
                }
            }
            if (Test-Path $filePathSafe) {
                Write-Host "Export downloaded and saved to: $($filePathSafe)" -ForegroundColor Green
            } else {
                Write-Host "Error. Unable to save export to: $($filePathSafe)" -ForegroundColor Red
            }
        }
    }
}