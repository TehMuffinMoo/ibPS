function Copy-NIOSDTCToUDDI {
    <#
    .SYNOPSIS
        Used to migrate LBDNs from NIOS DTC to Universal DDI DTC

    .DESCRIPTION
        This function is used to automate the migration of Load Balanced DNS Names and associated objects (Pools/Servers/Health Monitors) from NIOS DTC to Universal DDI DTC

        Universal DDI only currently supports Round Robin, Global Availability, Ratio & Toplogy Load Balancing Methods; and TCP, HTTP & ICMP Health Checks. Unsupported Load Balancing Methods will fail, but unsupported Health Checks will be skipped gracefully.

    .PARAMETER B1DNSView
        The DNS View within Universal DDI in which to assign the new LBDNs to. The LBDNs will not initialise unless the zone(s) exist within the specified DNS View.

    .PARAMETER NIOSLBDN
        The LBDN Name within NIOS that you would like to migrate to Universal DDI.

    .PARAMETER PolicyName
        Optionally specify a DTC Policy name. DTC Policies are new in Universal DDI, so by default they will inherit the name of the DTC LBDN if this parameter is not specified.

    .PARAMETER LBDNTransform
        Use this parameter to transform the DTC LBDN FQDN from an old to new domain.

        Example: -LBDNTransform 'dtc.mydomain.com:b1dtc.mydomain.com'

        |           NIOS DTC          |        Universal DDI DTC        |
        |-----------------------------|-------------------------------|
        | myservice.dtc.mydomain.com  | myservice.b1dtc.mydomain.com  |

    .PARAMETER ApplyChanges
        Using this switch will apply the changes, otherwise the expected changes will just be displayed.

    .EXAMPLE
        PS> Copy-NIOSDTCToUDDI -B1DNSView 'My DNS View' -NIOSLBDN 'Exchange Server' -PolicyName 'Exchange' -LBDNTransform 'dtc.company.corp:b1dtc.company.corp' -ApplyChanges

        Querying Universal DDI DNS View: My DNS View
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

    .EXAMPLE
        PS> Copy-NIOSDTCToUDDI -B1DNSView 'My DNS View' -NIOSLBDN 'Exchange Server' -PolicyName 'Exchange' -LBDNTransform 'dtc.company.corp:b1dtc.company.corp'

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

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        NIOS

    .FUNCTIONALITY
        Migration
    #>
    param (
        [Parameter(Mandatory=$true)]
        $NIOSLBDN,
        [Parameter(Mandatory=$true)]
        $B1DNSView,
        [String]$PolicyName,
        [Switch]$ApplyChanges,
        [PSCustomObject]$LBDNTransform
    )

    begin {
        ## Initialize Query Filters
        $InvokeOpts = Initialize-NIOSOpts $PSBoundParameters

        $MethodArr = @{
            'round_robin' = 'RoundRobin'
            'ratio' = 'Ratio'
            'global_availability' = 'GlobalAvailability'
            'topology' = 'Topology'
        }

        $ChecksArr = @{
            'any' = 'Any'
            'all' = 'All'
            'quorum' = 'AtLeast'
        }
    }

    process {
        Write-Host "Querying Universal DDI DNS View: $($B1DNSView)" -ForegroundColor Cyan
        if (!(Get-B1DNSView $B1DNSView -Strict)) {
            Write-Error "Unable to find DNS View: $($B1DNSView)"
            return $null
        }

        Write-Host "Querying DTC LBDN: $($NIOSLBDN)" -ForegroundColor Cyan
        $LBDNToMigrate = Invoke-NIOS -Method GET -Uri "dtc:lbdn?name=$($NIOSLBDN)&_return_fields%2b=auto_consolidated_monitors,disable,health,lb_method,name,patterns,persistence,pools,priority,types,use_ttl,ttl,topology" @InvokeOpts

        if ($LBDNToMigrate) {
            if ($LBDNToMigrate.lb_method.ToLower() -notin $MethodArr.Keys) {
                Write-Error "Unsupported LBDN Load Balancing Method ($($LBDNToMigrate.lb_method.ToLower())) for: $($NIOSLBDN)"
            }

            $NewPools = @()
            $NewLBDNs = @()
            ## Build Pools
            foreach ($Pool in $LBDNToMigrate.pools) {
                Write-Host "Querying DTC Pool: $($Pool.pool)" -ForegroundColor Cyan
                $NIOSPool = Invoke-NIOS -Method GET -Uri "$($Pool.pool)?_return_fields%2b=auto_consolidated_monitors,availability,consolidated_monitors,monitors,disable,health,lb_alternate_method,lb_dynamic_ratio_alternate,lb_dynamic_ratio_preferred,lb_preferred_method,name,quorum,servers,use_ttl,ttl" @InvokeOpts
                if ($NIOSPool.lb_preferred_method.ToLower() -notin $MethodArr.Keys) {
                    Write-Error "Unsupported Pool Load Balancing Method ($($NIOSPool.lb_preferred_method.ToLower())) for: $($Pool)"
                }
                $NewPool = [PSCustomObject]@{
                    "name" = $NIOSPool.name
                    "method" = $NIOSPool.lb_preferred_method.ToLower()
                    "servers" = @()
                    "monitors" = @()
                    "ttl" = $(if ($($NIOSPool.ttl)) { $NIOSPool.ttl } else { $null } )
                    "ratio" = $Pool.ratio
                    "availability" = $NIOSPool.availability.toLower()
                    "quorum" = $NIOSPool.quorum
                    "disable" = $NIOSPool.disable
                }
                ## Build Servers
                foreach ($Server in $NIOSPool.servers) {
                    Write-Host "Querying DTC Server: $($Server.server)" -ForegroundColor Cyan
                    $NIOSServer = Invoke-NIOS -Method GET -Uri "$($Server.server)?_return_fields%2b=auto_create_host_record,disable,health,host,monitors,name,use_sni_hostname" @InvokeOpts
                    $NewServer = @{
                        "weight" = $Server.ratio
                        "AutoCreateResponses" = $NIOSServer.auto_create_host_record
                        "disable" = $NIOSServer.disable
                        "name" = $NIOSServer.name
                        "address" = $null
                        "fqdn" = $null
                    }
                    if (Test-ValidIPv4Address($NIOSServer.host)) {
                        $NewServer.address = $NIOSServer.host
                    } else {
                        $NewServer.fqdn = $NIOSServer.host
                    }
                    $NewPool.servers += $NewServer
                }
                ## Build Health Checks
                foreach ($Monitor in $NIOSPool.monitors) {
                    $ReturnFields = @('name,retry_up,retry_down,timeout,interval')
                    $Process = $true
                    Switch -Wildcard ($Monitor) {
                        "dtc:monitor:http*" {
                            $ReturnFields += @('content_check','content_check_input','content_check_op','content_check_regex','content_extract_group','content_extract_type','content_extract_value','enable_sni','port','request','result','result_code','validate_cert','secure')
                        }
                        "dtc:monitor:tcp*" {
                            $ReturnFields += @('port')
                            $Monitor
                        }
                        "dtc:monitor:icmp*" {
                            ## Nothing to add
                        }
                        default {
                            Write-Host "Found unsupported DTC Monitor. Universal DDI DTC currently supports TCP, HTTP or ICMP Health Checks, so this one will be skipped: $($Monitor)" -ForegroundColor Red
                            $Process = $false
                        }
                    }
                    if ($Process) {
                        Write-Host "Querying DTC Monitor: $($Monitor)" -ForegroundColor Cyan
                        $NIOSMonitor = Invoke-NIOS -Method GET -Uri "$($Monitor)?_return_fields%2b=$($ReturnFields -join ',')" @InvokeOpts
                        if ($NIOSMonitor.content_check -eq "EXTRACT") {
                            Write-Host "Found unsupported DTC Monitor Regex. Universal DDI DTC does not currently support multiple regex capture groups, so this one will be skipped: $($Monitor)" -ForegroundColor Red
                        } else {
                            if ($Monitor -like "dtc:monitor:http*") {
                                if ($NIOSMonitor.content_check_input -eq "HEADERS" -or "ALL") {
                                    Write-Host "Found unsupported DTC Monitor configuration. Universal DDI DTC does support checking HTTP Headers, but requires the header name is specified. As this is not available in NIOS, this portion of the health check will not be created: $($Monitor)" -ForegroundColor Yellow
                                    $NIOSMonitor.content_check_input = "BODY"
                                }
                                if ($NIOSMonitor.request -notlike "*HTTP/1.*") {
                                    $NIOSMonitor.request = $NIOSMonitor.request -Replace("`n`n$"," HTTP/1.1")
                                }
                            }
                            $NewPool.monitors += $NIOSMonitor
                        }
                    }
                }
                $NewPools += $NewPool
            }
            ## Build LBDNs
            foreach ($Pattern in $LBDNToMigrate.patterns) {
                if ($LBDNTransform) {
                    foreach ($LBDNTransformRule in $LBDNTransform) {
                        $LBDNTransformSplit = $LBDNTransformRule -split ':'
                        $From = $LBDNTransformSplit[0]
                        $To = $LBDNTransformSplit[1]
                        if ($Pattern -like "*$($From)*") {
                            $Pattern = $Pattern.Replace($From,$To)
                        }
                    }
                }
                $NewLBDNs += [PSCustomObject]@{
                    "Name" = $Pattern
                    "Description" = $LBDNToMigrate.name
                    "DNSView" = $B1DNSView
                    "ttl" = $(if ($($LBDNToMigrate.ttl)) { $LBDNToMigrate.ttl } else { $null } )
                    "priority" = $LBDNToMigrate.priority
                    "persistence" = $LBDNToMigrate.persistence
                    "types" = $LBDNToMigrate.types
                }
            }
            ## Build Policy
            if (!($PolicyName)) {
                $PolicyName = $LBDNToMigrate.name
            }
            $NewPolicy = [PSCustomObject]@{
                "Name" = $PolicyName
                "LoadBalancingMethod" = $MethodArr[$LBDNToMigrate.lb_method.ToLower()]
                "rules" = @()
            }
            ## Process Topology Rules (Assigned to LBDN in NIOS)
            if ($LBDNToMigrate.lb_method.ToLower() -eq 'topology') {
                foreach ($DTCTopologyRule in $LBDNToMigrate.topology) {
                    Write-Host "Querying DTC Topology Rule: $($DTCTopologyRule)" -ForegroundColor Cyan
                    $NIOSTopologyRules = Invoke-NIOS -Method GET -Uri "$($DTCTopologyRule)?_return_fields%2b=rules" @InvokeOpts
                    foreach ($NIOSTopologyRule in $NIOSTopologyRules.rules) {
                        Write-Host "Querying DTC Topology Rule: $($NIOSTopologyRule._ref)" -ForegroundColor Cyan
                        $iNIOSTopologyRule = Invoke-NIOS -Method GET -Uri "$($NIOSTopologyRule._ref)?_return_fields%2b=dest_type,return_type,sources,valid,destination_link" @InvokeOpts
                        foreach ($Source in $iNIOSTopologyRule.sources) {
                            if ($Source.source_type -ne 'SUBNET') {
                                Write-Host "Found unsupported DTC Topology Rule Source: $($Source.source_type). Universal DDI only supports Subnet and Default rules. Geography and Extensible Attribute/Tag based rules are not yet supported and will be skipped." -ForegroundColor Cyan
                            }
                            $Sources = $Sources | Where-Object {$_.source_type -eq 'SUBNET'}
                        }
                        if ($iNIOSTopologyRule.sources.count -eq 0) {
                            $iNIOSTopologyRule | Add-Member -MemberType NoteProperty -Name "default" -Value $true
                        }
                        if ($iNIOSTopologyRule.dest_type -eq "SERVER") {
                            Write-Host "Found unsupported DTC Topology Rule Destination. Universal DDI only supports Pool topology rulesets. Any rulesets defined as Server will need to be changed to Pool prior to migration. This one will be skipped: $($iNIOSTopologyRule._ref)" -ForegroundColor Red
                        } else {
                            $NewPolicy.rules += $iNIOSTopologyRule
                        }
                    }
                }
            }
            ## Build Results Object
            $Results = [PSCustomObject]@{
                "LBDN" = $NewLBDNs
                "Policy" = $NewPolicy
                "Pools" = $NewPools
            }
            ## Apply changes (Publish in Universal DDI)
            if ($ApplyChanges) {
                ## Create DTC Pool(s), Servers(s) & Associations
                $PoolList = @()
                ## Create Pool(s)
                foreach ($MigrationPool in $Results.pools) {
                    foreach ($MigrationServer in $MigrationPool.servers) {
                        $ServerSplat = @{
                            "Name" = $MigrationServer.name
                            "State" = $(if ($($MigrationServer.disable)) { "Disabled" } else { "Enabled" })
                            "AutoCreateResponses" = $(if ($($MigrationServer.AutoCreateResponses)) { "Enabled" } else { "Disabled" })
                        }
                        if ($MigrationServer.fqdn) {
                            $ServerSplat.FQDN = $MigrationServer.fqdn
                        } elseif ($MigrationServer.address)  {
                            $ServerSplat.IP = $MigrationServer.address
                        }
                        if ($B1DTCServer = Get-B1DTCServer -Name $MigrationServer.name -Strict) {
                            Write-Host "DTC Server already exists: $($B1DTCServer.name) - Skipping.." -ForegroundColor Yellow
                        } else {
                            $B1DTCServer = New-B1DTCServer @ServerSplat
                            if ($B1DTCServer.id) {
                                Write-Host "Successfully created DTC Server: $($B1DTCServer.name)" -ForegroundColor Green
                            } else {
                                Write-Host "Failed to create DTC Server $($ServerSplat.Name)" -ForegroundColor Red
                            }
                        }
                    }
                    $HealthChecks = @()
                    $B1HealthChecks = Get-B1DTCHealthCheck
                    ## Create Health Check(s)
                    foreach ($MigrationMonitor in $MigrationPool.monitors) {
                        $UseDefault = $false
                        switch ($MigrationMonitor.comment) {
                            "Default ICMP health monitor" {
                                if ('Default ICMP health check' -in $B1HealthChecks.comment) {
                                    $B1DTCHealthCheckName = 'ICMP health check'
                                    $UseDefault = $true
                                }
                            }
                            "Default HTTP health monitor" {
                                if ('Default HTTP health check' -in $B1HealthChecks.comment) {
                                    $B1DTCHealthCheckName = 'ICMP health check'
                                    $UseDefault = $true
                                }
                            }
                        }
                        if (!($UseDefault)) {
                            $MonitorType = (($MigrationMonitor._ref -split ':')[2] -split '/')[0]
                            if ($MonitorType -in @('http','icmp','tcp')) {
                                if ($MigrationMonitor.timeout -gt $MigrationMonitor.interval) {
                                    Write-Host "Health Check timeout exceeds its interval, setting them to match.." -ForegroundColor Magenta
                                    $MigrationMonitor.timeout = $MigrationMonitor.interval
                                }
                                $HealthCheckSplat = @{
                                    "Name" = $MigrationMonitor.name
                                    "Description" = $MigrationMonitor.comment
                                    "Type" = $MonitorType
                                    "Interval" = $MigrationMonitor.interval
                                    "Timeout" = $MigrationMonitor.timeout
                                    "RetryUp" =  $MigrationMonitor.retry_up
                                    "RetryDown" =  $MigrationMonitor.retry_down
                                }
                                if ($MonitorType -in @('http','tcp')) {
                                    $HealthCheckSplat.Port = $MigrationMonitor.port
                                }
                                if ($MonitorType -eq 'http') {
                                    $HealthCheckSplat.HTTPRequest = $MigrationMonitor.request
                                    $HealthCheckSplat.StatusCodes = $MigrationMonitor.result_code
                                    $HealthCheckSplat.UseHTTPS = $MigrationMonitor.secure

                                    if ($MigrationMonitor.content_check -eq "NONE") {
                                        $HealthCheckSplat.ResponseBody = "None"
                                    } else {
                                        Switch ($MigrationMonitor.content_check_op) {
                                            "EQ" {
                                                $MonitorOp = "Found"
                                            }
                                            "NEQ" {
                                                $MonitorOp = "NotFound"
                                            }
                                        }
                                        Switch ($MigrationMonitor.content_check_input) {
                                            "ALL" {
                                                $HealthCheckSplat.ResponseBody = $MonitorOp
                                                $HealthCheckSplat.ResponseBodyRegex = $MigrationMonitor.content_check_regex
                                            }
                                            "BODY" {
                                                $HealthCheckSplat.ResponseBody = $MonitorOp
                                                $HealthCheckSplat.ResponseBodyRegex = $MigrationMonitor.content_check_regex
                                            }
                                            # "HEADERS" {
                                            #     $HealthCheckSplat.ResponseHeader = $MonitorOp
                                            #     $HealthCheckSplat.ResponseHeaderRegexes = $MigrationMonitor.content_check_regex
                                            # }
                                        }
                                    }
                                }
                                if ($B1DTCHealthCheck = Get-B1DTCHealthCheck -Name $MigrationMonitor.name -Strict) {
                                    Write-Host "DTC Health Check already exists: $($B1DTCHealthCheck.name) - Skipping.." -ForegroundColor Yellow
                                } else {
                                    $B1DTCHealthCheck = New-B1DTCHealthCheck @HealthCheckSplat
                                    if ($B1DTCHealthCheck.id) {
                                        Write-Host "Successfully created DTC Health Check: $($B1DTCHealthCheck.name)" -ForegroundColor Green
                                        $HealthChecks += $B1DTCHealthCheck.name
                                    } else {
                                        Write-Host "Failed to create DTC Health Check: $($MigrationMonitor.name)" -ForegroundColor Red
                                    }
                                }
                            } else {
                                Write-Host "Found unsupported DTC Monitor. Universal DDI DTC currently supports TCP, HTTP or ICMP Health Checks, so this one will be skipped: $($Monitor)" -ForegroundColor Red
                            }
                        } else {
                            if ($B1DTCHealthCheckName) {
                                $HealthChecks += $B1DTCHealthCheckName
                            }
                        }
                    }
                    $PoolSplat = @{
                        "Name" = $MigrationPool.name
                        "LoadBalancingType" = $MethodArr[$MigrationPool.method]
                        "State" = $(if ($($MigrationPool.disable)) { "Disabled" } else { "Enabled" })
                        "Servers" = $(if ($MigrationPool.method -eq "ratio") { ($MigrationPool.Servers | Select-Object *,@{name="ratio-host";expression={"$($_.name):$($_.weight)"}}).'ratio-host' } else { $MigrationPool.Servers.name })
                        "PoolHealthyWhen" = $ChecksArr[$MigrationPool.availability]
                        "PoolHealthyCount" = $MigrationPool.quorum
                        "HealthChecks" = $HealthChecks
                    }
                    if ($MigrationPool.ttl) {
                        $PoolSplat.TTL = $MigrationPool.ttl
                    }
                    if ($B1DTCPool = Get-B1DTCPool -Name $MigrationPool.name -Strict) {
                        Write-Host "DTC Pool already exists: $($MigrationPool.name) - Skipping.." -ForegroundColor Yellow
                    } else {
                        $B1DTCPool = New-B1DTCPool @PoolSplat
                        if ($B1DTCPool.id) {
                            Write-Host "Successfully created DTC Pool: $($B1DTCPool.name)" -ForegroundColor Green
                        } else {
                            Write-Host "Failed to create DTC Pool $($PoolSplat.Name)" -ForegroundColor Red
                        }
                    }
                    $PoolName = $(if ($Results.Policy.LoadBalancingMethod -eq 'ratio') { "$($MigrationPool.name):$($MigrationPool.ratio)" } else { $($MigrationPool.name) })
                    $PoolList += $PoolName
                }
                ## Create Policy
                $PolicySplat = @{
                    "Name" = $Results.Policy.Name
                    "LoadBalancingType" = $Results.Policy.LoadBalancingMethod
                    "Pools" = $PoolList
                }
                ## Create Topology Rule(s)
                if ($Results.Policy.LoadBalancingMethod -eq 'topology') {
                    $TopologyRules = @()
                    foreach ($tRule in $Results.Policy.rules) {
                        $tRuleSplat = @{
                            "Type" = $(if ($tRule.default) { "Default" } else { $tRule.sources.source_type.toLower() })
                            "Destination" = $(
                                Switch ($tRule.return_type) {
                                  "REGULAR" {
                                    "Pool"
                                  }
                                  "NOERR" {
                                    "NOERROR"
                                  }
                                  "NXDOMAIN" {
                                    "NXDOMAIN"
                                  }
                                })
                            "Pool" = $tRule.destination_link.name
                            "Subnets" = $tRule.sources.source_value
                        }
                        if ($tRule.default) {
                            $tRuleSplat.Name = "Default"
                        } else {
                            $tRuleSplat.Name = $tRule.sources.source_value
                        }
                        $TopologyRules += New-B1DTCTopologyRule @tRuleSplat
                    }
                    $PolicySplat.Rules = $TopologyRules
                }
                if ($B1DTCPolicy = Get-B1DTCPolicy -Name $Results.Policy.Name -Strict) {
                    Write-Host "DTC Policy already exists: $($B1DTCPolicy.name) - Skipping.." -ForegroundColor Yellow
                } else {
                    $B1DTCPolicy = New-B1DTCPolicy @PolicySplat
                    if ($B1DTCPolicy.id) {
                        Write-Host "Successfully created DTC Policy: $($B1DTCPolicy.name)" -ForegroundColor Green
                    } else {
                        Write-Host "Failed to create DTC Policy $($Results.Policy.Name)" -ForegroundColor Red
                    }
                }
                ## Create LBDN(s)
                foreach ($MigrationLBDN in $Results.lbdn) {
                    $LBDNSplat = @{
                        "Name" = $MigrationLBDN.Name
                        "Description" = $MigrationLBDN.Description
                        "DNSView" = $MigrationLBDN.DNSView
                        "Policy" = $Results.Policy.Name
                    }
                    if ($MigrationLBDN.ttl) {
                        $LBDNSplat.TTL = $MigrationLBDN.ttl
                    }
                    if ($B1DTCLBDN = Get-B1DTCLBDN -Name $MigrationLBDN.Name -Strict) {
                        Write-Host "DTC LBDN already exists: $($B1DTCLBDN.name) - Skipping.." -ForegroundColor Yellow
                    } else {
                        $B1DTCLBDN = New-B1DTCLBDN @LBDNSplat
                        if ($B1DTCLBDN.id) {
                            Write-Host "Successfully created DTC LBDN: $($B1DTCLBDN.name)" -ForegroundColor Green
                        } else {
                            Write-Host "Failed to create DTC LBDN $($MigrationLBDN.Name)" -ForegroundColor Red
                        }
                    }
                }

            } else {
                $Results | ConvertTo-Json -Depth 10
            }
        } else {
            Write-Error "Error - Unable to find LBDN: $($NIOSLBDN)"
        }
    }
}

