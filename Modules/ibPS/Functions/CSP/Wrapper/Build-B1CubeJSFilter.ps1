function Build-B1CubeJSFilter {
    <#
    .SYNOPSIS
        A wrapper function for building CubeJS filters for use with Invoke-B1CubeJS

    .DESCRIPTION
        This is a wrapper function used for building CubeJS filters for use with Invoke-B1CubeJS.

    .PARAMETER Cube
        Specify the name of the cube to query and should match the cube specified in Invoke-B1CubeJS. This field supports auto/tab-completion.

    .PARAMETER Member
        Specify one or more dimensions. This field supports auto/tab-completion.
        Dimensions are referred to as categorical data, such as ip address, hostname, status or timestamps.

    .PARAMETER Operator
        Specify the operator to use for the filter. This field supports auto/tab-completion.

    .PARAMETER Values
        Specify one or more values to use for the filter.
        Values must be of type String. (Or array of strings)

    .EXAMPLE
        PS> $Filters = @()
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

    .FUNCTIONALITY
        CubeJS

    .FUNCTIONALITY
        Infoblox Threat Defense

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Cube,
        [Parameter(Mandatory=$true)]
        [String]$Member,
        [Parameter(Mandatory=$true)]
        [ValidateSet("equals","notEquals","contains","notContains","startsWith","notStartsWith","endsWith","notEndsWith","gt","gte","lt","lte","set","notSet","inDateRange","notInDateRange","beforeDate","beforeOrOnDate","afterDate","afterOrOnDate","measureFilter")]
        [String]$Operator,
        [Parameter(Mandatory=$true)]
        [String[]]$Values
    )

    return @{
        "member" = "$($Cube).$($Member)"
        "operator" = $Operator
        "values" = $Values
    }
}