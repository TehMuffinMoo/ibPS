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
 -rdata <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
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
!!! warning ""
    **The `-rdata` parameter is excluded when `-Type` is MX or CAA**
The record value/data

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

## DYNAMIC PARAMETERS
### SRV Records
!!! info
    **These parameters are only available when `-Type` is SRV**

#### -Priority
The Priority parameter is required when creating an SRV Record and sets the record priority attribute.

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Weight
The Weight parameter is required when creating an SRV Record and sets the record weight attribute.

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Port
The Port parameter is required when creating an SRV Record and sets the record port attribute.

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### MX Records
!!! info
    **These parameters are only available when `-Type` is MX**

#### -Preference
The Preference parameter is required when creating an MX Record and sets the record preference attribute.

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Exchange
The Exchange parameter is required when creating an MX Record. This is the mail server (exchange) assosiated with the MX record.

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

### CAA Records
!!! info
    **These parameters are only available when `-Type` is CAA**

#### -CAFlag
The CAFlag parameter is required when creating a CAA Record and sets the CA Flag attribute.

```yaml
Type: Int
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -CATag
The CATag parameter is required when creating a CAA Record and sets the CA Tag attribute.

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

#### -CAValue
The CAValue parameter is required when creating a CAA Record and sets the CAA record value.

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

### -Force
Perform the operation without prompting for confirmation.
By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

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
