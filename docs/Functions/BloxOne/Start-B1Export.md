---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Start-B1Export

## SYNOPSIS
Initiates a BloxOneDDI Export/Backup

## SYNTAX

```
Start-B1Export [-Name] <String> [[-Description] <String>] [-DNSConfig] [-DNSData] [-NTPData] [-IPAMData]
 [-KeyData] [-ThreatDefense] [-Bootstrap] [-OnPremHosts] [-Redirects] [-Tags] [-BackupAll]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to initiate a BloxOneDDI Export/Backup

## EXAMPLES

### EXAMPLE 1
```powershell
Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -DNSConfig -DNSData -IPAMData -KeyData -ThreatDefense -Bootstrap -OnPremHosts -Redirects -Tags
```

### EXAMPLE 2
```powershell
Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -BackupAll
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

### -Name
The name to give the export/backup

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description to give the export/backup

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DNSConfig
{{ Fill DNSConfig Description }}

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

### -DNSData
{{ Fill DNSData Description }}

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

### -NTPData
{{ Fill NTPData Description }}

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

### -IPAMData
{{ Fill IPAMData Description }}

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

### -KeyData
{{ Fill KeyData Description }}

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

### -ThreatDefense
{{ Fill ThreatDefense Description }}

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

### -Bootstrap
{{ Fill Bootstrap Description }}

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

### -OnPremHosts
{{ Fill OnPremHosts Description }}

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

### -Redirects
{{ Fill Redirects Description }}

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

### -Tags
{{ Fill Tags Description }}

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

### -BackupAll
{{ Fill BackupAll Description }}

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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
