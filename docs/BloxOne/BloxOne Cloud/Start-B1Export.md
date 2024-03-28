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
 [-KeyData] [-ThreatDefense] [-Bootstrap] [-B1Hosts] [-Redirects] [-Tags] [-BackupAll] [<CommonParameters>]
```

## DESCRIPTION
This function is used to initiate a BloxOneDDI Export/Backup

## EXAMPLES

### EXAMPLE 1
```powershell
Start-B1Export -Name "Backup" -Description "Backup of all CSP data" -DNSConfig -DNSData -IPAMData -KeyData -ThreatDefense -Bootstrap -B1Hosts -Redirects -Tags
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
Use this switch to enable DNS Configuration to be included in the export/backup

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
Use this switch to enable DNS Data to be included in the export/backup

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
Use this switch to enable NTP Data to be included in the export/backup

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
Use this switch to enable IPAM Data to be included in the export/backup

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
Use this switch to enable Key Data to be included in the export/backup

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
Use this switch to enable Threat Defense Configuration to be included in the export/backup

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
Use this switch to enable BloxOne Host Bootstrap Configuration to be included in the export/backup

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

### -B1Hosts
Use this switch to enable BloxOne Host Configuration to be included in the export/backup

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: OnPremHosts

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Redirects
Use this switch to enable Custom Redirects to be included in the export/backup

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
Use this switch to enable Tag Configuration to be included in the export/backup

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
Use this switch to enable all configuration & data types to be included in the export/backup

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
