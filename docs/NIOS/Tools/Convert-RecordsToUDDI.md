---
external help file: ibPS-Main-help.xml
Module Name: ibPS
online version:
schema: 2.0.0
---

# Convert-RecordsToUDDI

## SYNOPSIS
Provides a simple way to convert NIOS Record Object data to Universal DDI CSV Import Format

## SYNTAX

```
Convert-RecordsToUDDI [-Object] <Object> [[-DNSView] <String>] [[-ReturnType] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function accepts NIOS Record Objects either through -Object or via Pipeline.
This can be any of the 'record:X' object types or supported data from the 'allrecords' object type.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-NIOSObject -ObjectType allrecords -Filters 'zone=mydomain.corp' -AllFields | Convert-RecordsToUDDI

HEADER-dnsdata-v2-record,key,name_in_zone,comment,disabled,zone,ttl,type,rdata,options,tags,ttl_action
dnsdata-v2-record,"default,mydomain.corp.,,A,RDATA{""address"":""192.168.1.20""}RDATA",,,False,"default,mydomain.corp.",600,A,"{""address"":""192.168.1.20""}",,,
dnsdata-v2-record,"default,mydomain.corp.,,A,RDATA{""address"":""192.168.1.21""}RDATA",,,False,"default,mydomain.corp.",600,A,"{""address"":""192.168.1.21""}",,,
dnsdata-v2-record,"default,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}RDATA",,,False,"default,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}",,,
dnsdata-v2-record,"default,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:cafe:100::20""}RDATA",,,False,"default,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:cafe:100::20""}",,,
dnsdata-v2-record,"default,mydomain.corp.,_gc._tcp,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp,,False,"default,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
dnsdata-v2-record,"default,mydomain.corp.,_gc._tcp.default-first-site-name._sites,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp.default-first-site-name._sites,,False,"default,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
....
```

### EXAMPLE 2
```powershell
## Using -DNSView to override the view name

PS> Get-NIOSObject -ObjectType allrecords -Filters 'zone=mydomain.corp' -AllFields | Convert-RecordsToUDDI -DNSView 'Corporate'

HEADER-dnsdata-v2-record,key,name_in_zone,comment,disabled,zone,ttl,type,rdata,options,tags,ttl_action
dnsdata-v2-record,"Corporate,mydomain.corp.,,A,RDATA{""address"":""192.168.1.20""}RDATA",,,False,"Corporate,mydomain.corp.",600,A,"{""address"":""192.168.1.20""}",,,
dnsdata-v2-record,"Corporate,mydomain.corp.,,A,RDATA{""address"":""192.168.1.21""}RDATA",,,False,"Corporate,mydomain.corp.",600,A,"{""address"":""192.168.1.21""}",,,
dnsdata-v2-record,"Corporate,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}RDATA",,,False,"Corporate,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}",,,
dnsdata-v2-record,"Corporate,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:cafe:100::20""}RDATA",,,False,"Corporate,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:cafe:100::20""}",,,
dnsdata-v2-record,"Corporate,mydomain.corp.,_gc._tcp,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp,,False,"Corporate,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
dnsdata-v2-record,"Corporate,mydomain.corp.,_gc._tcp.default-first-site-name._sites,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp.default-first-site-name._sites,,False,"Corporate,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
....
```

### EXAMPLE 3
```powershell
Get-NIOSObject -ObjectType allrecords -Filters 'zone=mydomain.corp' -AllFields | Convert-RecordsToUDDI | Out-File ./records.csv
```

## PARAMETERS

### -Object
The NIOS Record Object(s) to convert to Universal DDI CSV format.
Accepts pipeline input from 'Get-NIOSObject'.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DNSView
This provides a way to override the Universal DDI DNS View name which will be used when converting.
By default, the NIOS Network View name is used.

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

### -ReturnType
The results type to return.
This can be Object, CSV or JSON.
Object/JSON are convenience features only.
CSV is currently the only output that is supported by Universal DDI Data Import.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: CSV
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
