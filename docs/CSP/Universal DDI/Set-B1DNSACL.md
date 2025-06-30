---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Set-B1DNSACL

## SYNOPSIS
Updates a DNS ACL object

## SYNTAX

### Default (Default)
```
Set-B1DNSACL -Name <String> [-NewName <String>] [-Description <String>] [-Items <Object>] [-AddItems <Object>]
 [-RemoveItems <Object>] [-Tags <Object>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Pipeline
```
Set-B1DNSACL [-NewName <String>] [-Description <String>] [-Items <Object>] [-AddItems <Object>]
 [-RemoveItems <Object>] [-Tags <Object>] -Object <Object> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to update a DNS ACL object within Universal DDI

## EXAMPLES

### EXAMPLE 1
```powershell
Set-B1DNSACL -Name 'My ACL' -NewName 'My New ACL' -Tags @{'Tag1' = 'Val1'}

comment        : Hello World
compartment_id :
id             : dns/acl/2fwefef3r-sfef-44fg-bfg4-bgvdgrthfdd
list           : {@{access=; acl=dns/acl/6fewfw3e8-ef4e-sfw3-9sdf-2drghdg4ed2; address=; element=acl; tsig_key=}, @{access=allow; acl=; address=::; element=ip; tsig_key=}}
name           : My New ACL
tags           : @{Tag1=Val1}
```

### EXAMPLE 2
```powershell
$ItemsToRemove = @()
$ItemsToRemove += New-B1DNSACLItem -Address 10.24.0.0/16

Get-B1DNSACL -Name 'My ACL' | Set-B1DNSACL -RemoveItems $ItemsToRemove

comment        :
compartment_id :
id             : dns/acl/2fwefef3r-sfef-44fg-bfg4-bgvdgrthfdd
list           : {@{access=; acl=dns/acl/6fewfw3e8-ef4e-sfw3-9sdf-2drghdg4ed2; address=; element=acl; tsig_key=}, @{access=allow; acl=; address=10.0.0.0/16;
                element=ip; tsig_key=}}
name           : My ACL
tags           :
```

### EXAMPLE 3
```powershell
$ACLsToAdd = @()
$ACLsToAdd += New-B1DNSACLItem -Access allow -Address 10.24.0.0/16

Get-B1DNSACL 'My ACL' | Set-B1DNSACL -AddItems $ACLsToAdd

10.24.0.0/16 already exists in the list of ACLs, but with a different action. Updating the action to: deny

comment        :
compartment_id :
id             : dns/acl/2fwefef3r-sfef-44fg-bfg4-bgvdgrthfdd
list           : {@{access=; acl=dns/acl/6fewfw3e8-ef4e-sfw3-9sdf-2drghdg4ed2; address=; element=acl; tsig_key=}, @{access=deny; acl=; address=10.24.0.0/16; element=ip; tsig_key=}, @{access=allow; acl=; address=10.0.0.0/16;
                element=ip; tsig_key=}}
name           : My ACL
tags           :
```

## PARAMETERS

### -Name
The name of the DNS ACL to update.

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
Use -NewName to update the name of the DNS ACL

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
The new description for the DNS ACL object

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
Enter a list of \[DNSACLListItem\] objects.
These can be created by using New-B1DNSACLItem.

This will overwrite the current list of ACLs.
If you only want to add or remove ACLs to/from the list, you should use the corresponding -AddItems or -RemoveItems parameters.

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
Enter a list of \[DNSACLListItem\] objects.
These can be created by using New-B1DNSACLItem.

Duplicate items will be silently skipped, only new items are appended to the ACL list.

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
Enter a list of \[DNSACLListItem\] objects.
These can be created by using New-B1DNSACLItem.

These items will be removed from the ACL List, if the item does not exist it will be silently skipped.

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
The list of tags to apply to the DNS ACL.
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
The DNS ACL object to update.
Accepts pipeline input from Get-B1DNSACLItem.

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
