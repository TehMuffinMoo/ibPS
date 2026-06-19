BeforeAll {
    $Name = "ibPS-PesterTests"
    $Description = "Used for ibPS Pester Tests - https://ibPS.readthedocs.io"
    $Tags = @{
        "Source" = "ibPS-Pester"
    }
}

Describe 'New-*' {
    Context 'Universal DDI DNS' {
        It 'Create DNS View' {
            (New-B1DNSView -Name $Name -Description $Description -Tags $Tags 6>$null).Name | Should -Be $Name
        }
        It 'Create Authoritative Primary DNS Zone' {
            (New-B1AuthoritativeZone -Type Primary -FQDN 'primary.ibps.pester.tests' -View $Name `
            -Description $Description -Tags $Tags).fqdn | Should -Be 'primary.ibps.pester.tests.'
        }
        It 'Create Authoritative Secondary DNS Zone' {
            (New-B1AuthoritativeZone -Type Secondary -FQDN 'secondary.ibps.pester.tests' -View $Name `
            -Description $Description -Tags $Tags).fqdn | Should -Be 'secondary.ibps.pester.tests.'
        }
        It 'Create Forward DNS Zone' {
            (New-B1ForwardZone -FQDN 'forward.ibps.pester.tests' -Description $Description `
            -View $Name -Forwarders '123.123.123.100','123.123.123.200' -Tags $Tags).fqdn `
            | Should -Be 'forward.ibps.pester.tests.'
        }
        It 'Create New DNS A Record' {
            (New-B1Record -Type 'A' -Name 'A' -Zone 'primary.ibps.pester.tests' -rdata '123.123.123.25' `
            -view $Name -Description $Description -Tags $Tags).absolute_name_spec `
            | Should -Be 'A.primary.ibps.pester.tests.'
        }
        It 'Create New DNS CNAME Record' {
            (New-B1Record -Type 'CNAME' -Name 'CNAME' -Zone 'primary.ibps.pester.tests' -rdata 'A.primary.ibps.pester.tests' `
            -view $Name -Description $Description -Tags $Tags).absolute_name_spec `
            | Should -Be 'CNAME.primary.ibps.pester.tests.'
        }
        It 'Create New DNS SRV Record' {
            (New-B1Record -Type 'SRV' -Name 'SRV' -Zone 'primary.ibps.pester.tests' -view $Name -Tags $Tags `
            -Priority 0 -Weight 0 -Port 123 -rdata 'target.srv.com').absolute_name_spec `
            | Should -Be 'SRV.primary.ibps.pester.tests.'
        }
    }
    Context 'Universal DDI IPAM/DHCP' {
        It 'Create IP Space' {
            (New-B1Space -Name $Name -Description $Description -Tags $Tags 6>$null).Name | Should -Be $Name
        }
        It 'Create Address Block' {
            (New-B1AddressBlock -Name $Name -Description $Description -Tags $Tags `
            -Subnet 123.123.123.0 -CIDR 24 -Space $Name `
            -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "domain-name-servers").id;"option_value"="123.123.123.10,132.132.132.10";}) 6>$null).Name | Should -Be $Name
        }
        It 'Create Subnet' {
            (New-B1Subnet -Name $Name -Description $Description -Tags $Tags `
            -Subnet 123.123.123.0 -CIDR 26 -Space $Name `
            -DHCPOptions @(@{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="123.123.123.1";}) 6>$null).Name | Should -Be $Name
        }
        It 'Create DHCP Range' {
            (New-B1Range -Name $Name -Description $Description -Tags $Tags `
            -StartAddress 123.123.123.10 -EndAddress 123.123.123.30 `
            -Space $Name 6>$null).Name | Should -Be $Name
        }
        It 'Create Address Reservation' {
            (New-B1AddressReservation -Name $Name -Description $Description `
            -Address 123.123.123.5 -Space $Name -Tags $Tags 6>$null).Address | Should -Be 123.123.123.5
        }
        It 'Create Fixed Address' {
            (New-B1FixedAddress -Name $Name -Description $Description `
            -IP 123.123.123.6 -Space $Name -MatchType mac `
            -MatchValue "ab:cd:ef:12:34:56" -Tags $Tags 6>$null).Address | Should -Be 123.123.123.6
        }
        It 'Create New DHCP Config Profile' {
            (New-B1DHCPConfigProfile -Name $Name -Description $Description -Tags $Tags).Name | Should -Be $Name
        }
    }
    Context 'Universal DDI NIOS-X' {
        It 'Create NIOS-X Host' {
            (New-B1Host -Name $Name -Space $Name -Description $Description).display_name | Should -Be $Name
        }
    }
    Context 'DTC Lifecycle' {
        It 'Create DTC Health Check' {
            (New-B1DTCHealthCheck -Name $Name -Type ICMP -Tags $Tags 6>$null).name | Should -Be $Name
        }
        It 'Create DTC Server' {
            (New-B1DTCServer -Name $Name -IP '123.123.123.50' -SynthesizedA 123.123.125.50 -AutoCreateResponses Enabled -Tags $Tags 6>$null).name | Should -Be $Name
        }
        It 'Create DTC Pool' {
            (New-B1DTCPool -Name $Name -Servers $Name -LoadBalancingType GlobalAvailability -HealthChecks $Name -Tags $Tags 6>$null).name | Should -Be $Name
        }
        # It 'Create DTC Policy' {
        #     $TopologyRules = @()
        #     $TopologyRules += New-B1DTCTopologyRule -Name 'Rule 1' -Type 'Subnet' -Destination NXDOMAIN -Subnets '10.10.10.0/24','10.20.0.0/24'
        #     $TopologyRules += New-B1DTCTopologyRule -Name 'Rule 2' -Type 'Default' -Destination Pool -Pool $Name -Subnets '10.25.0.0/16','10.30.0.0/16'
        #     (New-B1DTCPolicy -Name $Name -Pools $Name -Rules $TopologyRules -LoadBalancingType Topology -Tags $Tags 6>$null).name | Should -Be $Name
        # }
        It 'Create DTC LBDN' {
            (New-B1DTCLBDN -Name "dtc.primary.ibps.pester.tests." -View $Name -Policy $Name -Tags $Tags 6>$null).name | Should -Be "dtc.primary.ibps.pester.tests."
        }
    }
    Context 'Threat Defense General' {
        It 'Create New Lookalike Target' {
            (New-B1LookalikeTarget -Domain 'pester.test' -Description $Description).item | Should -Be 'pester.test'
        }
    }
}

Describe 'Get-*' {
    Context 'Platform & Account' {
        It 'Get CSP Current User' {
            Get-B1CSPCurrentUser | Should -Not -BeNullOrEmpty
        }
        # It 'Get Account Session' {
        #     Get-B1AccountSession | Should -Not -BeNullOrEmpty
        # }
        It 'Get Licenses' {
            Get-B1Licenses | Should -Not -BeNullOrEmpty
        }
        It 'Get Compartment' {
            Get-B1Compartment | Should -Not -BeNullOrEmpty
        }
        # It 'Get Cloud Provider' {
        #     Get-B1CloudProvider | Should -Not -BeNullOrEmpty
        # }
        It 'Get PoP Regions' {
            Get-B1PoPRegion | Should -Not -BeNullOrEmpty
        }
        It 'Get Tags' {
            Get-B1Tag | Should -Not -BeNullOrEmpty
        }
        It 'Get User' {
            Get-B1User | Should -Not -BeNullOrEmpty
        }
        It 'Get Tokens' {
            Get-B1Tokens -Bucket Management | Should -Not -BeNullOrEmpty
        }
        It 'Get Bootstrap Config' {
            Get-B1BootstrapConfig | Should -Not -BeNullOrEmpty
        }
        # It 'Get Health Check' {
        #     Get-B1HealthCheck | Should -Not -BeNullOrEmpty
        # }
    }
    Context 'Logging & Audit' {
        # It 'Get Audit Log' {
        #     Get-B1AuditLog -Limit 10 | Should -Not -BeNullOrEmpty
        # }
        # It 'Get DNS Log' {
        #     Get-B1DNSLog -Limit 10 | Should -Not -BeNullOrEmpty
        # }
        # It 'Get DHCP Log' {
        #     Get-B1DHCPLog -Limit 10 | Should -Not -BeNullOrEmpty
        # }
        # It 'Get DFP Log' {
        #     Get-B1DFPLog -Limit 10 | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Security Log' {
        #     Get-B1SecurityLog -Limit 10 | Should -Not -BeNullOrEmpty
        # }
        # It 'Get DNS Events' {
        #     Get-B1DNSEvent -Limit 10 | Should -Not -BeNullOrEmpty
        # }
    }
    Context 'Universal DDI NIOS-X' {
        It 'Get NIOS-X Host' {
            (Get-B1Host -Name $Name).display_name | Should -Be $Name
        }
        It 'Get Services' {
            Get-B1Service | Should -Not -BeNullOrEmpty
        }
    }
    Context 'Universal DDI DNS' {
        It 'Get DNS View' {
            (Get-B1DNSView -Name $Name).Name | Should -Be $Name
        }
        It 'Get Authoritative Primary DNS Zone' {
            (Get-B1AuthoritativeZone -FQDN 'primary.ibps.pester.tests' -View $Name).fqdn | Should -Be 'primary.ibps.pester.tests.'
        }
        It 'Get Authoritative Secondary DNS Zone' {
            (Get-B1AuthoritativeZone -FQDN 'secondary.ibps.pester.tests' -View $Name).fqdn | Should -Be 'secondary.ibps.pester.tests.'
        }
        It 'Get Forward DNS Zone' {
            (Get-B1ForwardZone -FQDN 'forward.ibps.pester.tests' -View $Name).fqdn | Should -Be 'forward.ibps.pester.tests.'
        }
        # It 'Get Authoritative NSG' { ## Won't exist by default
        #     Get-B1AuthoritativeNSG | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Forward NSG' { ## Won't exist by default
        #     Get-B1ForwardNSG | Should -Not -BeNullOrEmpty
        # }
        It 'Get DNS A Record' {
            (Get-B1Record -Type A -FQDN 'A.primary.ibps.pester.tests' -View $Name).absolute_name_spec | Should -Be 'A.primary.ibps.pester.tests.'
        }
        It 'Get DNS CNAME Record' {
            (Get-B1Record -Type CNAME -FQDN 'CNAME.primary.ibps.pester.tests' -View $Name).absolute_name_spec | Should -Be 'CNAME.primary.ibps.pester.tests.'
        }
        It 'Get DNS SRV Record' {
            (Get-B1Record -Type SRV -FQDN 'SRV.primary.ibps.pester.tests' -View $Name).absolute_name_spec | Should -Be 'SRV.primary.ibps.pester.tests.'
        }
        # It 'Get DNS Config Profiles' { ## Won't exist by default
        #     Get-B1DNSConfigProfile | Should -Not -BeNullOrEmpty
        # }
    }
    Context 'Universal DDI IPAM/DHCP' {
        It 'Get DNS Hosts' {
            Get-B1DNSHost | Should -Not -BeNullOrEmpty
        }
        # It 'Get DNS Usage' { ## Won't exist by default
        #     Get-B1DNSUsage | Should -Not -BeNullOrEmpty
        # }
        It 'Get IP Space' {
            (Get-B1Space -Name $Name).Name | Should -Be $Name
        }
        It 'Get Address Block' {
            (Get-B1AddressBlock -Subnet 123.123.123.0 -CIDR 24 -Space $Name).Address | Should -Be 123.123.123.0
        }
        It 'Get Subnet' {
            (Get-B1Subnet -Subnet 123.123.123.0 -CIDR 26 -Space $Name).Address | Should -Be 123.123.123.0
        }
        It 'Get DHCP Range' {
            (Get-B1Range -StartAddress 123.123.123.10 -EndAddress 123.123.123.30 -Space $Name).start | Should -Be 123.123.123.10
        }
        It 'Get Address Reservation' {
            (Get-B1Address -Address 123.123.123.5 -Reserved).Address | Should -Be 123.123.123.5
        }
        It 'Get Fixed Address' {
            (Get-B1FixedAddress -IP 123.123.123.6 -Space $Name).Address | Should -Be 123.123.123.6
        }
        It 'Get DHCP Config Profile' {
            (Get-B1DHCPConfigProfile -Name $Name).Name | Should -Be $Name
        }
        It 'Get DHCP Hosts' {
            Get-B1DHCPHost | Should -Not -BeNullOrEmpty
        }
        # It 'Get DHCP Leases' { ## Won't exist by default
        #     Get-B1DHCPLease | Should -Not -BeNullOrEmpty
        # }
        It 'Get DHCP Option Spaces' {
            Get-B1DHCPOptionSpace | Should -Not -BeNullOrEmpty
        }
        # It 'Get DHCP Option Groups' { ## Won't exist by default
        #     Get-B1DHCPOptionGroup | Should -Not -BeNullOrEmpty
        # }
        It 'Get DHCP Global Config' {
            Get-B1DHCPGlobalConfig | Should -Not -BeNullOrEmpty
        }
    }
    Context 'Universal DDI NTP' {
        It 'Get Global NTP Config' {
            Get-B1GlobalNTPConfig | Should -Not -BeNullOrEmpty
        }
        # It 'Get NTP Service Configuration' {
        #     Get-B1NTPServiceConfiguration | Should -Not -BeNullOrEmpty
        # }
    }
    Context 'Get-B1Address' {
        BeforeAll {
            $Addresses = Get-B1Address
        }
        It 'Given no parameters, 1-1000 results should be returned' {
            $Addresses.Count | Should -BeIn (1..1000)
        }
        It "Given the -Address parameter, check an object is returned" {
            (Get-B1Address -Address 123.123.123.6)[0].address | Should -Be 123.123.123.6
        }
        It "Given the -Limit & -Offset parameters, Test Limit: <limit> / Offset: <offset> - Expected: <expected>" -ForEach @(
            @{ Limit = "10"; Offset = "0"; Expected = '10'}
            @{ Limit = "10"; Offset = "10"; Expected = '10'}
        ) {
            (Get-B1Address -Limit $Limit -Offset $Offset).Count | Should -Be $expected
        }
    }
    Context 'DTC Lifecycle' {
        It 'Get DTC Health Check' {
            (Get-B1DTCHealthCheck -Name $Name).name | Should -Be $Name
        }
        It 'Get DTC Server' {
            (Get-B1DTCServer -Name $Name).name | Should -Be $Name
        }
        It 'Get DTC Pool' {
            (Get-B1DTCPool -Name $Name).name | Should -Be $Name
        }
        # It 'Get DTC Policy' {
        #     (Get-B1DTCPolicy -Name $Name).name | Should -Be $Name
        # }
        It 'Get DTC LBDN' {
            (Get-B1DTCLBDN -Name "dtc.primary.ibps.pester.tests.").name | Should -Be "dtc.primary.ibps.pester.tests."
        }
        It 'Get DTC Status' {
            Get-B1DTCStatus -LBDN "dtc.primary.ibps.pester.tests." -Raw | Should -Not -BeNullOrEmpty
        }
    }
    Context 'Threat Defense General' {
        # It 'Get Lookalike Target' {
        #     ### TO COMPLETE
        # }
        # It 'Get RPZ Feeds' {
        #     Get-B1RPZFeed | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Threat Feeds' {
        #     Get-B1ThreatFeeds | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Threat Intel' {
        #     Get-B1ThreatIntel | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Network Lists' {
        #     Get-B1NetworkList | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Bypass Codes' {
        #     Get-B1BypassCode | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Third Party Providers' {
        #     Get-B1ThirdPartyProvider | Should -Not -BeNullOrEmpty
        # }
        # It 'Get Endpoints' {
        #     Get-B1Endpoint | Should -Not -BeNullOrEmpty
        # }
        It 'Get Endpoint Groups' {
            Get-B1EndpointGroup | Should -Not -BeNullOrEmpty
        }
        It 'Get DFP' {
            Get-B1DFP | Should -Not -BeNullOrEmpty
        }
        It 'Get DFP Applications' {
            Get-B1Applications | Should -Not -BeNullOrEmpty
        }
        It 'Get Application Filters' {
            Get-B1ApplicationFilter | Should -Not -BeNullOrEmpty
        }
        It 'Get Content Categories' {
            Get-B1ContentCategory | Should -Not -BeNullOrEmpty
        }
        # It 'Get Category Filters' {
        #     Get-B1CategoryFilter | Should -Not -BeNullOrEmpty
        # }
    }
    Context 'Threat Defense TIDE' {
        It 'Get TIDE Threat Classes' {
            Get-B1TideThreatClass | Should -Not -BeNullOrEmpty
        }
        It 'Get TIDE Threat Properties' {
            Get-B1TideThreatProperty | Should -Not -BeNullOrEmpty
        }
        # It 'Get TIDE Feeds' {
        #     Get-B1TideFeeds | Should -Not -BeNullOrEmpty
        # }
        It 'Get TIDE Threat Counts' {
            Get-B1TideThreatCounts | Should -Not -BeNullOrEmpty
        }
        # It 'Get TIDE Data Profile' {
        #     Get-B1TideDataProfile | Should -Not -BeNullOrEmpty
        # }
        It 'Get TIDE InfoRank' {
            Get-B1TideInfoRank -Domain 'google.com' | Should -Not -BeNullOrEmpty
        }
    }
    Context 'Threat Defense SOC Insights' {
        # It 'Get SOC Insights' {
        #     $Insights = Get-B1SOCInsight
        #     $Insights | Should -Not -BeNullOrEmpty
        # }
        # It 'Get SOC Insight Events (first insight)' {
        #     $Insight = Get-B1SOCInsight
        #     if ($Insight) {
        #         Get-B1SOCInsightEvents -InsightID $Insight.id | Should -Not -BeNullOrEmpty
        #     }
        # }
    }
    Context 'Threat Defense Dossier' {
        It 'Get Dossier Supported Sources' {
            Get-B1DossierSupportedSources | Should -Not -BeNullOrEmpty
        }
        It 'Get Dossier Supported Targets' {
            Get-B1DossierSupportedTargets | Should -Not -BeNullOrEmpty
        }
        It 'Start and Get Dossier Lookup' {
            $Lookup = Start-B1DossierLookup -Type ip -Value '1.1.1.1'
            $Lookup | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Set-*' {
    Context 'Universal DDI DNS' {
        It 'Update Authoritative Primary DNS Zone' {
            Get-B1AuthoritativeZone -FQDN 'primary.ibps.pester.tests.' -View $Name | Set-B1AuthoritativeZone -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        It 'Update Authoritative Secondary DNS Zone' {
            Get-B1AuthoritativeZone -FQDN 'secondary.ibps.pester.tests.' -View $Name | Set-B1AuthoritativeZone -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        It 'Update Forward DNS Zone' {
            Get-B1ForwardZone -FQDN 'forward.ibps.pester.tests.' -View $Name | Set-B1ForwardZone -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        It 'Update DNS A Record' {
            Get-B1Record -Type 'A' -FQDN 'A.primary.ibps.pester.tests' -View $Name | Set-B1Record -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        It 'Update DNS CNAME Record' {
            Get-B1Record -Type 'CNAME' -FQDN 'CNAME.primary.ibps.pester.tests' -View $Name | Set-B1Record -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        It 'Update DNS SRV Record' {
            Get-B1Record -Type 'SRV' -FQDN 'SRV.primary.ibps.pester.tests' -View $Name | Set-B1Record -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        # It 'Update DNS View' {
        #     Get-B1DNSView -Name $Name | Set-B1DNSView -Description "ibPS - Updated Description" 6>$null
        # }
    }
    Context 'Universal DDI NIOS-X' {
        It 'Update NIOS-X Host' {
            Get-B1Host -Name $Name | Set-B1Host -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
    }    
    Context 'Universal DDI IPAM/DHCP' {
        It 'Update Fixed Address' {
            $AddressBlock = Get-B1FixedAddress -IP 123.123.123.6 -Space $Name | Set-B1FixedAddress -Description "ibPS - Updated Description"
        }
        # It 'Update Address Reservation' {
        #     Get-B1AddressReservation -Address 123.123.123.5 -Space $Name | Set-B1AddressReservation -Description "ibPS - Updated Description" 6>$null
        # }
        It 'Update DHCP Range' {
            Get-B1Range -StartAddress 123.123.123.10 -EndAddress 123.123.123.30 -Space $Name | Set-B1Range -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        It 'Update Subnet' {
            Get-B1Subnet -Subnet 123.123.123.0 -CIDR 26 -Space $Name | Set-B1Subnet -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        It 'Update Address Block' {
            Get-B1AddressBlock -Subnet 123.123.123.0 -CIDR 24 -Space $Name | Set-B1AddressBlock -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
        # It 'Update IP Space' {
        #     Get-B1Space -Name $Name | Set-B1Space -Description "ibPS - Updated Description" 6>$null
        # }
        It 'Update DHCP Config Profile' {
            Get-B1DHCPConfigProfile -Name $Name | Set-B1DHCPConfigProfile -Description "ibPS - Updated Description" | Should -Not -Be $null
        }
    }
    Context 'DTC Lifecycle' {
        It 'Update DTC Health Check' {
            Get-B1DTCHealthCheck -Name $Name -Type icmp | Set-B1DTCHealthCheck -Description "ibPS - Updated" | Should -Not -Be $null
        }
        It 'Update DTC Server' {
            Get-B1DTCServer -Name $Name | Set-B1DTCServer -Description "ibPS - Updated" | Should -Not -Be $null
        }
        It 'Update DTC Pool' {
            Get-B1DTCPool -Name $Name | Set-B1DTCPool -Description "ibPS - Updated" | Should -Not -Be $null
        }
        # It 'Update DTC Policy' {
        #     Get-B1DTCPolicy -Name $Name | Set-B1DTCPolicy -Description "ibPS - Updated" | Should -Not -Be $null
        # }
        It 'Update DTC LBDN' {
            Get-B1DTCLBDN -Name "dtc.primary.ibps.pester.tests." | Set-B1DTCLBDN -Description "ibPS - Updated" | Should -Not -Be $null
        }
    }
}

Describe 'Remove-*' {
    Context 'DTC Lifecycle' {
        It 'Remove DTC LBDN' {
            { Remove-B1DTCLBDN -Name "dtc.primary.ibps.pester.tests." -Force 6>$null } | Should -Not -Throw
            Get-B1DTCLBDN -Name "dtc.primary.ibps.pester.tests." | Should -BeNullOrEmpty
        }
        It 'Remove DTC Pool' {
            { Remove-B1DTCPool -Name $Name -Force 6>$null } | Should -Not -Throw
        }
        It 'Remove DTC Server' {
            { Remove-B1DTCServer -Name $Name -Force 6>$null } | Should -Not -Throw
        }
        It 'Remove DTC Health Check' {
            { Remove-B1DTCHealthCheck -Name $Name -Force 6>$null } | Should -Not -Throw
        }
        # It 'Remove DTC Policy' {
        #     { Remove-B1DTCPolicy -Name $Name -Force 6>$null } | Should -Not -Throw
        # }
    }
    Context 'Universal DDI NIOS-X' {
        It 'Remove NIOS-X Host' {
            Remove-B1Host -Name $Name -Force 6>$null
        }
    }
    Context 'Universal DDI DNS' {
        It 'Remove Authoritative Primary DNS Zone' {
            Remove-B1AuthoritativeZone -FQDN 'primary.ibps.pester.tests.' -View $Name -Force 6>$null
        }
        It 'Remove Authoritative Secondary DNS Zone' {
            Remove-B1AuthoritativeZone -FQDN 'secondary.ibps.pester.tests.' -View $Name -Force 6>$null
        }
        It 'Remove Forward DNS Zone' {
            Remove-B1ForwardZone -FQDN 'forward.ibps.pester.tests.' -View $Name -Force 6>$null
        }
        It 'Remove DNS A Record' {
            Get-B1Record -Type 'A' -FQDN 'A.primary.ibps.pester.tests' -View $Name | Remove-B1Record -Force 6>$null
        }
        It 'Remove DNS CNAME Record' {
            Get-B1Record -Type 'CNAME' -FQDN 'CNAME.primary.ibps.pester.tests' -View $Name | Remove-B1Record -Force 6>$null
        }
        It 'Remove DNS SRV Record' {
            Get-B1Record -Type 'SRV' -FQDN 'SRV.primary.ibps.pester.tests' -View $Name | Remove-B1Record -Force 6>$null
        }
        It 'Remove DNS View' {
            Remove-B1DNSView -Name $Name -Force 6>$null
        }
    }
    Context 'Universal DDI IPAM/DHCP' {
        It 'Remove Fixed Address' {
            Remove-B1FixedAddress -IP 123.123.123.6 -Space $Name -Force 6>$null
        }
        It 'Remove Address Reservation' {
            Remove-B1AddressReservation -Address 123.123.123.5 -Space $Name -Force 6>$null
        }
        It 'Remove DHCP Range' {
            Remove-B1Range -StartAddress 123.123.123.10 -EndAddress 123.123.123.30 -Space $Name -Force 6>$null
        }
        It 'Remove Subnet' {
            Remove-B1Subnet -Subnet 123.123.123.0 -CIDR 26 -Space $Name -Force 6>$null
        }
        It 'Remove Address Block' {
            Remove-B1AddressBlock -Subnet 123.123.123.0 -CIDR 24 -Space $Name -Force 6>$null
        }
        It 'Remove IP Space' {
            Remove-B1Space -Name $Name -Force 6>$null
        }
        It 'Remove DHCP Config Profile' {
            Remove-B1DHCPConfigProfile -Name $Name -Force 6>$null
        }
    }
    Context 'Threat Defense General' {
        It 'Remove Lookalike Target' {
            Remove-B1LookalikeTarget -Domain 'pester.test' -Force 6>$null
        }
    }
}