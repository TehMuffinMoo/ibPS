---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1HAGroup

## SYNOPSIS
Updates an existing HA Group in BloxOneDDI

## SYNTAX

### noID
```
Set-B1HAGroup -Name <String> [-Mode <String>] [-PrimaryNode <String>] [-SecondaryNode <String>]
 [-Description <String>] [-Tags <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ID
```
Set-B1HAGroup [-Mode <String>] [-PrimaryNode <String>] [-SecondaryNode <String>] [-Description <String>]
 [-Tags <Object>] -id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing HA Group in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1HAGroup -Name "MyHAGroup" -Mode "active-passive" -PrimaryNode "bloxoneddihost1.mydomain.corp" -SecondaryNode "bloxoneddihost2.mydomain.corp" -Description "DHCP HA Group" -Tags @{"TagName"="TagValue"}
```

## PARAMETERS

### -Name
The name of the HA Group to modify

```yaml
Type: String
Parameter Sets: noID
Aliases:

Required: True
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
The hostname or FQDN of the primary BloxOneDDI Host to update

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
The hostname or FQDN of the secondary BloxOneDDI Host to update

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
The new description/comment to modify the HA Group to

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

### -id
{{ Fill id Description }}

```yaml
Type: String
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

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
