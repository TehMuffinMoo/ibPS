---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Build-B1CubeJSFilter

## SYNOPSIS
A wrapper function for building CubeJS filters for use with Invoke-B1CubeJS

## SYNTAX

```
Build-B1CubeJSFilter [-Cube] <String> [-Member] <String> [-Operator] <String> [-Values] <String[]>
 [<CommonParameters>]
```

## DESCRIPTION
This is a wrapper function used for building CubeJS filters for use with Invoke-B1CubeJS.

## EXAMPLES

### EXAMPLE 1
```powershell
$Filters = @()
PS> $Filters += Build-B1CubeJSFilter -Cube "NstarLeaseActivity" -Member "state" -Operator "contains" -Values "Assignments"
PS> $Filters += Build-B1CubeJSFilter -Cube "NstarLeaseActivity" -Member "lease_ip" -Operator "equals" -Values @("192.168.180.11","192.168.180.13")
PS> Invoke-B1CubeJS -Cube NstarLeaseActivity -Dimensions timestamp,lease_ip,lease_op,protocol,state -Limit 100 -TimeDimension timestamp -Start (Get-Date).AddDays(-30) -Filters $Filters | ft -AutoSize
                                                                                                                        
lease_ip       lease_op protocol     state       timestamp
--------       -------- --------     -----       ---------
192.168.180.11 Update   IPv4 Address Assignments 20/06/2026 15:17:14
192.168.180.11 Update   IPv4 Address Assignments 20/06/2026 11:09:43
192.168.180.11 Update   IPv4 Address Assignments 20/06/2026 10:15:29
192.168.180.11 Update   IPv4 Address Assignments 20/06/2026 09:50:14
192.168.180.11 Update   IPv4 Address Assignments 19/06/2026 21:43:03
192.168.180.11 Update   IPv4 Address Assignments 19/06/2026 10:53:55
192.168.180.13 Update   IPv4 Address Assignments 07/06/2026 08:38:33
192.168.180.13 Update   IPv4 Address Assignments 05/06/2026 20:34:34
192.168.180.13 Update   IPv4 Address Assignments 04/06/2026 08:29:38
192.168.180.13 Update   IPv4 Address Assignments 02/06/2026 20:27:48
192.168.180.13 Update   IPv4 Address Assignments 01/06/2026 08:27:39
192.168.180.13 Update   IPv4 Address Assignments 30/05/2026 20:19:47
192.168.180.13 Update   IPv4 Address Assignments 29/05/2026 21:42:50
192.168.180.13 Update   IPv4 Address Assignments 28/05/2026 09:42:51
```

## PARAMETERS

### -Cube
Specify the name of the cube to query and should match the cube specified in Invoke-B1CubeJS.
This field supports auto/tab-completion.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Member
Specify one or more dimensions.
This field supports auto/tab-completion.
Dimensions are referred to as categorical data, such as ip address, hostname, status or timestamps.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Operator
Specify the operator to use for the filter.
This field supports auto/tab-completion.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Values
Specify one or more values to use for the filter.
Values must be of type String.
(Or array of strings)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
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
