function Convert-RecordsToBloxOne {
    param(
        [Parameter(ValueFromPipeline,Mandatory)]
        [Object]$Object,
        [Parameter(Mandatory)]
        [String]$DNSView,
        [ValidateSet('Object','JSON','CSV')]
        [String]$ReturnType = 'CSV',
        [Switch]$SkipB1Checks
    )

    begin {
        if (!($SkipB1Checks)) {
            if (!(Get-B1DNSView $DNSView)) {
                Write-Warning "DNS View $($DNSView) does not exist. The DNS View must be created before importing records."
            }
        }
        $Results = @()
    }

    process {

        ForEach ($Record in $Object) {
            $ObjRefType = ($Record._ref -split '/')[0]

            ## Clear Vals
            $Key = $null
            $RDATA = $null

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