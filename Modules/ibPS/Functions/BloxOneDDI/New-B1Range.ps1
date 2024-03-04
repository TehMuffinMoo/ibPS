function New-B1Range {
    <#
    .SYNOPSIS
        Creates a new DHCP Range in BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to create a new DHCP Range in BloxOneDDI IPAM

    .PARAMETER Name
        The name of the DHCP Range you want to create

    .PARAMETER StartAddress
        The start address of the DHCP Range you want to create

    .PARAMETER EndAddress
        The end address of the DHCP Range you want to create

    .PARAMETER Space
        The IPAM space where the DHCP Range is to be placed

    .PARAMETER Description
        The description of the DHCP Range you want to create

    .PARAMETER HAGroup
        The name of the HA group to apply to this DHCP Range

    .PARAMETER Tags
        Any tags you want to apply to the DHCP Range

    .EXAMPLE
        PS> New-B1Range -Name "Client Range" -StartAddress "10.250.20.20" -EndAddress "10.250.20.100" -Space "Global" -Description "Range for Client IPs"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$StartAddress,
      [Parameter(Mandatory=$true)]
      [String]$EndAddress,
      [Parameter(Mandatory=$true)]
      [string]$Space,
      [String]$Description,
      [String]$HAGroup,
      [System.Object]$Tags
    )

    if (Get-B1Range -StartAddress $StartAddress) {
        Write-Host "DHCP Range already exists." -ForegroundColor Red
    } else {
        Write-Host "Creating DHCP Range..." -ForegroundColor Gray
        $splat = @{
    	    "name" = $Name
	        "comment" = $Description
	        "start" = $StartAddress
	        "end" = $EndAddress
	        "space" = (Get-B1Space -Name $Space -Strict).id
	        "inheritance_sources" = @{
    		    "dhcp_options" = @{
			        "action" = "inherit"
			        "value" = @()
		        }
	        }
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }
        if ($HAGroup) {
            $splat | Add-Member -MemberType NoteProperty -Name "dhcp_host" -Value (Get-B1HAGroup -Name $HAGroup -Strict).id
        }

        $splat = $splat | ConvertTo-Json -Depth 10
        if ($Debug) {$splat}
        $Result = Query-CSP -Method POST -Uri "ipam/range" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.start -eq $StartAddress -and $Result.end -eq $EndAddress) {
            Write-Host "Created DHCP Range Successfully. Start: $StartAddress - End: $EndAddress" -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create DHCP Range." -ForegroundColor Red
        }
    }
}