---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1Export

## SYNOPSIS
Retrieves a BloxOneDDI Export/Backup

## SYNTAX

```
Get-B1Export [-data_ref] <String> [-filePath] <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve a BloxOneDDI Export/Backup

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1Export -data_ref (Get-B1BulkOperation -Name "Backup of all CSP data").data_ref -filePath "C:\Backups"
```

### EXAMPLE 2
```powershell
Get-B1Export -Name "Backup" -Description "Backup of all CSP data" -BackupAll -data_ref $data_ref
```

### EXAMPLE 3
```powershell
$ExportName = "B1-Export-$((Get-Date).ToString('dd-MM-yy hh-mm-ss'))"

PS> Start-B1Export -Name $ExportName -BackupAll
PS> while (($BulkOp = Get-B1BulkOperation -Name $ExportName -Strict).overall_status -ne "Completed") {
      Write-Host "Waiting for export to complete.."
      Wait-Event -Timeout 5
    }
PS> $BulkOp | Get-B1Export -filePath "/tmp/$($ExportName)"
```

## PARAMETERS

### -data_ref
The data_ref provided by the Get-B1BulkOperation function.
The job will appear here once started with Start-B1Export

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
The local file path where the export should be downloaded to

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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
