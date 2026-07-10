---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1ForwardLookingDelegation

## SYNOPSIS
Updates an existing forward looking delegation in Universal DDI IPAM

## SYNTAX

### Subnet
```
Set-B1ForwardLookingDelegation [-Subnet <String>] [-NewName <String>] [-Description <String>] [-CIDR <Int32>]
 [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Set-B1ForwardLookingDelegation [-Name <String>] [-NewName <String>] [-Description <String>] [-CIDR <Int32>]
 [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Object
```
Set-B1ForwardLookingDelegation [-NewName <String>] [-Description <String>] [-CIDR <Int32>] [-Tags <Object>]
 -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing forward looking delegation in Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1ForwardLookingDelegation -Subnet '10.1.5.0/24' -NewName "New name" -Description "Updated description" -Tags @{Environment="Test";Owner="Admin"}
```

### EXAMPLE 2
```powershell
Get-B1ForwardLookingDelegation -Name "Delegation-1" -Realm "Realm-1" | Set-B1ForwardLookingDelegation -CIDR 15 -Description "Updated to /15" -Tags @{Environment="Test";Owner="Admin"}
```

## PARAMETERS

### -Subnet
The subnet of the forward looking delegation you want to update in CIDR notation

# .PARAMETER Realm
#     The name of the forward looking delegation realm the forward looking delegation is associated with

```yaml
Type: String
Parameter Sets: Subnet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the forward looking delegation you want to update

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Use -NewName to update the name of the forward looking delegation

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
The new description for the forward looking delegation

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

### -CIDR
The new CIDR of the forward looking delegation you are updating

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
A list of tags to update on the forward looking delegation.
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
The Forward Looking Delegation Object to update.
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
