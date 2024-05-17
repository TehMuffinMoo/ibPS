---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1Record

## SYNOPSIS
Updates an existing DNS record in BloxOneDDI

## SYNTAX

### RDATA
```
Set-B1Record -Type <String> -View <String> -CurrentRDATA <String> [-rdata <String>] [-NewName <String>]
 [-TTL <Int32>] [-Description <String>] [-Priority <Int32>] [-Weight <Int32>] [-Port <Int32>] [-State <String>]
 [-Tags <Object>] [<CommonParameters>]
```

### FQDN
```
Set-B1Record -Type <String> -FQDN <String> -View <String> [-rdata <String>] [-NewName <String>] [-TTL <Int32>]
 [-Description <String>] [-Priority <Int32>] [-Weight <Int32>] [-Port <Int32>] [-State <String>]
 [-Tags <Object>] [<CommonParameters>]
```

### NameAndZone
```
Set-B1Record -Type <String> -Name <String> -Zone <String> -View <String> [-rdata <String>] [-NewName <String>]
 [-TTL <Int32>] [-Description <String>] [-Priority <Int32>] [-Weight <Int32>] [-Port <Int32>] [-State <String>]
 [-Tags <Object>] [<CommonParameters>]
```

### Object
```
Set-B1Record [-rdata <String>] [-NewName <String>] [-TTL <Int32>] [-Description <String>] [-Priority <Int32>]
 [-Weight <Int32>] [-Port <Int32>] [-State <String>] [-Tags <Object>] -Object <Object> [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing DNS record in BloxOneDDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default" -rdata "10.10.50.10" -TTL 600
```

## PARAMETERS

### -Type
The type of the record to update

```yaml
Type: String
Parameter Sets: RDATA, FQDN, NameAndZone
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the record to update.

```yaml
Type: String
Parameter Sets: NameAndZone
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Zone
The zone of the record to update

```yaml
Type: String
Parameter Sets: NameAndZone
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FQDN
The FQDN of the record to update

```yaml
Type: String
Parameter Sets: FQDN
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -View
The DNS View the record exists in

```yaml
Type: String
Parameter Sets: RDATA, FQDN, NameAndZone
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CurrentRDATA
Optional parameter to select record based on current RDATA.
Will be deprecated once pipeline input is implemented.

```yaml
Type: String
Parameter Sets: RDATA
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rdata
The RDATA to update the record to

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

### -NewName
Use -NewName to update the name of the record

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

### -TTL
The TTL to update the record to

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

### -Description
The description to update the record to

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

### -Priority
Used to update the priority for applicable records.
(i.e SRV)

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

### -Weight
Used to update the weight for applicable records.
(i.e SRV)

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

### -Port
Used to update the port for applicable records.
(i.e SRV)

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

### -State
Set whether the DNS Record is enabled or disabled.

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
Any tags you want to apply to the record

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
The Range Object to update.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
