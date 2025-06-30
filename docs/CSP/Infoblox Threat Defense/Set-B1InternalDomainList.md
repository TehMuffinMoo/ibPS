---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1InternalDomainList

## SYNOPSIS
Updates an existing Internal Domain list

## SYNTAX

### None
```
Set-B1InternalDomainList -Name <String> [-Description <String>] [-Domains <Object>] [-Tags <Object>] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Pipeline
```
Set-B1InternalDomainList -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing Internal Domain list

## EXAMPLES

### EXAMPLE 1
```powershell
$List = Get-B1InternalDomainList -Name 'My List'
$List.internal_domains += 'new.corp.local'
$List | Set-B1InternalDomainList

Internal Domain List  updated successfully.

created_time     : 1/1/0001 12:00:00AM
description      : A list of domains
id               : 793538
internal_domains : {new.corp.local, ext.domain.corp, mydomain.corp, partner.corp}
is_default       : False
name             : My List
tags             : @{Owner=Me}
updated_time     : 1/1/0001 12:00:00AM
```

## PARAMETERS

### -Name
The name of the Internal Domain list to update.
The name can be updated by changing the value of name when using pipeline input

```yaml
Type: String
Parameter Sets: None
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The new description for the Internal Domain list

```yaml
Type: String
Parameter Sets: None
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domains
The list of domains to update the Internal Domain list with.
This will overwrite the current list, so the existing list should be obtained and subtracted/appended prior to submission.

```yaml
Type: Object
Parameter Sets: None
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
A list of tags to update the Internal Domain list with.
This will overwrite existing tags.

```yaml
Type: Object
Parameter Sets: None
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
The Internal Domain List object to update.
Expects pipeline input

```yaml
Type: Object
Parameter Sets: Pipeline
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
