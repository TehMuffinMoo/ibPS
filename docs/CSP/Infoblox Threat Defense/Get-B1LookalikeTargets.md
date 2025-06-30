---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1LookalikeTargets

## SYNOPSIS
Queries a list of lookalike target domains for the account

## SYNTAX

```
Get-B1LookalikeTargets [<CommonParameters>]
```

## DESCRIPTION
This function is used to query a list of lookalike target domains for the account
The Lookalike Target Domains are second-level domains Threat Defense uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1LookalikeTargets

description     : Auto-generated
item_count      : 219
items           : {google.com, facebook.com, bbc.co.uk, infoblox.com…}
items_described : {@{description=description for google.com; item=google.com; target_domain_status=accepted; valid=True}, @{description=a description for facebook ; item=facebook.com; target_domain_status=accepted; valid=True}, @{description=Another
                description but for bbc; item=bbc.co.uk; target_domain_status=accepted; valid=True}, @{description=Our domain; item=infoblox.com; target_domain_status=accepted; valid=True}…}
name            : Global Lookalike Target List
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
