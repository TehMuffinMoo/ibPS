---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DossierLookup

## SYNOPSIS
Retrieves details about a BloxOne Threat Defense Dossier Lookup

## SYNTAX

### None (Default)
```
Get-B1DossierLookup -job_id <String> [<CommonParameters>]
```

### Pending
```
Get-B1DossierLookup -job_id <String> [-Pending] [<CommonParameters>]
```

### Results
```
Get-B1DossierLookup -job_id <String> [-Results] [<CommonParameters>]
```

### TaskID
```
Get-B1DossierLookup -job_id <String> [-task_id <String>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to retrieve details about a BloxOne Threat Defense Dossier Lookup

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Results
```

### EXAMPLE 2
```powershell
Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -Pending
```

### EXAMPLE 3
```powershell
Get-B1DossierLookup -job_id 01234567-c123-4567-8912a-123456abcdef -task_id b1234567-0012-456a-98da-4a3323dds3
```

### EXAMPLE 4
```powershell
$Lookup = Start-B1TDDossierLookup -Type ip 1.1.1.1
PS> $Lookup | Get-B1DossierLookup -Results

task_id : 86655f48-944b-4871-9483-de1f0f0f820f
params  : @{type=ip; target=1.1.1.1; source=whois}
status  : success
time    : 47
v       : 3.0.0
data    : @{response=}

task_id : fa7b0d3e-68a5-4d15-a2e1-42e791fc76d1
params  : @{type=ip; target=1.1.1.1; source=atp}
status  : success
time    : 230
v       : 3.0.0
data    : @{record_count=2771; threat=System.Object[]}
```

## PARAMETERS

### -job_id
The job ID given when starting the lookup using Start-B1TDDossierLookup.
Accepts pipeline input from Start-B1TDDossierLookup cmdlet

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Pending
Using this switch will return whether the job has completed or is still pending

```yaml
Type: SwitchParameter
Parameter Sets: Pending
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Results
Using this switch will return the results for the lookup job

```yaml
Type: SwitchParameter
Parameter Sets: Results
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -task_id
Used to filter the results by individual task ID

```yaml
Type: String
Parameter Sets: TaskID
Aliases:

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
