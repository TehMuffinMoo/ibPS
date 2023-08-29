function Get-B1FixedAddress {
    <#
    .SYNOPSIS
        Retrieves a list of Fixed Addresses in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to query a list of Fixed Addresses in BloxOneDDI IPAM

    .PARAMETER IP
        The IP of the fixed address

    .PARAMETER Space
        Use this parameter to filter the list of fixed addresses by Space

    .PARAMETER id
        Use the id parameter to filter the results by ID

    .Example
        Get-B1FixedAddress -IP 10.10.100.12
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param(
        [String]$IP = $null,
        [String]$Space,
        [String]$id
    )

    if ($Space) {$SpaceUUID = (Get-B1Space -Name $Space -Strict).id}

    [System.Collections.ArrayList]$Filters = @()
    if ($IP) {
        $Filters.Add("address==`"$IP`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
    }
    if ($SpaceUUID) {
        $Filters.Add("ip_space==`"$SpaceUUID`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        Query-CSP -Method GET -Uri "dhcp/fixed_address?_filter=$Filter" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        Query-CSP -Method GET -Uri "dhcp/fixed_address" | Select -ExpandProperty results -ErrorAction SilentlyContinue
    }
}