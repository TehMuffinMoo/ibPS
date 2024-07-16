---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1CustomList

## SYNOPSIS
Updates a custom list object

## SYNTAX

### Default
```
Set-B1CustomList -Name <String> [-NewName <String>] [-Description <String>] [-Items <Object>]
 [-AddItems <Object>] [-RemoveItems <Object>] [-ThreatLevel <String>] [-ConfidenceLevel <String>]
 [-Tags <Object>] [<CommonParameters>]
```

### Pipeline
```
Set-B1CustomList [-NewName <String>] [-Description <String>] [-Items <Object>] [-AddItems <Object>]
 [-RemoveItems <Object>] [-ThreatLevel <String>] [-ConfidenceLevel <String>] [-Tags <Object>] -Object <Object>
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a custom list object within BloxOne Threat Defense

## EXAMPLES

### EXAMPLE 1
```powershell
$Items = @{
 "domain.com" = "Description 1"
 "domain1.com" = "Description 2"
 "123.123.123.123" = "Some IP Address"
}
Get-B1CustomList | Where-Object {$_.name -eq "My Custom List"} | Set-B1CustomList -AddItems $Items

confidence_level : HIGH
created_time     : 5/3/2024 4:43:02 PM
description      : New Description
id               : 123456
item_count       : 4
items            : {123.123.123.123/32, somedomain.com, domain1.com, domain.com}
items_described  : {@{description=Some IP Address; item=123.123.123.123/32}, @{description=A Domain!; item=somedomain.com}, @{description=Description 2; item=domain1.com}, @{description=Description 1; item=domain.com}}
name             : My Custom List
policies         : {}
tags             : @{Owner=Me}
threat_level     : MEDIUM
type             : custom_list
updated_time     : 5/3/2024 6:10:44 PM
```

### EXAMPLE 2
```powershell
$Items = @("domain.com","domain1.com","123.123.123.123")
Get-B1CustomList | Where-Object {$_.name -eq "My Custom List"} | Set-B1CustomList -RemoveItems $Items

confidence_level : HIGH
created_time     : 5/3/2024 4:43:02 PM
description      : New Description
id               : 123456
item_count       : 1
items            : {somedomain.com}
items_described  : {@{description=A Domain!; item=somedomain.com}}
name             : My Custom List
policies         : {}
tags             : @{Owner=Me}
threat_level     : MEDIUM
type             : custom_list
updated_time     : 5/3/2024 6:11:32 PM
```

## PARAMETERS

### -Name
The name of the Custom List to update.

Whilst this is here, the API does not currently support filtering by name.
(01/04/24)

For now, you should instead use pipeline to update objects as shown in the examples.

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
Use -NewName to update the name of the Custom List

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
The new description for the Custom List object

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

### -Items
Enter a key-value hashtable of domains/IP addresses and their description or a list of objects with headers 'item' & 'description'.
See examples for usage

This will overwrite the current list of domains/addresses.
If you only want to add or remove items then you should use the corresponding -AddItems or -RemoveItems parameters.

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

### -AddItems
Enter a key-value hashtable of domains/IP addresses and their description or a list of objects with headers 'item' & 'description'.

Duplicate items will be silently skipped, only new items are appended to the custom list.

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

### -RemoveItems
Enter a list of domains/IP addresses, or a hashtable/object the same format as -Items & -AddItems

These items will be removed from the custom list, if the item does not exist it will be silently skipped.

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

### -ThreatLevel
Set the threat level for the custom list (info/low/medium/high)

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

### -ConfidenceLevel
Set the confidence level for the custom list (low/medium/high)

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
The list of tags to apply to the custom list.
This will overwrite the current list of tags.

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
The Custom List object to update.
Accepts pipeline input from Get-B1CustomList.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
