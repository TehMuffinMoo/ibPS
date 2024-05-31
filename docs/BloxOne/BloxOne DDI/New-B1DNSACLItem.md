---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# New-B1DNSACLItem

## SYNOPSIS
This function is used to create new ACL Items to append or remove to/from an existing DNS ACL, using Set-B1DNSACL.

## SYNTAX

### TSIG
```
New-B1DNSACLItem -Access <Object> [-TSIG_KEY <Object>] [<CommonParameters>]
```

### IP
```
New-B1DNSACLItem -Access <Object> [-Address <Object>] [<CommonParameters>]
```

### NamedACL
```
New-B1DNSACLItem [-ACL <Object>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to create new ACL Items to append or remove to/from an existing DNS ACL, using Set-B1DNSACL.

## EXAMPLES

### EXAMPLE 1
```powershell
New-B1DNSACLItem -Access Allow -ACL 'My ACL'

access   : allow
acl      : dns/acl/1c4e5768-f4r4-dgsd-bewf-grdrggwt4se
address  : 
element  : acl
tsig_key :
```

### EXAMPLE 2
```powershell
$NewACLs = @()
$NewACLs += New-B1DNSACLItem -Access Deny -ACL 'My ACL'
$NewACLs += New-B1DNSACLItem -Access Allow -Address '10.0.0.0/16'

$NewACLs | ft

access acl                                          address     element tsig_key
------ ---                                          -------     ------- --------
allow                                               10.0.0.0/16 ip      
deny   dns/acl/1c4e5768-f4r4-dgsd-bewf-grdrggwt4se              acl
```

## PARAMETERS

### -Access
The permission to apply to this ACL Item (Allow/Deny)

```yaml
Type: Object
Parameter Sets: TSIG, IP
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address
The IPv4/IPv6 address or network (in CIDR format) to associate with this ACL Item.
This selects the ACL Element to 'ip'

```yaml
Type: Object
Parameter Sets: IP
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ACL
The Named ACL to associate with this ACL Item.
This selects the ACL Element to 'acl'

```yaml
Type: Object
Parameter Sets: NamedACL
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TSIG_KEY
The IPv4/IPv6 address or network (in CIDR format) to associate with this ACL Item.
This selects the ACL Element to 'tsig_key'

```yaml
Type: Object
Parameter Sets: TSIG
Aliases:

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
