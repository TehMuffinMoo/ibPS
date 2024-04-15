---
external help file: BloxOne-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Get-B1DTCHealthCheck

## SYNOPSIS
Retrieves a list BloxOne DTC Health Checks

## SYNTAX

```
Get-B1DTCHealthCheck [[-Name] <String>] [[-Description] <String>] [[-Type] <String>] [[-Status] <String>]
 [[-Port] <Int32>] [-Strict] [[-Limit] <Int32>] [[-Offset] <Int32>] [[-tfilter] <String>]
 [[-Fields] <String[]>] [[-OrderBy] <String>] [[-OrderByTag] <String>] [[-id] <String>]
```

## DESCRIPTION
This function is used to query a list BloxOne Health Checks

## EXAMPLES

### EXAMPLE 1
```powershell
Get-B1DTCHealthCheck -Type HTTP | ft -AutoSize

name                    comment                   type disabled interval timeout retry_up retry_down tags port http request                                                             codes id
----                    -------                   ---- -------- -------- ------- -------- ---------- ---- ---- ---- -------                                                             ----- --
HTTP health check       Default HTTP health check http    False       15      10        1          1        80      GET / HTTP/1.1…                                                     200   dtc/health_check_http/ac9htthh-h754-t4hg-45gu-fdsgf98wwd4v
Exchange - HTTPS                                  http    False       10      10        3          3       443      GET /owa/auth/logon.aspx HTTP/1.1                                         dtc/health_check_http/dgferhg5-ge5e-g455-gb45-muymkfdsdfcf
```

## PARAMETERS

### -Name
The name of the DTC Health Check to filter by

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

### -Description
The description of the DTC Health Check to filter by

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

### -Type
Filter by the DTC Health Check Type

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

### -Status
Filter by the Health Check status (Enabled/Disabled)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Filter by the DTC Health Check Port

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Strict
Use strict filter matching.
By default, filters are searched using wildcards where possible.
Using strict matching will only return results matching exactly what is entered in the applicable parameters.

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

### -Limit
Use this parameter to limit the quantity of results.
The default number of results is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 1000
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
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -tfilter
Use this parameter to filter the results returned by tag.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
Specify a list of fields to return.
The default is to return all fields.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderBy
Optionally return the list ordered by a particular value.
If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrderByTag
Optionally return the list ordered by a particular tag value.
Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -id
Return results based on Server id

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
