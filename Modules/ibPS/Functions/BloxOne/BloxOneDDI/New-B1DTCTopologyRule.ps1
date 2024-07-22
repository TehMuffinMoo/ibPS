function New-B1DTCTopologyRule {
    <#
    .SYNOPSIS
        Creates a new DTC Toplogy rule

    .DESCRIPTION
        This function is used to creates a new DTC Toplogy rule to be used with DTC Policies

    .PARAMETER Name
        The name of the DTC Topology Rule to create

    .PARAMETER Type
        The Topology Rule Type (Default / Subnet)

        If Default is selected, the -Name parameter will be set to 'Default'

    .PARAMETER Destination
        The type of response to send based on the rule criteria (Pool / NOERROR / NXDOMAIN)

    .PARAMETER Subnets
        The list of subnets in CIDR format to use when selecting -Type Subnet.

    .PARAMETER Pool
        The Pool name when selecting -Destination Pool

    .EXAMPLE
       PS> New-B1DTCTopologyRule -Name 'Subnet Rule' -Type 'Subnet' -Destination NXDOMAIN -Subnets '10.10.10.0/24','10.20.0.0/24'

        code        : nxdomain
        destination : code
        name        : Subnet Rule
        source      : subnet
        subnets     : {10.10.10.0/24, 10.20.0.0/24}

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [ValidateSet('Default','Subnet')]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [ValidateSet('Pool','NOERROR','NXDOMAIN')]
      [String]$Destination,
      [String]$Pool,
      [System.Object]$Subnets
    )
    $MethodArr = @{
        'RoundRobin' = 'round_robin'
        'Ratio' = 'ratio'
        'GlobalAvailability' = 'global_availability'
        'Topology' = 'topology'
    }

    $TypeArr = @{
        "NOERROR" = "nodata"
        "NXDOMAIN" = "nxdomain"
    }

    $rule = [PSCustomObject]@{
        "code" = $(if ($Destination -ne 'Pool') { $TypeArr[$Destination] } else { $null })
        "destination" = $(if ($Destination -eq 'Pool') { "pool" } else { "code" })
        "name" = $(if ($Type -eq "Default") { "Default" } else { $($Name) })
        "source" = $($Type.ToLower())
    }

    if ($Type -eq "Subnet" -and $Subnets) {
        $rule | Add-Member -MemberType NoteProperty -Name 'subnets' -Value @($Subnets)
    }
    if ($Destination -eq 'Pool' -and $Pool) {
        $DTCPool = (Get-B1DTCPool -Name $Pool -Strict).id
        if (!($DTCPool)) {
            Write-Error "DTC Pool not found: $($Pool)"
            return $null
        } else {
            $rule | Add-Member -MemberType NoteProperty -Name 'pool_id' -Value $DTCPool
        }
    }

    return $rule
}