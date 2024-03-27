BeforeAll {
    $Name = "ibPS-PesterTests"
    $Description = "Used for ibPS Pester Tests - https://ibPS.readthedocs.io"
    $Tags = @{
        "Source" = "ibPS-Pester"
    }
}

Describe 'New-*' {
    Context 'B1DDI-General' {
        It 'Create IP Space' {
            (New-B1Space -Name $Name -Description $Description -Tags $Tags 6>$null).Name | Should -Be $Name
        }
        It 'Create DNS View' {
            (New-B1DNSView -Name $Name -Description $Description -Tags $Tags 6>$null).Name | Should -Be $Name
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
        It 'Create New DHCP Config Profile' {
            (New-B1DHCPConfigProfile -Name $Name -Description $Description -Tags $Tags).Name | Should -Be $Name
        }
        It 'Create BloxOne Host' {
            (New-B1Host -Name $Name -Space $Name -Description $Description).display_name | Should -Be $Name
        }
    }
    Context 'B1TD-General' {
        It 'Create New Lookalike Target' {
            (New-B1LookalikeTarget -Domain 'pester.test' -Description $Description).item | Should -Be 'pester.test'
        }
    }
}

Describe 'Get-*' {
    Context 'B1DDI-General' {
        It 'Get IP Space' {
            (Get-B1Space -Name $Name).Name | Should -Be $Name
        }
        It 'Get DNS View' {
            (Get-B1DNSView -Name $Name).Name | Should -Be $Name
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
        It 'Get Authoritative Primary DNS Zone' {
            (Get-B1AuthoritativeZone -FQDN 'primary.ibps.pester.tests' -View $Name).fqdn | Should -Be 'primary.ibps.pester.tests.'
        }
        It 'Get Authoritative Secondary DNS Zone' {
            (Get-B1AuthoritativeZone -FQDN 'secondary.ibps.pester.tests' -View $Name).fqdn | Should -Be 'secondary.ibps.pester.tests.'
        }
        It 'Get Forward DNS Zone' {
            (Get-B1ForwardZone -FQDN 'forward.ibps.pester.tests' -View $Name).fqdn | Should -Be 'forward.ibps.pester.tests.'
        }
        It 'Get DNS A Record' {
            (Get-B1Record -Type A -FQDN 'A.primary.ibps.pester.tests' -View $Name).absolute_name_spec | Should -Be 'A.primary.ibps.pester.tests.'          
        }
        It 'Get DNS CNAME Record' {
            (Get-B1Record -Type CNAME -FQDN 'CNAME.primary.ibps.pester.tests' -View $Name).absolute_name_spec | Should -Be 'CNAME.primary.ibps.pester.tests.'          
        }
        It 'Get DNS SRV Record' {
            (Get-B1Record -Type SRV -FQDN 'SRV.primary.ibps.pester.tests' -View $Name).absolute_name_spec | Should -Be 'SRV.primary.ibps.pester.tests.'          
        }
        It 'Get DHCP Config Profile' {
            (Get-B1DHCPConfigProfile -Name $Name).Name | Should -Be $Name
        }
        It 'Get BloxOne Host' {
            (Get-B1Host -Name $Name).display_name | Should -Be $Name
        }
    }
    Context 'Get-B1Address' {
        BeforeAll {
            $Addresses = Get-B1Address
        }
        It 'Given no parameters, 1000 results should be returned' {
            $Addresses.Count | Should -Be 1000
        }
        It "Given the -Address parameter, check an object is returned" {
            (Get-B1Address -Address 10.1.1.1)[0].address | Should -Be 10.1.1.1
        }
        It "Given the -Limit & -Offset parameters, Test Limit: <limit> / Offset: <offset> - Expected: <expected>" -ForEach @(
            @{ Limit = "10"; Offset = "0"; Expected = '10'}
            @{ Limit = "10"; Offset = "10"; Expected = '10'}
        ) {
            (Get-B1Address -Limit $Limit -Offset $Offset).Count | Should -Be $expected
        }
    }
    Context 'B1TD-General' {
        It 'Get Lookalike Target' {
            ### TO COMPLETE
        }
    }
}

Describe 'Remove-*' {
    Context 'B1DDI-General' {
        It 'Remove Fixed Address' {
            Remove-B1FixedAddress -IP 123.123.123.6 -Space $Name 6>$null
        }
        It 'Remove Address Reservation' {
            Remove-B1AddressReservation -Address 123.123.123.5 -Space $Name 6>$null
        }
        It 'Remove DHCP Range' {
            Remove-B1Range -StartAddress 123.123.123.10 -EndAddress 123.123.123.30 -Space $Name 6>$null
        }
        It 'Remove Subnet' {
            Remove-B1Subnet -Subnet 123.123.123.0 -CIDR 26 -Space $Name 6>$null
        }
        It 'Remove Address Block' {
            Remove-B1AddressBlock -Subnet 123.123.123.0 -CIDR 24 -Space $Name 6>$null
        }
        It 'Remove IP Space' {
            Remove-B1Space -Name $Name 6>$null
        }
        It 'Remove Authoritative Primary DNS Zone' {
            Remove-B1AuthoritativeZone -FQDN 'primary.ibps.pester.tests.' -View $Name 6>$null
        }
        It 'Remove Authoritative Secondary DNS Zone' {
            Remove-B1AuthoritativeZone -FQDN 'secondary.ibps.pester.tests.' -View $Name 6>$null
        }
        It 'Remove Forward DNS Zone' {
            Remove-B1ForwardZone -FQDN 'forward.ibps.pester.tests.' -View $Name 6>$null
        }
        It 'Remove DNS A Record' {
            Get-B1Record -Type 'A' -FQDN 'A.primary.ibps.pester.tests' -View $Name | Remove-B1Record 6>$null
        }
        It 'Remove DNS CNAME Record' {
            Get-B1Record -Type 'CNAME' -FQDN 'CNAME.primary.ibps.pester.tests' -View $Name | Remove-B1Record 6>$null
        }
        It 'Remove DNS SRV Record' {
            Get-B1Record -Type 'SRV' -FQDN 'SRV.primary.ibps.pester.tests' -View $Name | Remove-B1Record 6>$null
        }
        It 'Remove DNS View' {
            Remove-B1DNSView -Name $Name 6>$null
        }
        It 'Remove DHCP Config Profile' {
            Remove-B1DHCPConfigProfile -Name $Name 6>$null
        }
        It 'Remove BloxOne Host' {
            Remove-B1Host -Name $Name -NoWarning 6>$null
        }
    }
    Context 'B1TD-General' {
        It 'Remove Lookalike Target' {
            Remove-B1LookalikeTarget -Domain 'pester.test' -NoWarning 6>$null
        }
    }
}