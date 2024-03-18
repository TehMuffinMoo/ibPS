---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version: https://www.powershellgallery.com/packages/Subnet/1.0.14/Content/Public%5CGet-Subnet.ps1
schema: 2.0.0
---

# Start-B1TDDossierBatchLookup

## SYNOPSIS
Perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

## SYNTAX

```
Start-B1TDDossierBatchLookup [-Type] <String> [-Target] <String[]> [-Source] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is used to perform multiple simultaneous lookups against the BloxOne Threat Defense Dossier

## EXAMPLES

### EXAMPLE 1
```powershell
Start-B1TDDossierBatchLookup -Type ip -Target "1.1.1.1","1.0.0.1" -Source "apt","mandiant"

status  job_id                               job
------  ------                               ---                                                                                                                                                                                                                                               
pending 12345678-2228-433e-9578-12345678980d @{id=12345678-2228-433e-9578-12345678980d; state=created; status=pending; create_ts=1709744311615; create_time=3/6/2024 4:58:31PM; start_ts=1709744311615; start_time=3/6/2024 4:58:31PM; request_ttl=0; result_ttl=3600; pending_tasks=System.Ob…
```

## PARAMETERS

### -Type
The indicator type to search on

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

### -Target
The indicator target(s) to search on

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
The sources to query.
Multiple sources can be specified.
A list of supported sources can be obtained by using the Get-B1TDDossierSupportedSources cmdlet

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
