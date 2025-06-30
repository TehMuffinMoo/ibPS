---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1CustomList

## SYNOPSIS
Creates a new Custom List in Infoblox Threat Defense

## SYNTAX

```
New-B1CustomList [-Name] <String> [[-Description] <String>] [-Items] <Object> [-ThreatLevel] <String>
 [-ConfidenceLevel] <String> [[-Tags] <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a new named list in Infoblox Threat Defense.
These are referred to and displayed as Custom Lists within the CSP.

## EXAMPLES

### EXAMPLE 1
```powershell
$Items = @{
 "domain.com" = "Description 1"
 "domain1.com" = "Description 2"
 "123.123.123.123" = "Some IP Address"
}
New-B1CustomList -Name "Bad Stuff" -Description "This is a list of really bad stuff" -Items $Items -ThreatLevel HIGH -ConfidenceLevel MEDIUM
```

### EXAMPLE 2
```powershell
-- CSV File
 item,description
 domain3.com,Description 3
 domain4.com,Description 4
 234.234.234.234,Some Other IP Address
--
$Csv = Import-Csv $CsvFile
New-B1CustomList -Name "Not so bad stuff" -Description "This is a list of not so bad stuff" -Items $Csv -ThreatLevel MEDIUM -ConfidenceLevel HIGH
```

## PARAMETERS

### -Name
The name of the new custom list.

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

### -Description
The description for the new custom list.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items
Either a key-value hashtable of domains/IP addresses and their description or a list of objects with headers 'item' & 'description'.
See examples for usage

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ThreatLevel
Set the threat level for the custom list (info/low/medium/high)

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

### -ConfidenceLevel
Set the confidence level for the custom list (low/medium/high)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
A list of tags to add to the new Custom List

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
