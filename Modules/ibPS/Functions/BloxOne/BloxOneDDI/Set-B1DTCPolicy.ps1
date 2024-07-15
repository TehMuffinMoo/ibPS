function Set-B1DTCPolicy {
    <#
    .SYNOPSIS
        Updates a policy object within BloxOne DTC

    .DESCRIPTION
        This function is used to update a policy object within BloxOne DTC

    .PARAMETER Name
        The name of the DTC policy object to update

    .PARAMETER NewName
        Use -NewName to update the name of the DTC Policy object

    .PARAMETER Description
        The new description for the policy object

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

    .PARAMETER Object
        The DTC Policy Object(s) to update. Accepts pipeline input.

    .EXAMPLE
       PS> Set-B1DTCPolicy -Name 'Exchange-Policy' -LoadBalancingType Ratio -Pools Exchange-Pool:5,Exchange-Pool-Backup:10 -TTL 10

        id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
        name                : Exchange-Policy
        comment             :
        tags                :
        disabled            : False
        method              : global_availability
        ttl                 : 10
        pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange-Pool; weight=1}, ${pool_id=dtc/pool/23404tg-gt54-g4vg-c442-cw4vw3v4f; name=Exchange-Pool-Backup; weight=10}}
        inheritance_sources :
        rules               : {@{name=Default; source=default; subnets=System.Object[]; destination=code; code=nodata; pool_id=}}
        metadata            :

    .EXAMPLE
       PS> Get-B1DTCPolicy -Name 'Exchange-Policy' | Set-B1DTCPolicy -LoadBalancingType GlobalAvailability -Pools Exchange-Pool -TTL 10

        id                  : dtc/policy/cgg5h6tgfs-dfg7-t5rf-f4tg-edgfre45g0
        name                : Exchange-Policy
        comment             :
        tags                :
        disabled            : False
        method              : global_availability
        ttl                 : 10
        pools               : {@{pool_id=dtc/pool/0gt45t5t-g5g5-h5hg-5h5f-8vd89dr39f; name=Exchange-Pool; weight=1}}
        inheritance_sources :
        rules               : {@{name=Default; source=default; subnets=System.Object[]; destination=code; code=nodata; pool_id=}}
        metadata            :

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
      [ValidateSet('RoundRobin','Ratio','GlobalAvailability','Topology')]
      [String]$LoadBalancingType,
      [System.Object]$Pools,
      [System.Object]$Rules,
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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/policy") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/policy' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCPolicy -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Policy: $($Name)"
                return $null
            }
        }

        $MethodArr = @{
            'RoundRobin' = 'round_robin'
            'Ratio' = 'ratio'
            'GlobalAvailability' = 'global_availability'
            'Topology' = 'topology'
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty id,metadata

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($LoadBalancingType) {
            $NewObj.method = $MethodArr[$LoadBalancingType]
        }
        if ($Rules) {
            if ("Topology" -in @($($Object.method),$LoadBalancingType)) {
                $NewObj.rules = @($Rules | Sort-Object source -Descending)
            } else {
                Write-Error "The Load Balancing Type should be set to Topology to configure Topology Rules."
                return $null
            }
        } else {
            $NewObj = $NewObj | Select-Object * -ExcludeProperty rules
        }
        if ($Pools) {
            $PoolIDs = @()
            foreach ($Pool in $Pools) {
                if ("Ratio" -in @($($Object.method),$LoadBalancingType)) {
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
                if ("Ratio" -in @($($Object.method),$LoadBalancingType)) {
                    $DTCPoolObj | Add-Member -Name 'weight' -Value $Weight -MemberType NoteProperty
                }
            }
            $NewObj.pools = $PoolIDs
        } else {
            $NewObj = $NewObj | Select-Object * -ExcludeProperty pools
        }
        if ($TTL) {
            $NewObj.ttl = $TTL
            $NewObj.inheritance_sources = @{
                "ttl" = @{
                    "action" = "override"
                }
            }
        }
        if ($State) {
            $NewObj.disabled = $(if ($State -eq 'Enabled') { $false } else { $true })
        }
        if ($Tags) {
            $NewObj.tags = $Tags
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