function Set-B1DHCPGlobalConfig {
    <#
    .SYNOPSIS
        Updates the BloxOneDDI Global DHCP Configuration

    .DESCRIPTION
        This function is used to update the BloxOneDDI Global DHCP Configuration

    .PARAMETER DDNSZones
        Provide a list of DDNS Zones to add or remove to/from the Global DHCP Configuration.

        This is to be used in conjunction with -AddDDNSZones and -RemoveDDNSZones respectively.

    .PARAMETER AddDDNSZones
        Using this switch indicates the zones specified in -DDNSZones are to be added to the Global DHCP Configuration

    .PARAMETER RemoveDDNSZones
        Using this switch indicates the zones specified in -DDNSZones are to be removed from the Global DHCP Configuration

    .PARAMETER DNSView
        The DNS View for applying the configuration to

    .EXAMPLE
        PS> Set-B1DHCPGlobalConfig -AddDDNSZones -DDNSZones "mysubzone.corp.mycompany.com" -DNSView "default"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DHCP
    #>
    param(
      [Switch]$AddDDNSZones,
      [Switch]$RemoveDDNSZones,
      [System.Object]$DDNSZones,
      [Parameter(Mandatory=$true)]
      [String]$DNSView
    )

    if ($AddDDNSZones -or $RemoveDDNSZones) {
        if ($AddDDNSZones -and $RemoveDDNSZones) {
            Write-Host "Error. You can only specify Add or Remove for DDNS Zones." -ForegroundColor Red
            break
        } else {
            $ToUpdate = @()
            if ($AddDDNSZones) {
                $GlobalConfig = Get-B1DHCPGlobalConfig
                $GlobalConfigJson = @()
                foreach ($DDNSZone in $DDNSZones) {
                    $DDNSZone = $DDNSZone.TrimEnd(".")
                    if (("$DDNSZone.") -in $GlobalConfig.ddns_zones.fqdn) {
                        Write-Host "$DDNSZone already exists. Skipping.." -ForegroundColor Yellow
                    } else {
                        $AuthZone = Get-B1AuthoritativeZone -FQDN $DDNSZone -View $DNSView -Strict
                        if ($AuthZone) {
                            $splat = @{
                                "zone" = $AuthZone.id
                            }
                            $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                            $GlobalConfigJson += $splat
                        } else {
                            Write-Host "Error: Authoritative Zone not found." -ForegroundColor Red
                        }
                        $ToUpdate += $DDNSZone
                    }
                }
                foreach ($DDNSZone in $GlobalConfig.ddns_zones) {
                    $splat = @{
                        "zone" = $DDNSZone.zone
                    }
                    $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                    $GlobalConfigJson += $splat
                }
                $GlobalConfigSplat = @{
                    "ddns_zones" = $GlobalConfigJson
                } | ConvertTo-Json

                $Result = Invoke-CSP -Method "PATCH" -Uri "$($GlobalConfig.id)" -Data $GlobalConfigSplat | Select-Object -ExpandProperty result

                if ($Result) {
                    if ($ToUpdate.count -gt 0) {
                        foreach ($DDNSToUpdate in $ToUpdate) {
                            if (("$DDNSToUpdate.") -in $Result.ddns_zones.fqdn) {
                                Write-Host "$DDNSToUpdate added successfully to DDNS Global Config." -ForegroundColor Green
                            } else {
                                Write-Host "Failed to add $DDNSToUpdate to DDNS Global Config." -ForegroundColor Red
                            }
                        }
                    } else {
                        Write-Host "Nothing to update." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "Error. Failed to update Global DHCP Configuration." -ForegroundColor Red
                }
            } elseif ($RemoveDDNSZones) {
                $GlobalConfig = Get-B1DHCPGlobalConfig
                $GlobalConfigJson = @()
                foreach ($GlobalDDNSZone in $GlobalConfig.ddns_zones) {
                    if (($GlobalDDNSZone.fqdn.TrimEnd(".")) -notin $DDNSZones) {
                        $splat = @{
                            "zone" = $GlobalDDNSZone.zone
                        }
                        $splat = $splat | ConvertTo-Json | ConvertFrom-Json
                        $GlobalConfigJson += $splat
                    } else {
                        $ToUpdate += $GlobalDDNSZone.fqdn
                    }
                }
                $GlobalConfigSplat = @{
                    "ddns_zones" = $GlobalConfigJson
                } | ConvertTo-Json

                $Result = Invoke-CSP -Method "PATCH" -Uri "$($GlobalConfig.id)" -Data $GlobalConfigSplat | Select-Object -ExpandProperty result

                if ($Result) {
                    if ($ToUpdate.count -gt 0) {
                        foreach ($DDNSToUpdate in $ToUpdate) {
                            if (("$DDNSToUpdate.") -notin $Result.ddns_zones.fqdn) {
                                Write-Host "$DDNSToUpdate removed successfully from DDNS Global Config." -ForegroundColor Green
                            } else {
                                Write-Host "Failed to remove $DDNSToUpdate from DDNS Global Config." -ForegroundColor Red
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