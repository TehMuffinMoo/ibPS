function New-B1DNSView {
    <#
    .SYNOPSIS
        Creates a new BloxOneDDI DNS View

    .DESCRIPTION
        This function is used to create a new BloxOneDDI DNS View

    .PARAMETER Name
        The name of the DNS View

    .PARAMETER Description
        The description of the DNS View you are creating

    .PARAMETER Tags
        Any tags you want to apply to the new DNS View

    .PARAMETER Space
        The IP Space to assign the new DNS View to

    .EXAMPLE
        PS> New-B1DNSView -Name "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Description,
      [String]$Space,
      [System.Object]$Tags
    )
    $B1DNSView = Get-B1DNSView -Name $Name -Strict 6> $null
    if ($B1DNSView) {
        Write-Error "DNS View with name: $Name already exists"
    } else {
        Write-Host "Creating DNS View..." -ForegroundColor Gray

        $splat = @{
            "name" = $Name
            "comment" = $Description
        }

        if ($Space) {
            $B1Space = Get-B1Space -Name $Space 6> $null
            $splat.ip_spaces = @(
                $B1Space.id
            )
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4
        if ($ENV:IBPSDebug -eq "Enabled") {$splat}

        $Result = Query-CSP -Method POST -Uri "dns/view" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        
        if ($Result.name -eq $Name) {
            Write-Host "DNS View: $($Name) created successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create DNS View: $($Name)." -ForegroundColor Red
            break
        }
    }
}