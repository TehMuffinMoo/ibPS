$Name = "ibPS-PesterTests"
$Description = "Used for ibPS Pester Tests - https://ibPS.readthedocs.io"
$Tags = @{
    "Source" = "ibPS-Pester"
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
    }
}

Describe 'Get-*' {
    Context 'B1DDI-General' {
        It 'Get Fixed Address' {
            (Get-B1FixedAddress -IP 123.123.123.6 -Space $Name).Address | Should -Be 123.123.123.6
        }
        It 'Get Address Reservation' {
            (Get-B1Address -Address 123.123.123.5 -Reserved).Address | Should -Be 123.123.123.5
        }
        It 'Get DHCP Range' {
            (Get-B1Range -StartAddress 123.123.123.10 -EndAddress 123.123.123.30 -Space $Name).start | Should -Be 123.123.123.10
        }
        It 'Get Subnet' {
            (Get-B1Subnet -Subnet 123.123.123.0 -CIDR 26 -Space $Name).Address | Should -Be 123.123.123.0
        }
        It 'Get Address Block' {
            (Get-B1AddressBlock -Subnet 123.123.123.0 -CIDR 24 -Space $Name).Address | Should -Be 123.123.123.0
        }
        It 'Get IP Space' {
            (Get-B1Space -Name $Name).Name | Should -Be $Name
        }
        It 'Get DNS View' {
            (Get-B1DNSView -Name $Name).Name | Should -Be $Name
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
        It 'Remove DNS View' {
            Remove-B1DNSView -Name $Name 6>$null
        }
    }
}