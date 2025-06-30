---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Start-B1DossierBatchLookup

## SYNOPSIS
Perform multiple simultaneous lookups against the Infoblox Threat Defense Dossier

## SYNTAX

```
Start-B1DossierBatchLookup [-Type] <String> [-Target] <String[]> [-Source] <String[]> [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to perform multiple simultaneous lookups against the Infoblox Threat Defense Dossier

## EXAMPLES

### EXAMPLE 1
```powershell
Start-B1DossierBatchLookup -Type ip -Target "1.1.1.1","1.0.0.1" -Source "apt","mandiant"

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
A list of supported sources can be obtained by using the Get-B1DossierSupportedSources cmdlet

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
