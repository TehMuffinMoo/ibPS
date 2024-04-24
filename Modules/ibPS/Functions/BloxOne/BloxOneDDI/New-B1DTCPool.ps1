function New-B1DTCPool {
    <#
    .SYNOPSIS
        Creates a new pool object within BloxOne DTC

    .DESCRIPTION
        This function is used to create a new pool object within BloxOne DTC
    
    .PARAMETER Name
        The name of the DTC pool object to create

    .PARAMETER Description
        The description for the new pool object

    .PARAMETER LoadBalancingType
        The Load Balancing Type to use (Round Robin / Ratio / Global Availability)

        If Ratio is selected, the -Servers parameter must include both the Server Name and Weight separated by a colon. ( -Servers "SERVER-PRIMARY:1","SERVER-BACKUP:2" )

    .PARAMETER Servers
        The list of DTC Servers to assign to the pool. This supports tab-completion to list available DTC servers.

    .PARAMETER HealthChecks
        The list of DTC Health Checks to assign to the pool. This supports tab-completion to list available DTC Health Checks.

    .PARAMETER PoolHealthyWhen
        Report the Pool Health Status as Healthy when (Any/All/AtLeast) Servers are healthy

        If At Least is selected, this must be used in conjunction with -PoolHealthyCount to set the number of required healthy servers

    .PARAMETER PoolHealthyCount
        The number of DTC Servers within the pool that are required for the pool to be reported as healthy. This is used in conjunction with: -PoolHealthyWhen AtLeast

    .PARAMETER ServersHealthyWhen
        Report the Server Health Status as Healthy when (Any/All/At Least) Health Checks are healthy

        If At Least is selected, this must be used in conjunction with -ServerHealthyCount to set the number of required health checks

    .PARAMETER ServersHealthyCount
        The number of DTC Health Checks assigned to the server that are required for the server to be reported as healthy. This is used in conjunction with: -ServerHealthyWhen AtLeast

    .PARAMETER TTL
        The TTL to use for the DTC pool

    .PARAMETER State
        Whether or not the new pool is created as enabled or disabled. Defaults to enabled

    .PARAMETER Tags
        Any tags you want to apply to the DTC Pool

    .EXAMPLE
       PS> 
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [ValidateSet('RoundRobin','Ratio','GlobalAvailability')]
      [Parameter(Mandatory=$true)]
      [String]$LoadBalancingType,
      [System.Object]$Servers,
      [System.Object]$HealthChecks,
      [ValidateSet('Any','All','AtLeast')]
      [String]$PoolHealthyWhen = 'Any',
      [Int]$PoolHealthyCount = 0,
      [ValidateSet('Any','All','AtLeast')]
      [String]$ServersHealthyWhen = 'Any',
      [Int]$ServersHealthyCount = 0,
      [Int]$TTL,
      [ValidateSet("Enabled","Disabled")]
      [String]$State = 'Enabled',
      [System.Object]$Tags
    )

    $ChecksArr = @{
        'Any' = 'any'
        'All' = 'all'
        'AtLeast' = 'quorum'
    }
    $MethodArr = @{
        'RoundRobin' = 'round_robin'
        'Ratio' = 'ratio'
        'GlobalAvailability' = 'global_availability'
    }

    $splat = @{
        "name" = $Name
        "comment" = $Description
        "method" = $MethodArr[$LoadBalancingType]
        "disabled" = $(if ($State -eq 'Enabled') { $false } else { $true })
        "pool_availability" = $ChecksArr[$PoolHealthyWhen]
        "pool_servers_quorum" = $PoolHealthyCount
        "server_availability" = $ChecksArr[$ServersHealthyWhen]
        "server_health_checks_quorum" = $ServersHealthyCount
        "servers" = @()
        "health_checks" = @()
        "tags" = $Tags
    }
    if ($Servers) {
        $ServerIDs = @()
        foreach ($Server in $Servers) {
            if ($LoadBalancingType -eq "Ratio") {
                $ServerObj = $Server -Split ':'
                $Server = $ServerObj[0]
                $Weight = $ServerObj[1]
                if (!($Server -and $Weight)) {
                    Write-Error 'Invalid Server format. You must specify the Server and Weight in colon separated format (SERVER-PRIMARY:1,SERVER-BACKUP:2) when using -LoadBalancingType Ratio'
                    return $null
                }
            }
            $DTCServer = Get-B1DTCServer -Name $Server -Strict
            if (!$DTCServer) {
                Write-Error "DTC Server Not Found: $($Server)"
                return $null
            }
            $DTCServerObj = [PSCustomObject]@{
                "server_id" = $DTCServer.id
            }
            if ($LoadBalancingType -eq "Ratio") {
                $DTCServerObj | Add-Member -Name 'weight' -Value $Weight -MemberType NoteProperty
            }
            $ServerIDs += $DTCServerObj
        }
        $splat.servers = $ServerIDs
    }
    if ($HealthChecks) {
        $HealthCheckIDs = @()
        foreach ($HealthCheck in $HealthChecks) {
            $DTCHealthCheck = Get-B1DTCHealthCheck -Name $HealthCheck -Strict
            if (!$DTCHealthCheck) {
                Write-Error "DTC Health Check Not Found: $($HealthCheck)"
                return $null
            }
            $HealthCheckIDs += [PSCustomObject]@{
                "health_check_id" = $DTCHealthCheck.id
            }
        }
        $splat.health_checks = $HealthCheckIDs
    }
    if ($TTL) {
        $splat += @{
            "ttl" = $TTL
            "inheritance_sources" = @{
                "ttl" = @{
                    "action" = "override"
                }
            }
        }
    }

    $JSON = $splat | ConvertTo-Json -Depth 5 -Compress

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/pool" -Data $JSON
    if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
        $Results | Select-Object -ExpandProperty result
    } else {
        $Results
    }

}