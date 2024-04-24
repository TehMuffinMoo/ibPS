function Set-B1DTCPool {
    <#
    .SYNOPSIS
        Updates a pool object within BloxOne DTC

    .DESCRIPTION
        This function is used to update a pool object within BloxOne DTC
    
    .PARAMETER Name
        The name of the DTC pool object to update

    .PARAMETER NewName
        Use -NewName to update the name of the DTC Pool object

    .PARAMETER Description
        The new description for the DTC pool

    .PARAMETER LoadBalancingType
        The new Load Balancing Type to use (Round Robin / Ratio / Global Availability)

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
        The TTL to use for the DTC pool. This will override inheritance.

    .PARAMETER State
        Whether or not the new pool is created as enabled or disabled. Defaults to enabled

    .PARAMETER Tags
        Any tags you want to apply to the DTC Pool

    .PARAMETER Object
        The DTC Pool Object(s) to update. Accepts pipeline input.

    .EXAMPLE
       PS> Set-B1DTCPool 
   
    .EXAMPLE
       PS> Get-B1DTCPool -Name 'Exchange Pool' | Set-B1DTCPool -State Disabled

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    [Parameter(ParameterSetName="Default",Mandatory=$true)]
    param(
      [Parameter(ParameterSetName='Default',Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [ValidateSet('RoundRobin','Ratio','GlobalAvailability')]
      [String]$LoadBalancingType,
      [System.Object]$Servers,
      [System.Object]$HealthChecks,
      [ValidateSet('Any','All','AtLeast')]
      [String]$PoolHealthyWhen,
      [Int]$PoolHealthyCount,
      [ValidateSet('Any','All','AtLeast')]
      [String]$ServersHealthyWhen,
      [Int]$ServersHealthyCount,
      [Int]$TTL,
      [ValidateSet("Enabled","Disabled")]
      [String]$State,
      [System.Object]$Tags,
      [Parameter(
          ValueFromPipeline = $true,
          ParameterSetName="With ID",
          Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/pool") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/pool' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCPool -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Pool: $($Name)"
                return $null
            }
        }

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

        $NewObj = $Object | Select-Object -ExcludeProperty id,metadata

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($LoadBalancingType) {
            $NewObj.method = $MethodArr[$LoadBalancingType]
        }
        if ($PoolHealthyWhen) {
            $NewObj.pool_availability = $ChecksArr[$PoolHealthyWhen]
        }
        if ($PoolHealthyCount -ne $null) {
            $NewObj.pool_servers_quorum = $PoolHealthyCount
        }
        if ($ServersHealthyWhen) {
            $NewObj.server_availability = $ChecksArr[$ServersHealthyWhen]
        }
        if ($ServersHealthyCount -ne $null) {
            $NewObj.server_health_checks_quorum = $ServersHealthyCount
        }
        if ($State) {
            $NewObj.disabled = $(if ($State -eq 'Enabled') { $false } else { $true })
        }
        if ($Tags) {
            $NewObj.tags = $Tags
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
            $NewObj.servers = $ServerIDs
        } else {
            $NewObj = $NewObj | Select-Object -ExcludeProperty servers
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
            $NewObj.health_checks = $HealthCheckIDs
        } else {
            $NewObj = $NewObj | Select-Object -ExcludeProperty health_checks
        }

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
       
        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
        
    }
}