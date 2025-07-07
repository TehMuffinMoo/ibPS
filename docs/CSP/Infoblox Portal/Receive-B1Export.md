---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Receive-B1Export

## SYNOPSIS
Retrieves an Infoblox Portal Export/Backup

## SYNTAX

```
Receive-B1Export [-data_ref] <String> [-filePath] <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve a Infoblox Portal Export/Backup

## EXAMPLES

### EXAMPLE 1
```powershell
Receive-B1Export -data_ref (Get-B1BulkOperation -Name "Backup of all CSP data").data_ref -filePath "C:\Backups"
```

### EXAMPLE 2
```powershell
$ExportName = "B1-Export-$((Get-Date).ToString('dd-MM-yy hh-mm-ss'))"

PS> Start-B1Export -Name $ExportName -BackupAll
PS> while (($ExportJob = Get-B1Export -Name $ExportName -Strict).overall_status -ne "Completed") {
      Write-Host "Waiting for export to complete.."
      Wait-Event -Timeout 5
    }
PS> $ExportJob | Receive-B1Export -filePath "/tmp/$($ExportName)"
```

## PARAMETERS

### -data_ref
The data_ref provided by the Get-B1BulkOperation or Get-B1Export function.
This accepts pipeline input.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -filePath
The local file path where the export should be saved to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
