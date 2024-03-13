---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DHCPLog

## SYNOPSIS
Queries the BloxOneDDI DHCP Log

## SYNTAX

```
Get-B1DHCPLog [[-Hostname] <String>] [[-State] <String>] [[-IP] <String>] [[-DHCPServer] <Object>]
 [[-Protocol] <String>] [[-MACAddress] <String>] [[-Start] <DateTime>] [[-End] <DateTime>] [[-Limit] <Int32>]
 [[-Offset] <Int32>]
```

## DESCRIPTION
This function is used to query the BloxOneDDI DHCP Logs.
This is the log which contains all DHCP request/response information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DHCPLog -Hostname "dhcpclient.mydomain.corp" -State "Assignments" -IP "10.10.10.100" -Protocol "IPv4 Address" -DHCPServer "bloxoneddihost1.mydomain.corp" -Start (Get-Date).AddHours(-24) -End (Get-Date) -Limit 100 -Offset 0
```

## PARAMETERS

### -Hostname
Use this parameter to filter the DHCP Logs by hostname or FQDN

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

### -State
Used to filter the DHCP Log by the request state

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

### -IP
Used to filter the DHCP Log by source IP

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

### -DHCPServer
Filter the DHCP Logs by one or more DHCP Servers (i.e @("mybloxoneddihost1.mydomain.corp","mybloxoneddihost2.mydomain.corp")

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Protocol
Filter the DHCP Logs by IP Protocol (i.e "IPv4 Address")

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MACAddress
Filter the DHCP Logs by MAC Address (i.e "ab:cd:ef:12:34:56")

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Start
A date parameter used as the starting date/time of the log search.
By default, the search will start from 24hrs ago and returns the latest results first.
You may need to increase the -Limit parameter or reduce the -End date/time to view earlier events.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: (Get-Date).AddDays(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -End
A date parameter used as the end date/time of the log search.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Offset
Use this parameter to offset the results by the value entered for the purpose of pagination

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
