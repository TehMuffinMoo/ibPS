function Get-B1DHCPLease {
    <#
    .SYNOPSIS
        Retrieves a list of DHCP Leases from BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to query a list of DHCP Leases from BloxOneDDI IPAM

    .PARAMETER Range
        Indicates whether to search by DHCP Range

    .PARAMETER RangeStart
        The start address of the DHCP Range to search

    .PARAMETER RangeEnd
        The end address of the DHCP Range to search

    .PARAMETER Address
        Filter the DHCP Leases by IP Address

    .PARAMETER MACAddress
        Filter the DHCP Leases by MAC Address

    .PARAMETER Hostname
        Filter the DHCP Leases by Hostname

    .PARAMETER HAGroup
        Filter the DHCP Leases by HA Group

    .PARAMETER DHCPServer
        Filter the DHCP Leases by DHCP Server

    .PARAMETER Space
        Filter the DHCP Leases by IPAM Space

    .PARAMETER Limit
        Limits the number of results returned, the default is 100

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .Example
        Get-B1DHCPLease -Range -RangeStart 10.10.100.20 -RangeEnd 10.10.100.50 -Limit 100

    .Example
        Get-B1DHCPLease -Address "10.10.100.30"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(DefaultParameterSetName="st")]
    param (
        [Switch][parameter(ParameterSetName="htree")] $Range,
        [String][parameter(ParameterSetName="htree", Mandatory=$true)] $RangeStart,
        [String][parameter(ParameterSetName="htree")] $RangeEnd,
        [String][parameter(ParameterSetName="std")] $Address,
        [String][parameter(ParameterSetName="std")] $MACAddress,
        [String][parameter(ParameterSetName="std")] $Hostname,
        [String][parameter(ParameterSetName="std")] $HAGroup,
        [String][parameter(ParameterSetName="std")] $DHCPServer,
        [String]$Space = "Global",
        [String]$Limit = 100,
        [switch]$Strict
    )
    $MatchType = Match-Type $Strict

    if ($Limit) {
      $LimitString = "_limit=$($Limit)&"
    }

    if ($Range -or $RangeStart -or $RangeEnd) {
        $Range = $true
        $B1Range = Get-B1Range -StartAddress $RangeStart -EndAddress $RangeEnd
        if ($Range) {
            Query-CSP -Method GET -Uri "ipam/htree?$($LimitString)view=SPACE&state=used&node=$($B1Range.id)" | Select -ExpandProperty results -ErrorAction SilentlyContinue | Select -ExpandProperty dhcp_info -ErrorAction SilentlyContinue
        } else {
          Write-Host "Error. Range not found." -ForegroundColor Red
        }
    } else {
        $HAGroups = Get-B1HAGroup
        $DHCPHosts = Get-B1DHCPHost
        [System.Collections.ArrayList]$Filters = @()
        if ($Address) {
            $Filters.Add("address==`"$Address`"") | Out-Null
        }
        if ($MACAddress) {
            $Filters.Add("client_id==`"$MACAddress`"") | Out-Null
        }
        if ($Hostname) {
            $Filters.Add("hostname$MatchType`"$Hostname`"") | Out-Null
        }
        if ($HAGroup) {
            $HAGroupId = ($HAGroups | where {$_.name -eq $HAGroup}).id
            $Filters.Add("ha_group==`"$HAGroupId`"") | Out-Null
        }
        if ($DHCPServer) {
            $DHCPHostId = (Get-B1DHCPHost -Name $DHCPServer -Strict:$Strict).id
            $Filters.Add("host==`"$DHCPHostId`"") | Out-Null
        }
        if ($Space) {
            $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
            $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
        }


        if ($Filters) {
            $Filter = Combine-Filters $Filters
            $Query = "?_filter=$Filter"
            Query-CSP -Method GET -Uri "dhcp/lease?$($LimitString)_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select @{Name = 'ha_group_name'; Expression = {$ha_group = $_.ha_group; (@($HAGroups).where({ $_.id -eq $ha_group })).name }},@{Name = 'dhcp_server'; Expression = {$dhcpserver = $_.host; (@($DHCPHosts).where({ $_.id -eq $dhcpserver })).name }},*
        } else {
            Query-CSP -Method GET -Uri "dhcp/lease$($LimitString)" | Select -ExpandProperty results -ErrorAction SilentlyContinue | select @{Name = 'ha_group_name'; Expression = {$ha_group = $_.ha_group; (@($HAGroups).where({ $_.id -eq $ha_group })).name }},@{Name = 'dhcp_server'; Expression = {$dhcpserver = $_.host; (@($DHCPHosts).where({ $_.id -eq $dhcpserver })).name }},*
        }
    }
}