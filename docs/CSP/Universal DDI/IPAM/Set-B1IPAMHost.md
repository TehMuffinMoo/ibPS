---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1IPAMHost

## SYNOPSIS
Updates an existing IPAM Host Object in Universal DDI IPAM

## SYNTAX

```
Set-B1IPAMHost [-Object] <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing IPAM Host Object in Universal DDI IPAM.
This only accepts pipeline input.

## EXAMPLES

### EXAMPLE 1
```powershell
$MyHost = Get-B1IPAMHost "my-host"
PS> $MyHost.addresses = @(
        @{
            address = "10.0.0.1"
            space = (Get-B1Space -Name 'my-space' -Strict).id
            mac_addr = "aa:bb:cc:dd:ee:ff"
            enable_dhcp = $true
        }
    )
PS> $MyHost | Set-B1IPAMHost
```

## PARAMETERS

### -Object
The Range Object to update.
Accepts pipeline input

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
