function Get-B1Range {
    <#
    .SYNOPSIS
        Queries a list of DHCP Ranges from BloxOneDDI

    .DESCRIPTION
        This function is used to get one or more next available address blocks from IPAM based on the criteria entered

    .PARAMETER StartAddress
        Use this parameter to search by the DHCP Range start address

    .PARAMETER EndAddress
        Use this parameter to search by the DHCP Range end address

    .PARAMETER Name
        Use this parameter to search by the DHCP Range Name

    .PARAMETER Space
        Use this parameter to filter the list of Address Blocks by Space

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER id
        Filter the results by range id

    .Example
        Get-B1Range -StartAddress "10.10.100.200" -EndAddress "10.10.100.250"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
      [String]$StartAddress,
      [String]$EndAddress,
      [String]$Name,
      [String]$Space,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [Switch]$Strict,
      [String]$id
    )

	$MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($StartAddress) {
        $Filters.Add("start==`"$StartAddress`"") | Out-Null
    }
    if ($EndAddress) {
        $Filters.Add("end==`"$EndAddress`"") | Out-Null
    }
    if ($Name) {
        $Filters.Add("name$MatchType`"$Name`"") | Out-Null
    }
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        Query-CSP -Uri "ipam/range?_filter=$Filter&_limit=$Limit&_offset=$Offset" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Uri "ipam/range?_limit=$Limit&_offset=$Offset" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}