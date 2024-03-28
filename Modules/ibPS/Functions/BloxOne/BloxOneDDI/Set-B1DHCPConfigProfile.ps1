function Set-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Updates an existing DHCP Config Profiles from BloxOneDDI

    .DESCRIPTION
        This function is used to update an existing DHCP Config Profiles from BloxOneDDI

    .PARAMETER Name
        The name of the DHCP Config Profile

    .PARAMETER DDNSZones
        Provide a list of DDNS Zones to add or remove to/from the the DHCP Config Profile.
        
        This is to be used in conjunction with -AddDDNSZones and -RemoveDDNSZones respectively.

    .PARAMETER AddDDNSZones
        This switch determines if you want to add DDNS Zones using the -DDNSZones parameter

    .PARAMETER RemoveDDNSZones
        This switch determines if you want to remove DDNS Zones using the -DDNSZones parameter

    .PARAMETER DNSView
        The DNS View the Authoritative DDNS Zones are located in

    .PARAMETER Tags
        The tags to apply to the DHCP Config Profile

    .PARAMETER id
        The id of the DHCP config profile to update. Accepts pipeline input

    .EXAMPLE
        PS> Get-B1DHCPConfigProfile -Name "Data Centre" -Strict -IncludeInheritance

    .FUNCTIONALITY
        BloxOneDDI
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [Switch]$AddDDNSZones,
      [Switch]$RemoveDDNSZones,
      [System.Object]$DDNSZones,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$DNSView,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
        if ($AddDDNSZones -and $RemoveDDNSZones) {
            Write-Host "Error. You can only specify Add or Remove for DDNS Zones." -ForegroundColor Red
            break
        } else {
            $ToUpdate = @()
            if ($id) {
              $ConfigProfile = Get-B1DHCPConfigProfile -id $id -IncludeInheritance
            } else {
              $ConfigProfile = Get-B1DHCPConfigProfile -Name $Name -IncludeInheritance -Strict
            }

            if (!($ConfigProfile) ) {
                Write-Host "Error. Config Profile $Name not found" -ForegroundColor Red
            } else {
                if ($Tags) {
                    $ConfigProfile.tags = $Tags
                }
                if ($AddDDNSZones) {
                    $ConfigProfileJson = @()
                    foreach ($DDNSZone in $DDNSZones) {
                        $DDNSZone = $DDNSZone.TrimEnd(".")
                        if (("$DDNSZone.") -in $ConfigProfile.ddns_zones.fqdn) {
                            Write-Host "$DDNSZone already exists. Skipping.." -ForegroundColor Yellow
                        } else {
                            $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                            if ($AuthZone) {
                                $splat = @{
                                    "zone" = $AuthZone.id
                                }
                                $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                                $ConfigProfileJson += $splat
                            } else {
                                Write-Host "Error: Authoritative Zone not found." -ForegroundColor Red
                            }
                            $ToUpdate += $DDNSZone
                        }
                    }
                    foreach ($DDNSZone in $ConfigProfile.ddns_zones) {
                        $splat = @{
                            "zone" = $DDNSZone.zone
                        }
                        $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                        $ConfigProfileJson += $splat
                    }
                    if ($ConfigProfile.inheritance_sources.ddns_block.action -ne "override") {
                        Write-Host "Overriding Global DHCP Properties for DHCP Config Profile: $Name.." -ForegroundColor Green
                    }
                    $ConfigProfileSplat = @{
                        "ddns_zones" = $ConfigProfileJson
	                    "ddns_enabled" = $true
	                    "ddns_send_updates" = $true
                        "inheritance_sources" = @{
                            "ddns_block" = @{
                                "action" = "override"
                            }
                        }
                    } | ConvertTo-Json

                    $Result = Query-CSP -Method "PATCH" -Uri "$($ConfigProfile.id)" -Data $ConfigProfileSplat | Select-Object -ExpandProperty result
            
                    if ($Result) {
                        if ($ToUpdate.count -gt 0) {
                            foreach ($DDNSToUpdate in $ToUpdate) {
                                if (("$DDNSToUpdate.") -in $Result.ddns_zones.fqdn) {
                                    Write-Host "$DDNSToUpdate added successfully to DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Green
                                } else {
                                    Write-Host "Failed to add $DDNSToUpdate to DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Red
                                }
                            }
                        } else {
                            Write-Host "Nothing to update." -ForegroundColor Yellow
                        }
                    } else {
                        Write-Host "Error. Failed to update Global DHCP Configuration." -ForegroundColor Red
                    }
                } elseif ($RemoveDDNSZones) {
                    $ConfigProfileJson = @()
                    foreach ($ConfigProfileDDNSZone in $ConfigProfile.ddns_zones) {
                        if (($ConfigProfileDDNSZone.fqdn.TrimEnd(".")) -notin $DDNSZones) {
                            $splat = @{
                                "zone" = $ConfigProfileDDNSZone.zone
                            }
                            $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                            $ConfigProfileJson += $splat
                        } else {
                            $ToUpdate += $ConfigProfileDDNSZone.fqdn
                        }
                    }
                    $ConfigProfileSplat = @{
                        "ddns_zones" = $ConfigProfileJson
                    } | ConvertTo-Json

                    $Result = Query-CSP -Method "PATCH" -Uri "$($ConfigProfile.id)" -Data $ConfigProfileSplat | Select-Object -ExpandProperty result

                    if ($Result) {
                        if ($ToUpdate.count -gt 0) {
                            foreach ($DDNSToUpdate in $ToUpdate) {
                                if (("$DDNSToUpdate.") -notin $Result.ddns_zones.fqdn) {
                                    Write-Host "$DDNSToUpdate removed successfully from DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Green
                                } else {
                                    Write-Host "Failed to remove $DDNSToUpdate from DDNS Config for the DHCP Config Profile: $Name." -ForegroundColor Red
                                }
                            }
                        } else {
                            Write-Host "Nothing to update." -ForegroundColor Yellow
                        }
                    } else {
                        Write-Host "Error. Failed to update Global DHCP Configuration." -ForegroundColor Red
                    }

                }
            }
      }
    }
}