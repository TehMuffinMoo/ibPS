function Get-B1DNSUsage {
    <#
    .SYNOPSIS
        Queries an IP Address against BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to query an IP Address against the BloxOneDDI IPAM and return any records associated with that IP.

    .PARAMETER Address
        Indicates whether to search by DHCP Range

    .PARAMETER Space
        Filter the results by IPAM Space

    .PARAMETER ParseDetails
        Whether to enhance the data by resolving the Authoritative Zone, IPAM Space & DNS View names
        
    .EXAMPLE
        PS> Get-B1DNSUsage -Address "10.10.100.30" -Space "Global" -ParseDetails
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [String]$Address,
        [String]$Space,
        [Switch]$ParseDetails
    )
    [System.Collections.ArrayList]$Filters = @()
    if ($Address) {
        $Filters.Add("address==`'$Address`'") | Out-Null
    }
    if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
    }
    if ($Filters) {
        $QueryFilter = Combine-Filters $Filters
        Write-DebugMsg -Filters $Filters
        if ($ParseDetails) {
          $AuthZones = Get-B1AuthoritativeZone
          $Spaces = Get-B1Space
          $Views = Get-B1DNSView
          Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/dns_usage?_filter=$QueryFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue | Select-Object address,name,type,absolute_name,@{Name = 'zone'; Expression = {$authzone = $_.zone; (@($AuthZones).where({ $_.id -eq $authzone })).fqdn }},@{Name = 'space'; Expression = {$ipamspace = $_.space; (@($Spaces).where({ $_.id -eq $ipamspace })).name }},@{Name = 'view'; Expression = {$dnsview = $_.view; (@($Views).where({ $_.id -eq $dnsview })).name }},* -ErrorAction SilentlyContinue
        } else {
          Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/dns_usage?_filter=$QueryFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue | Select-Object address,name,type,absolute_name,zone,space,* -ErrorAction SilentlyContinue
        }
    } else {
        if ($ParseDetails) {
          $AuthZones = Get-B1AuthoritativeZone
          $Spaces = Get-B1Space
          $Views = Get-B1DNSView
          Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/dns_usage" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue | Select-Object address,name,type,absolute_name,@{Name = 'zone'; Expression = {$authzone = $_.zone; (@($AuthZones).where({ $_.id -eq $authzone })).fqdn }},@{Name = 'space'; Expression = {$ipamspace = $_.space; (@($Spaces).where({ $_.id -eq $ipamspace })).name }},@{Name = 'view'; Expression = {$dnsview = $_.view; (@($Views).where({ $_.id -eq $dnsview })).name }},* -ErrorAction SilentlyContinue
        } else {
          Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/dns_usage" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue | Select-Object address,name,type,absolute_name,zone,space,* -ErrorAction SilentlyContinue
        }
    }
}