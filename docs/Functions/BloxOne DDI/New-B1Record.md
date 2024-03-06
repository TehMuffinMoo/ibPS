---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1Record

## SYNOPSIS
Creates a new DNS record in BloxOneDDI

## SYNTAX

```
New-B1Record [-Type] <String> [-Name] <String> [-Zone] <String> [-view] <String> [[-TTL] <Int32>]
 [[-Description] <String>] [[-CreatePTR] <Boolean>] [[-Tags] <Object>] [-SkipExistsErrors] [-IgnoreExists]
 -rdata <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new DNS record in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default" -rdata "10.10.30.10" -TTL 300
```

## PARAMETERS

### -Type
The record type to create

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

### -Name
The name of the record to create

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

### -Zone
The zone which the record will be created in

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -view
The DNS View the record will be created in

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TTL
Use this parameter to set a custom TTL when creating the record

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the record to be created

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatePTR
Whether to create an associated PTR record (where applicable).
This defaults to $true

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the record

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipExistsErrors
Whether to skip errors if the record already exists.
Default is $false

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

### -IgnoreExists
Whether to ignore if a record already exists and attempt to create it anyway

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

### -rdata
Record Value

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
