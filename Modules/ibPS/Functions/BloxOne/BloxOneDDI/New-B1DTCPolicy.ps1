function New-B1DTCPolicy {
    <#
    .SYNOPSIS
        Creates a new policy object within BloxOne DTC

    .DESCRIPTION
        This function is used to create a new policy object within BloxOne DTC
    
    .PARAMETER Name
        The name of the DTC policy object to create

    .PARAMETER Description
        The description for the new policy object

    .PARAMETER LoadBalancingType
        The Load Balancing Type to use (Round Robin / Ratio / Global Availability)

        If Ratio is selected, the -Pools parameter must include both the Pool Name and Weight separated by a colon. ( -Servers "POOL-A:1","POOL-B:2" )

    .PARAMETER Pools
        The list of DTC Pools to assign to the policy. This supports tab-completion to list available DTC pools.

    .PARAMETER Rules
        The list of rules to apply when using the Topology Load Balancing Type

        You can generate the list of rules using New-B1DTCTopologyRule. See Example #3

    .PARAMETER TTL
        The TTL to use for the DTC Policy. This will override inheritance.

    .PARAMETER State
        Whether or not the new policy is created as enabled or disabled. Defaults to enabled

    .PARAMETER Tags
        Any tags you want to apply to the DTC policy

    .EXAMPLE
       PS> New-B1DTCPolicy -Name 'Exchange-Policy' -Description 'Exchange Policy' -LoadBalancingType GlobalAvailability -Pools 'Exchange Pool' -TTL 10 -Tags @{'Owner' = 'Network Team'}

        id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
        name                : Exchange-Policy
        comment             : Exchange Policy
        tags                : @{Owner=Network Team}
        disabled            : False
        method              : global_availability
        ttl                 : 10
        pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange Pool; weight=1}}
        inheritance_sources : 
        rules               : {}
        metadata            :

    .EXAMPLE
       PS> New-B1DTCPolicy -Name 'Exchange-Policy' -Description 'Exchange Policy' -LoadBalancingType Topology -Pools 'Exchange Pool' -TTL 10

        id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
        name                : Exchange-Policy
        comment             : Exchange Policy
        tags                : 
        disabled            : False
        method              : topology
        ttl                 : 10
        pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange Pool; weight=1}}
        inheritance_sources : 
        rules               : {}
        metadata            :   
        
    .EXAMPLE
        $TopologyRules = @()
        $TopologyRules += New-B1DTCTopologyRule -Name 'Rule 1' -Type 'Subnet' -Destination NXDOMAIN -Subnets '10.10.10.0/24','10.20.0.0/24'
        $TopologyRules += New-B1DTCTopologyRule -Name 'Rule 2' -Type 'Default' -Destination Pool -Pool Exchange-Pool -Subnets '10.25.0.0/16','10.30.0.0/16'

        New-B1DTCPolicy -Name 'Exchange-Policy' -Description 'Exchange Policy' -LoadBalancingType Topology -Pools Exchange-Pool -TTL 10 -Rules $TopologyRules

        id                  : dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7
        name                : Exchange-Policy
        comment             : Exchange Policy
        tags                : 
        disabled            : False
        method              : topology
        ttl                 : 10
        pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange-Pool; weight=1}}
        inheritance_sources : 
        rules               : {@{name=Rule 1; source=subnet; subnets=System.Object[]; destination=code; code=nxdomain; pool_id=}, @{name=Default; source=default; subnets=System.Object[]; destination=pool; code=; pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f}}
        metadata
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [ValidateSet('RoundRobin','Ratio','GlobalAvailability','Topology')]
      [Parameter(Mandatory=$true)]
      [String]$LoadBalancingType,
      [System.Object]$Pools,
      [System.Object]$Rules,
      [Int]$TTL,
      [ValidateSet("Enabled","Disabled")]
      [String]$State = 'Enabled',
      [System.Object]$Tags
    )

    $MethodArr = @{
        'RoundRobin' = 'round_robin'
        'Ratio' = 'ratio'
        'GlobalAvailability' = 'global_availability'
        'Topology' = 'topology'
    }

    $splat = @{
        "name" = $Name
        "comment" = $Description
        "method" = $MethodArr[$LoadBalancingType]
        "disabled" = $(if ($State -eq 'Enabled') { $false } else { $true })
        "pools" = @()
        "tags" = $Tags
    }
    if ($LoadBalancingType -eq "Topology" -and $Rules) {
        $splat | Add-Member -MemberType NoteProperty -Name "rules" -Value ($Rules | Sort-Object source -Descending)
    }
    if ($Pools) {
        $PoolIDs = @()
        foreach ($Pool in $Pools) {
            if ($LoadBalancingType -eq "Ratio") {
                $PoolObj = $Pool -Split ':'
                $Pool = $PoolObj[0]
                $Weight = $PoolObj[1]
                if (!($Pool -and $Weight)) {
                    Write-Error 'Invalid Pool format. You must specify the Pool and Weight in colon separated format (POOL-1:1,POOL-2:2) when using -LoadBalancingType Ratio'
                    return $null
                }
            }
            $DTCPool = Get-B1DTCPool -Name $Pool -Strict
            if (!$DTCPool) {
                Write-Error "DTC Pool Not Found: $($Pool)"
                return $null
            }
            $DTCPoolObj = [PSCustomObject]@{
                "pool_id" = $DTCPool.id
            }
            if ($LoadBalancingType -eq "Ratio") {
                $DTCPoolObj | Add-Member -Name 'weight' -Value $Weight -MemberType NoteProperty
            }
            $PoolIDs += $DTCPoolObj
        }
        $splat.pools = $PoolIDs
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

    $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/policy" -Data $JSON
    if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
        $Results | Select-Object -ExpandProperty result
    } else {
        $Results
    }

}