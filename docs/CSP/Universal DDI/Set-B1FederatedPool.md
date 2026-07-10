---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1FederatedPool

## SYNOPSIS
Updates an existing federated pool in Universal DDI IPAM

## SYNTAX

### Name
```
Set-B1FederatedPool -Name <String> -Realm <String> [-NewName <String>] [-Description <String>] [-Tags <Object>]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Set-B1FederatedPool [-NewName <String>] [-Description <String>] [-Tags <Object>] -Object <Object> [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing federated pool in Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1FederatedPool -Name "Pool-1" -Realm "Realm-1" -NewName "Pool-2" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}
```

### EXAMPLE 2
```powershell
Get-B1FederatedPool -Name "Pool-1" -Realm "Realm-1" | Set-B1FederatedPool -NewName "Pool-2" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}
```

## PARAMETERS

### -Name
The name of the federated pool you want to update

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Realm
The name of the federated realm the federated pool is associated with

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Use -NewName to update the name of the federated pool

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
The new description for the federated pool

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
A list of tags to update on the federated pool.
This will replace existing tags, so would normally be a combined list of existing and new tags

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
The Federated Pool Object to update.
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
