function Get-B1IPAMChild {
    <#
    .SYNOPSIS
        Retrieves a list of child objects from IPAM

    .DESCRIPTION
        This function is used to query a list of child objects from IPAM, relating to a specific parent.

        This accepts pipeline input from Get-B1Space, Get-B1AddressBlock, Get-B1Subnet & Get-B1Range

    .PARAMETER id
        The ID of the parent object to list child objects for

    .PARAMETER Limit
        Limits the number of results returned, the default is 100

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .EXAMPLE
        PS> Get-B1Space -Name "my-ipspace" | Get-B1IPAMChild

    .EXAMPLE
        PS> Get-B1AddressBlock -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild
        
    .EXAMPLE
        PS> Get-B1Subnet -Subnet "10.10.10.0" -CIDR 24 -Space "my-ipspace" | Get-B1IPAMChild

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DHCP
    #>
    param (
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
        )]
        [String[]]$ID,
        [Int]$Limit = 100,
        [Int]$Offset = 0,
        [String[]]$Fields,
        [String]$OrderBy
    )

    process {
        $PermittedInputs = "ip_space","address_block","subnet","range"
        if (($ID.split('/')[1]) -notin $PermittedInputs) {
            Write-Error "Error. Unsupported pipeline object. Supported inputs are ip_space, address_block, subnet & range"
            return $null
        }

        if ($Limit) {
        $LimitString = "_limit=$($Limit)&"
        }

        [System.Collections.ArrayList]$QueryFilters = @()
        $QueryFilters.Add("node=$ID") | Out-Null
        $QueryFilters.Add("view=SPACE") | Out-Null
        $QueryFilters.Add("_limit=$Limit") | Out-Null
        $QueryFilters.Add("_offset=$Offset") | Out-Null
        if ($Fields) {
            $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
        }
        if ($OrderBy) {
            $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
        }
        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }

        if ($QueryString) {
            Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/htree$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
            Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/htree" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
    }
}