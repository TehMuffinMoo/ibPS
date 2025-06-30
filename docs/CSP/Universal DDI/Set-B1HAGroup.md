---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1HAGroup

## SYNOPSIS
Updates an existing HA Group in Universal DDI

## SYNTAX

### Default
```
Set-B1HAGroup -Name <String> [-NewName <String>] [-Description <String>] [-Mode <String>]
 [-PrimaryNode <String>] [-SecondaryNode <String>] [-Tags <Object>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Object
```
Set-B1HAGroup [-NewName <String>] [-Description <String>] [-Mode <String>] [-PrimaryNode <String>]
 [-SecondaryNode <String>] [-Tags <Object>] -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing HA Group in Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1HAGroup -Name "MyHAGroup" -Mode "active-passive" -PrimaryNode "ddihost1.mydomain.corp" -SecondaryNode "ddihost2.mydomain.corp" -Description "DHCP HA Group" -Tags @{"TagName"="TagValue"}
```

## PARAMETERS

### -Name
The name of the HA Group to modify

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Use -NewName to update the name of the HA Group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The new description for the HA Group

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
The mode to update the HA Group to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrimaryNode
The hostname or FQDN of the primary NIOS-X Host to update

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecondaryNode
The hostname or FQDN of the secondary NIOS-X Host to update

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Any tags you want to apply to the HA Group

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The HA Group Object to update.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: Object
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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
