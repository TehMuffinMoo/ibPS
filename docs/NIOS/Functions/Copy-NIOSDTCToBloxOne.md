---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Copy-NIOSDTCToBloxOne

## SYNOPSIS
Used to migrate LBDNs from NIOS DTC to BloxOne DTC

THIS FUNCTION IS CURRENTLY UNDERGOING SMOKE TESTING.
FEEDBACK IS WELCOME!

Health Check HTTP Response Content conversion still to be implemented.

## SYNTAX

```
Copy-NIOSDTCToBloxOne [-NIOSLBDN] <Object> [-B1DNSView] <Object> [[-PolicyName] <String>] [-ApplyChanges]
 [[-LBDNTransform] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to automate the migration of Load Balanced DNS Names and associated objects (Pools/Servers/Health Monitors) from NIOS DTC to BloxOne DTC

BloxOne DDI only currently supports Round Robin, Global Availability, Ratio & Toplogy Load Balancing Methods; and TCP, HTTP & ICMP Health Checks.
Unsupported Load Balancing Methods will fail, but unsupported Health Checks will be skipped gracefully.

## EXAMPLES

### EXAMPLE 1
```powershell
Copy-NIOSDTCToBloxOne -B1DNSView 'My DNS View' -NIOSLBDN 'Exchange Server' -PolicyName 'Exchange' -LBDNTransform 'dtc.company.corp:b1dtc.company.corp' -ApplyChanges

Querying BloxOne DNS View: My DNS View
Querying DTC LBDN: Exchange Server
Querying DTC Pool: dtc:pool/ZG5zLmlkbnNfcG9vbCRFeGNoYW5nZSBQb29s:Exchange%20Pool
Querying DTC Server: dtc:server/ZG5zLmlkbnNfc2VydmVyJEV4Y2hhbmdlIFNlcnZlciAx:Exchange%20Server%201
Querying DTC Server: dtc:server/ZG5zLmlkbnNfc2VydmVyJEV4Y2hhbmdlIFNlcnZlciAy:Exchange%20Server%202
Querying DTC Monitor: dtc:monitor:icmp/ZG5zLmlkbnNfbW9uaXRvcl9pY21wJGljbXA:icmp
Querying DTC Monitor: dtc:monitor:http/ZG5zLmlkbnNfbW9uaXRvcl9odHRwJGh0dHBzX2V4Y2hhbmdl:https_exchange
Querying DTC Topology Rule: dtc:topology/ZG5zLmlkbnNfdG9wb2xvZ3kkRXhjaGFuZ2UtVG9wb2xvZ3k:Exchange-Topology
Querying DTC Topology Rule: dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS41NDU0NjUxOS03YzU1LTRiYTQtOGY3OS01YzQ3MTQ3MjI5YWQ:Exchange-Topology/Exchange%20Pool
Querying DTC Topology Rule: dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS4wYmUyYjc1Yi1lYzNiLTRmZmYtYjk2MC03MzZjNDlhNTA5ODE:Exchange-Topology/Exchange%20Pool
Querying DTC Topology Rule: dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS5mNTI2M2E5Ny1iNzJkLTQwNWQtYWZmYi1mZTE5NWJmNThhODg:Exchange-Topology/NOERR/2
Querying DTC Topology Rule: dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS41ZjMzMjYwNy0yNDM0LTQ4Y2EtYWM4ZC1hZmUyYTA2N2VlNTQ:Exchange-Topology/NXDOMAIN/3
Successfully created DTC Server: Exchange Server 1
Successfully created DTC Server: Exchange Server 2
Health Check timeout exceeds its interval, setting them to match..
Successfully created DTC Health Check: https_exchange
Successfully created DTC Pool: Exchange Pool
Successfully created DTC Policy: Exchange (API Test)
Successfully created DTC LBDN: webmail.b1dtc.company.corp.
```

### EXAMPLE 2
```powershell
Copy-NIOSDTCToBloxOne -B1DNSView 'My DNS View' -NIOSLBDN 'Exchange Server' -PolicyName 'Exchange' -LBDNTransform 'dtc.company.corp:b1dtc.company.corp'

{
    "LBDN": [
        {
        "Name": "webmail.dtc.company.corp",
        "Description": "Exchange Server",
        "DNSView": "My DNS View",
        "ttl": 30,
        "priority": 1,
        "persistence": 0,
        "types": [
            "A",
            "AAAA",
            "CNAME"
        ]
        }
    ],
    "Policy": {
        "Name": "Exchange",
        "LoadBalancingMethod": "topology",
        "rules": [
        {
            "_ref": "dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS41NDU0NjUxOS03YzU1LTRiYTQtOGY3OS01YzQ3MTQ3MjI5YWQ:Exchange-Topology/Exchange%20Pool",
            "dest_type": "POOL",
            "destination_link": {
            "_ref": "dtc:pool/ZG5zLmlkbnNfcG9vbCRFeGNoYW5nZSBQb29s:Exchange%20Pool",
            "comment": "Pool of Exchange Servers",
            "name": "Exchange Pool"
            },
            "return_type": "REGULAR",
            "sources": [
            {
                "source_op": "IS",
                "source_type": "SUBNET",
                "source_value": "10.10.10.0/24"
            }
            ],
            "valid": true
        },
        {
            "_ref": "dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS4wYmUyYjc1Yi1lYzNiLTRmZmYtYjk2MC03MzZjNDlhNTA5ODE:Exchange-Topology/Exchange%20Pool",
            "dest_type": "POOL",
            "destination_link": {
            "_ref": "dtc:pool/ZG5zLmlkbnNfcG9vbCRFeGNoYW5nZSBQb29s:Exchange%20Pool",
            "comment": "Pool of Exchange Servers",
            "name": "Exchange Pool"
            },
            "return_type": "REGULAR",
            "sources": [],
            "valid": true,
            "default": true
        },
        {
            "_ref": "dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS5mNTI2M2E5Ny1iNzJkLTQwNWQtYWZmYi1mZTE5NWJmNThhODg:Exchange-Topology/NOERR/2",
            "dest_type": "POOL",
            "return_type": "NOERR",
            "sources": [
            {
                "source_op": "IS",
                "source_type": "SUBNET",
                "source_value": "10.24.2.0/24"
            }
            ],
            "valid": true
        },
        {
            "_ref": "dtc:topology:rule/ZG5zLmlkbnNfdG9wb2xvZ3lfcnVsZSRFeGNoYW5nZS1Ub3BvbG9neS41ZjMzMjYwNy0yNDM0LTQ4Y2EtYWM4ZC1hZmUyYTA2N2VlNTQ:Exchange-Topology/NXDOMAIN/3",
            "dest_type": "POOL",
            "return_type": "NXDOMAIN",
            "sources": [
            {
                "source_op": "IS",
                "source_type": "SUBNET",
                "source_value": "10.0.0.0/8"
            }
            ],
            "valid": true
        }
        ]
    },
    "Pools": [
        {
        "name": "Exchange Pool",
        "method": "ratio",
        "servers": [
            {
            "name": "Exchange Server 1",
            "disable": false,
            "address": null,
            "fqdn": "exchange01.company.corp",
            "AutoCreateResponses": true,
            "weight": 1
            },
            {
            "name": "Exchange Server 2",
            "disable": false,
            "address": null,
            "fqdn": "exchange02.company.corp",
            "AutoCreateResponses": true,
            "weight": 2
            }
        ],
        "monitors": [
            {
            "_ref": "dtc:monitor:icmp/ZG5zLmlkbnNfbW9uaXRvcl9pY21wJGljbXA:icmp",
            "comment": "Default ICMP health monitor",
            "interval": 5,
            "name": "icmp",
            "retry_down": 1,
            "retry_up": 1,
            "timeout": 15
            },
            {
            "_ref": "dtc:monitor:http/ZG5zLmlkbnNfbW9uaXRvcl9odHRwJGh0dHBzX2V4Y2hhbmdl:https_exchange",
            "content_check": "NONE",
            "content_check_input": "ALL",
            "content_check_op": "EQ",
            "content_extract_group": 0,
            "content_extract_type": "STRING",
            "enable_sni": false,
            "interval": 5,
            "name": "https_exchange",
            "port": 443,
            "request": "GET /owa HTTP/1.1\nConnection: close\n\n",
            "result": "ANY",
            "result_code": 200,
            "retry_down": 1,
            "retry_up": 1,
            "secure": true,
            "timeout": 15,
            "validate_cert": false,
            "results": "ANY"
            }
        ],
        "ttl": 15,
        "ratio": 1,
        "availability": "quorum",
        "quorum": 1
        }
    ]
}
```

## PARAMETERS

### -NIOSLBDN
The LBDN Name within NIOS that you would like to migrate to BloxOne DDI.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -B1DNSView
The DNS View within BloxOne DDI in which to assign the new LBDNs to.
The LBDNs will not initialise unless the zone(s) exist within the specified DNS View.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PolicyName
Optionally specify a DTC Policy name.
DTC Policies are new in BloxOne DDI, so by default they will inherit the name of the DTC LBDN if this parameter is not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplyChanges
Using this switch will apply the changes, otherwise the expected changes will just be displayed.

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

### -LBDNTransform
Use this parameter to transform the DTC LBDN FQDN from an old to new domain.

Example: -LBDNTransform 'dtc.mydomain.com:b1dtc.mydomain.com'

|           NIOS DTC          |        BloxOne DDI DTC        |
|-----------------------------|-------------------------------|
| myservice.dtc.mydomain.com  | myservice.b1dtc.mydomain.com  |

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
