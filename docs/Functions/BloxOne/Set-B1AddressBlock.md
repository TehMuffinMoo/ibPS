---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1AddressBlock

## SYNOPSIS
Updates an existing address block in BloxOneDDI IPAM

## SYNTAX

### noID
```
Set-B1AddressBlock -Subnet <String> -CIDR <Int32> -Space <String> [-Name <String>] [-DHCPOptions <Object>]
 [-Description <String>] [-DHCPLeaseSeconds <String>] [-DDNSDomain <String>] [-Tags <Object>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### ID
```
Set-B1AddressBlock [-Name <String>] [-DHCPOptions <Object>] [-Description <String>]
 [-DHCPLeaseSeconds <String>] [-DDNSDomain <String>] [-Tags <Object>] -id <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update an existing address block in BloxOneDDI IPAM

## EXAMPLES

### EXAMPLE 1
```powershell
## Example usage when combined with Get-B1DHCPOptionCode
$DHCPOptions = @()
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}
$DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="10.10.10.10,10.10.10.11";}

PS> Set-B1AddressBlock -Subnet "10.10.100.0" -Name "Updated name" -Space "Global" -Description "Comment for description" -DHCPOptions $DHCPOptions
```

## PARAMETERS

### -Subnet
The network address of the address block you want to update

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

### -CIDR
The CIDR suffix of the address block you want to update

```yaml
Type: Int32
Parameter Sets: noID
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Space
The IPAM space where the address block is located

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

### -Name
The new name for the address block

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
A list of DHCP Options you want to update the address block with.
This will overwrite existing options.

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

### -Description
The new description for the address block

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

### -DHCPLeaseSeconds
The default DHCP Lease duration in seconds

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

### -DDNSDomain
The new DDNS Domain for the address block

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
A list of tags to update on the address block.
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

### -id
The id of the address block to update.
Accepts pipeline input

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
