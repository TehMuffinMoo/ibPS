---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Invoke-DoHQuery

## SYNOPSIS
Used to query a DNS over HTTPS Server to verify connectivity and responses

## SYNTAX

```
Invoke-DoHQuery [[-Query] <String>] [[-Type] <String>] [[-DoHServer] <String>]
```

## DESCRIPTION
This function is used to query a DNS over HTTPS Server to verify connectivity and responses

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-DoHQuery -Query google.com      
                                                                                                                
QNAME      QTYPE QCLASS Answers
-----      ----- ------ -------
google.com       IN     {@{RDATA=System.Collections.Hashtable; RNAME=google.com; RTYPE=SOA; RCLASS=IN; TTL=60; LENGTH=58}}
```

### EXAMPLE 2
```powershell
Invoke-DoHQuery -Query bbc.co.uk -Type A | Select-Object -ExpandProperty Answers | ft -AutoSize
                                                                                                                    
RDATA          RNAME     RTYPE RCLASS TTL LENGTH
-----          -----     ----- ------ --- ------
151.101.128.81 bbc.co.uk A     IN     296      4
151.101.192.81 bbc.co.uk A     IN     296      4
151.101.0.81   bbc.co.uk A     IN     296      4
151.101.64.81  bbc.co.uk A     IN     296      4
```

## PARAMETERS

### -Query
Specify the DNS Query to send to the selected DoH Server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Optionally specify the DNS request type

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

### -DoHServer
Optionally specify a DNS over HTTPS Server for this specific query.

This field is mandatory, unless the DoH Server has been pre-configured using: Set-ibPSConfiguration -DoHServer 'fqdn.infoblox.com' -Persist

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(if ($ENV:IBPSDoH) { $ENV:IBPSDoH })
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
