function Get-NetworkTopology {
    <#
    .SYNOPSIS
        Used to build a text or HTML based visual topology of all related child networks

    .DESCRIPTION
        This function is used to build a text or HTML based visual topology of all related child networks, based on a parent IP Space, Address Block, Subnet or Range.

    .PARAMETER Object
        The IP Space, Address Block, Subnet or Range to build a visual topology from. This parameter expects pipeline input.
    
    .PARAMETER IncludeRanges
        Determines whether range objects are included in the topology output. This may make the results take longer if there are a large number of subnet objects.

    .PARAMETER IncludeAddresses
        Determines whether address objects are included in the topology output. This will make the results take longer if there are a large number of range objects.

    .PARAMETER HTML
        Using the -HTML switch will open a HTML based Network Topology viewer

    .EXAMPLE
        PS> Get-B1Space my-ipspace | Get-NetworkTopology -IncludeAddresses

        Building Network Topology. This may take a moment..
        [P] / [ip_space]
            [AB] 10.0.0.0/16 [address_block]
                [AB] 10.0.64.0/18 [address_block]
                [AB] 10.0.8.0/22 [address_block]
                    [SN] 10.0.8.128/26 [subnet]
                        [AD] 10.0.8.128 [address]
                        [AD] 10.0.8.191 [address]
                    [SN] 10.0.8.192/26 [subnet]
                        [AD] 10.0.8.192 [address]
                        [AD] 10.0.8.255 [address]
                    [SN] 10.0.9.0/26 [subnet]
                        [AD] 10.0.9.0 [address]
                        [AD] 10.0.9.63 [address]
                    [AB] 10.0.8.0/26 [address_block]
                        [SN] 10.0.8.0/27 [subnet]
                            [AD] 10.0.8.0 [address]
                            [AD] 10.0.8.31 [address]
                        [SN] 10.0.8.32/27 [subnet]
                            [AD] 10.0.8.32 [address]
                            [AD] 10.0.8.63 [address]
                    [AB] 10.0.8.64/26 [address_block]
                        [SN] 10.0.8.64/27 [subnet]
                            [AD] 10.0.8.64 [address]
                            [AD] 10.0.8.95 [address]
                        [SN] 10.0.8.96/27 [subnet]
                            [AD] 10.0.8.96 [address]
                            [AD] 10.0.8.127 [address]
                [AB] 10.0.4.0/22 [address_block]
                    [SN] 10.0.4.0/24 [subnet]
                        [AD] 10.0.4.0 [address]
                        [AD] 10.0.4.255 [address]
                    [AB] 10.0.5.0/24 [address_block]
                        [SN] 10.0.5.0/29 [subnet]
                            [AD] 10.0.5.0 [address]
                            [AD] 10.0.5.7 [address]
                        [SN] 10.0.5.8/29 [subnet]
                            [AD] 10.0.5.8 [address]
                            [AD] 10.0.5.15 [address]
                        [SN] 10.0.5.16/29 [subnet]
                            [AD] 10.0.5.16 [address]
                            [AD] 10.0.5.23 [address]
                        [SN] 10.0.5.24/29 [subnet]
                            [AD] 10.0.5.24 [address]
                            [AD] 10.0.5.31 [address]
                        [SN] 10.0.5.32/29 [subnet]
                            [AD] 10.0.5.32 [address]
                            [AD] 10.0.5.39 [address]
                [SN] 10.0.1.0/24 [subnet]
                    [AD] 10.0.1.22 [address]
                    [RG] 10.0.1.200-10.0.1.240 [range]
                    [AD] 10.0.1.20 [address]
                    [AD] 10.0.1.0 [address]
                    [AD] 10.0.1.255 [address]
                    [AD] 10.0.1.25 [address]

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
        [Switch]$IncludeRanges,
        [Switch]$IncludeAddresses,
        [Switch]$HTML,
        [Parameter(
            ValueFromPipeline = $true,
            Mandatory=$true
        )]
        [System.Object[]]$Object
    )
    process {
        $PermittedInputs = "ip_space","address_block","subnet","range"
        if (($Object.id.split('/')[1]) -notin $PermittedInputs) {
            Write-Error "Error. Unsupported pipeline object. Supported inputs are ip_space, address_block, subnet & range"
            return $null
        }
        Write-Host "Building Network Topology. This may take a moment.." -ForegroundColor Magenta
        Build-TopologyChildren($Object) -IncludeAddresses:$IncludeAddresses -IncludeRanges:$IncludeRanges
        Switch ($Object.id.split('/')[1]) {
            "ip_space" {
                $ParentDescription = "$($Object.name)"
            }
            "address_block" {
                $ParentDescription = "$(($Object | Select-Object address).address)/$($Object.cidr)"
            }
            "subnet" {
                $ParentDescription = "$(($Object | Select-Object address).address)/$($Object.cidr)"
            }
        }
        Write-Host "`r                              "
        Write-Host "[P] $ParentDescription [$($Object.id.split('/')[1])]" -ForegroundColor Yellow
        $Object | Write-NetworkTopology -IncludeAddresses:$IncludeAddresses -IncludeRanges:$IncludeRanges
        if ($HTML) {
            if (!(Get-Module PSWriteHTML -ListAvailable)) {
                Write-Error "Error. You must have the PSWriteHTML PowerShell Module installed to use this feature."
                return $null
            }
            $TableID = Get-Random
            New-HTML -TitleText 'Network Topology' -Online -ShowHTML {
                New-HTMLSection -Invisible {
                    # New-HTMLPanel {
                    #     New-HTMLTable -DataTable $Topology -DataTableID $TableID
                    # }
                    New-HTMLPanel {
                        New-HTMLDiagram -Height '1000px' {
                            New-DiagramEvent -ID $TableID -ColumnID 1
                            New-DiagramNode -Label $($ParentDescription) -IconSolid cloud -IconColor TangerineYellow -Size 10
                            Build-HTMLTopologyChildren($Object) -IncludeAddresses:$IncludeAddresses -IncludeRanges:$IncludeRanges
                        }
                    }
                }
            }
        }
    }
}