function Convert-RecordsToBloxOne {
    <#
    .SYNOPSIS
        Provides a simple way to convert NIOS Record Object data to BloxOne CSV Import Format

    .DESCRIPTION
        This function accepts NIOS Record Objects either through -Object or via Pipeline. This can be any of the 'record:X' object types or supported data from the 'allrecords' object type.

    .PARAMETER Object
        The NIOS Record Object(s) to convert to BloxOne CSV format. Accepts pipeline input from 'Get-NIOSObject'.

    .PARAMETER DNSView
        This provides a way to override the BloxOne DNS View name which will be used when converting. By default, the NIOS Network View name is used.

    .PARAMETER ReturnType
        The results type to return. This can be Object, CSV or JSON. Object/JSON are convenience features only. CSV is currently the only output that is supported by BloxOne Data Import.

    .EXAMPLE
        PS> Get-NIOSObject -ObjectType allrecords -Filters 'zone=mydomain.corp' -AllFields | Convert-RecordsToBloxOne

        HEADER-dnsdata-v2-record,key,name_in_zone,comment,disabled,zone,ttl,type,rdata,options,tags,ttl_action
        dnsdata-v2-record,"default,mydomain.corp.,,A,RDATA{""address"":""192.168.1.20""}RDATA",,,False,"default,mydomain.corp.",600,A,"{""address"":""192.168.1.20""}",,,
        dnsdata-v2-record,"default,mydomain.corp.,,A,RDATA{""address"":""192.168.1.21""}RDATA",,,False,"default,mydomain.corp.",600,A,"{""address"":""192.168.1.21""}",,,
        dnsdata-v2-record,"default,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}RDATA",,,False,"default,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}",,,
        dnsdata-v2-record,"default,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:cafe:100::20""}RDATA",,,False,"default,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:cafe:100::20""}",,,
        dnsdata-v2-record,"default,mydomain.corp.,_gc._tcp,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp,,False,"default,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
        dnsdata-v2-record,"default,mydomain.corp.,_gc._tcp.default-first-site-name._sites,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp.default-first-site-name._sites,,False,"default,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
        ....

    .EXAMPLE
        ## Using -DNSView to override the view name
        
        PS> Get-NIOSObject -ObjectType allrecords -Filters 'zone=mydomain.corp' -AllFields | Convert-RecordsToBloxOne -DNSView 'Corporate'

        HEADER-dnsdata-v2-record,key,name_in_zone,comment,disabled,zone,ttl,type,rdata,options,tags,ttl_action
        dnsdata-v2-record,"Corporate,mydomain.corp.,,A,RDATA{""address"":""192.168.1.20""}RDATA",,,False,"Corporate,mydomain.corp.",600,A,"{""address"":""192.168.1.20""}",,,
        dnsdata-v2-record,"Corporate,mydomain.corp.,,A,RDATA{""address"":""192.168.1.21""}RDATA",,,False,"Corporate,mydomain.corp.",600,A,"{""address"":""192.168.1.21""}",,,
        dnsdata-v2-record,"Corporate,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}RDATA",,,False,"Corporate,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:dead:cd70:8756:70ea:7fb""}",,,
        dnsdata-v2-record,"Corporate,mydomain.corp.,,AAAA,RDATA{""address"":""2001:db8:a42:cafe:100::20""}RDATA",,,False,"Corporate,mydomain.corp.",600,AAAA,"{""address"":""2001:db8:a42:cafe:100::20""}",,,
        dnsdata-v2-record,"Corporate,mydomain.corp.,_gc._tcp,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp,,False,"Corporate,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
        dnsdata-v2-record,"Corporate,mydomain.corp.,_gc._tcp.default-first-site-name._sites,SRV,RDATA{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}RDATA",_gc._tcp.default-first-site-name._sites,,False,"Corporate,mydomain.corp.",600,SRV,"{""weight"":100,""port"":3268,""target"":""win-342rfw4r4fg.mydomain.corp"",""priority"":0}",,,
        ....

    .EXAMPLE
        Get-NIOSObject -ObjectType allrecords -Filters 'zone=mydomain.corp' -AllFields | Convert-RecordsToBloxOne | Out-File ./records.csv

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        NIOS
    
    .FUNCTIONALITY
        Migration
    #>
    param(
        [Parameter(ValueFromPipeline,Mandatory)]
        [Object]$Object,
        [String]$DNSView,
        [ValidateSet('Object','JSON','CSV')]
        [String]$ReturnType = 'CSV'
    )

    begin {
        $Results = @()
    }

    process {

        ForEach ($Record in $Object) {
            $ObjRefType = ($Record._ref -split '/')[0]

            ## Clear Vals
            $Key = $null
            $RDATA = $null

            ## Set DNS View
            if (!($DNSView)) {
                $DNSView = $Record.view
            }

            if ($ObjRefType -eq 'allrecords') {
                ## allrecords objects
                if ($Record.type -eq 'UNSUPPORTED') {
                    Write-Warning "Skipping UNSUPPORTED Record: $($Record.name).$($Record.zone) -> $($Record.record.nameserver)..."
                    break
                }
                $Type = ($Record.type -split ':')[1]

                $Key = @(
                    $DNSView
                    "$($Record.zone)."
                    $Record.name
                    $Type.ToUpper()
                )
            } else {
                ## All standard record objects
                $Type = ($ObjRefType -split ':')[1]
                if ($Type -eq 'UNSUPPORTED') {
                    break
                }
                $Key = @(
                    $DNSView
                    "$($Record.zone)."
                    $Record.dns_name.replace(".$($Record.zone)",'')
                    $Type.ToUpper()
                )
            }

            Switch($Type) {
                'A' {
                    $RDATA = @{
                        'address' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.address } else { $Record.ipv4addr })
                    } | ConvertTo-Json -Compress
                    break
                }
                'AAAA' {
                    $RDATA = @{
                        'address' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.address } else { $Record.ipv6addr })
                    } | ConvertTo-Json -Compress
                    break
                }
                'CAA' {
                    $RDATA = @{
                        'flags' = $(if ($ObjRefType -eq 'ALLRECORDS') { <# allrecords Not Supported for CAA #> } else { $Record.ca_flag })
                        'tag' = $(if ($ObjRefType -eq 'ALLRECORDS') { <# allrecords Not Supported for CAA  #> } else { $Record.ca_tag })
                        'value' = $(if ($ObjRefType -eq 'ALLRECORDS') { <# allrecords Not Supported for CAA  #> } else { $Record.ca_value })
                    } | ConvertTo-Json -Compress
                    break
                }
                'CNAME' {
                    $RDATA = @{
                        'cname' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.canonical } else { $Record.dns_canonical })
                    } | ConvertTo-Json -Compress
                    break
                }
                'DNAME' {
                    $RDATA = @{
                        'target' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.target } else { $Record.dns_target })
                    } | ConvertTo-Json -Compress
                    break
                }
                'MX' {
                    $RDATA = @{
                        'exchange' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.mail_exchanger } else { $Record.dns_mail_exchanger })
                        'preference' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.preference } else { $Record.preference })
                    } | ConvertTo-Json -Compress
                    break
                }
                'NAPTR' {
                    $RDATA = @{
                        'flags' = $(if ($ObjRefType -eq 'ALLRECORDS') { <# allrecords does not return flags value #> } else { $Record.flags })
                        'order' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.order } else { $Record.order })
                        'preference' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.preference } else { $Record.preference })
                        'regexp' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.regexp } else { $Record.regexp })
                        'replacement' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.replacement } else { $Record.replacement })
                        'services' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.services } else { $Record.services })
                    } | ConvertTo-Json -Compress
                    break
                }
                'NS' {
                    $RDATA = @{
                        'dname' = $(if ($ObjRefType -eq 'ALLRECORDS') { <# allrecords Not Supported for NS #> } else { $Record.nameserver })
                    } | ConvertTo-Json -Compress
                    break
                }
                'PTR' {
                    $RDATA = @{
                        'dname' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.ptrdname } else { $Record.ptrdname })
                    } | ConvertTo-Json -Compress
                    break
                }
                'SRV' {
                    $RDATA = @{
                        'priority' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.priority } else { $Record.priority })
                        'weight' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.weight } else { $Record.weight })
                        'port' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.port } else { $Record.port })
                        'target' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.target } else { $Record.dns_target })
                    } | ConvertTo-Json -Compress
                    break
                }
                'TXT' {
                    $RDATA = @{
                        'text' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.record.text } else { $Record.text })
                    } | ConvertTo-Json -Compress
                    break
                }
                'host_ipv4addr' {
                    $Key[3] = 'A'
                    $RDATA = @{
                        'address' = $(if ($ObjRefType -eq 'ALLRECORDS') { $Record.address } else { $Record.address })
                    } | ConvertTo-Json -Compress
                    break
                }
                default {
                    Write-Warning "Unsupported Record Type $($Type)"
                    break
                }
            }

            if ($Key) {
                if ($RDATA) {
                    $Key += "RDATA$($RDATA)RDATA"

                    $Results += [PSCustomObject]@{
                        "HEADER-dnsdata-v2-record" = "dnsdata-v2-record"
                        "key" = $($Key -join ',')
                        "name_in_zone" = $Key[2]
                        "comment" = $Record.comment
                        "disabled" = [Bool]$Record.disable
                        "zone" = "$($Key[0]),$($Key[1])"
                        "ttl" = $Record.ttl
                        "type" = $Key[3]
                        "rdata" = $($RDATA)
                        "options" = ""
                        "tags" = ""
                        "ttl_action" = ""
                    }

                } else {
                    Write-Warning "Failed to generate RDATA for the following record:"
                    Write-Warning $Record
                    break
                }
            } else {
                Write-Warning "Failed to generate Key for the following record:"
                Write-Warning $Record
                break
            }
        }
    }

    end {
        Switch($ReturnType) {
            'Object' {
                return $Results
            }
            'JSON' {
                Write-Warning 'The current JSON output format does not work with BloxOne import. Use CSV instead for this purpose.'
                return $Results | ConvertTo-Json -Depth 5
            }
            'CSV' {
                return $Results | ConvertTo-Csv -UseQuotes AsNeeded
            }
        }
    }
}