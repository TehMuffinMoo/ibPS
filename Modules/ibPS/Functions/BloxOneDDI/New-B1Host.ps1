﻿function New-B1Host {
    <#
    .SYNOPSIS
        Creates a new BloxOneDDI Host

    .DESCRIPTION
        This function is used to create a new BloxOneDDI Host

    .PARAMETER Name
        The name of the BloxOneDDI host to create

    .PARAMETER Space
        The IPAM space where the BloxOneDDI host should be placed

    .PARAMETER Description
        The description of the new BloxOneDDI Host

    .Example
        New-B1Host -Name "bloxoneddihost1.mydomain.corp" -Description "My BloxOneDDI Host" -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        Host
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [String]$Description
    )
    if (Get-B1Host -Name $Name -Strict) {
        Write-Host "$Name already exists as an On-Prem host." -ForegroundColor Red
        break
    }

    $splat = @{
        "display_name" = $Name
        "ip_space" = (Get-B1Space -Name $Space -Strict).id
        "description" = $Description
    }

    $splat = $splat | ConvertTo-Json
    if ($Debug) {$splat}

    $Result = Query-CSP -Method POST -Uri "https://csp.infoblox.com/api/infra/v1/hosts" -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue
    $Result
    if ($Result.display_name -eq $Name) {
        Write-Host "On-Prem host $Name created successfully." -ForegroundColor Green
    } else {
        Write-Host "Failed to create On-Prem host $Name." -ForegroundColor Red
    }
}