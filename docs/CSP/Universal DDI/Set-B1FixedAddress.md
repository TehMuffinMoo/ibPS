---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1FixedAddress

## SYNOPSIS
Updates an existing fixed addresses in Universal DDI IPAM

## SYNTAX

### IP
```
Set-B1FixedAddress -IP <String> -Space <String> [-NewName <String>] [-Description <String>]
 [-MatchType <String>] [-MatchValue <String>] [-DHCPOptions <Object>] [-Tags <Object>] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name
```
Set-B1FixedAddress -Name <String> -Space <String> [-NewName <String>] [-Description <String>]
 [-MatchType <String>] [-MatchValue <String>] [-DHCPOptions <Object>] [-Tags <Object>] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Object
```
Set-B1FixedAddress [-NewName <String>] [-Description <String>] [-MatchType <String>] [-MatchValue <String>]
 [-DHCPOptions <Object>] [-Tags <Object>] -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing fixed addresses in Universal DDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1FixedAddress -IP 10.10.100.12 -Name "New name" -Description "A new description"
```

### EXAMPLE 2
```powershell
Get-B1FixedAddress -IP 10.10.100.12 | Set-B1FixedAddress -MatchValue "ab:cd:ef:ab:cd:ef"
```

### EXAMPLE 3
```powershell
## Example usage when combined with Get-B1DHCPOptionCode

$DHCPOptions = @()
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

PS> Set-B1FixedAddress -IP 10.10.100.12 -Name "New name" -Description "A new description" -DHCPOptions $DHCPOptions
```

## PARAMETERS

### -IP
The IP of the fixed address

```yaml
Type: String
Parameter Sets: IP
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the fixed address

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

### -Space
Use this parameter to filter the list of fixed addresses by Space

```yaml
Type: String
Parameter Sets: IP, Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
The new name for the fixed address

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
The new description of the fixed address

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

### -MatchType
The match type for the new fixed address (i.e MAC)

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

### -MatchValue
The match value for the new fixed address (i.e ab:cd:ef:ab:cd:ef)

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

### -DHCPOptions
A list of DHCP Options you want to apply to the existing fixed address.
This will overwrite any existing DHCP options.

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

### -Tags
Any tags you want to apply to the fixed address

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
The Fixed Address Object to update.
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
