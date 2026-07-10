function New-B1FederatedBlock {
    <#
    .SYNOPSIS
        Creates a new Federated Block in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new Federated Block in Universal DDI IPAM

    .PARAMETER Subnet
        The network address of the Federated Block you are creating. If subnet is entered in CIDR notation, the CIDR will overwrite the -CIDR parameter.

    .PARAMETER CIDR
        The CIDR of the Federated Block you are creating

    .PARAMETER Name
        The name of the Federated Block

    .PARAMETER Description
        The description of the Federated Block you are creating

    .PARAMETER Realm
        The name of the Federated Realm to associate with the new Federated Block

    .PARAMETER Pool
        The name of the Federated Pool to associate with the new Federated Block

    .PARAMETER DefaultPrefixLength
        The default prefix length of the Federated Block you are creating.

    .PARAMETER MinimumPrefixLength
        The minimum prefix length allowed under the Federated Block you are creating.

    .PARAMETER MaximumPrefixLength
        The maximum prefix length allowed under the Federated Block you are creating.
        
    .PARAMETER Tags
        Any tags you want to apply to the new Federated Block

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1FederatedBlock -Subnet 10.0.0.0/8 -Name "Block-1" -Description "This is a test block" -Realm "Realm-1" -Pool "Pool-1" -Protocol "ip4" -DefaultPrefixLength 24 -MinimumPrefixLength 16 -MaximumPrefixLength 28 -Tags @{Environment="Test";Owner="Admin"}

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Subnet,
        [ValidateRange(0,32)]
        [Int]$CIDR,
        [String]$Name,
        [String]$Description,
        [Parameter(Mandatory=$true)]
        [String]$Realm,
        [String]$Pool,
        [ValidateScript({
            if ($_ -lt $CIDR -or $_ -gt 32) {
                throw "DefaultPrefixLength must be between $CIDR and 32."
            }
            $true
        })]
        [Int]$DefaultPrefixLength,

        [ValidateScript({
            if ($_ -lt $CIDR -or $_ -gt 32) {
                throw "MinimumPrefixLength must be between $CIDR and 32."
            }
            $true
        })]
        [Int]$MinimumPrefixLength,

        [ValidateScript({
            if ($_ -lt $CIDR -or $_ -gt 32) {
                throw "MaximumPrefixLength must be between $CIDR and 32."
            }
            $true
        })]
        [Int]$MaximumPrefixLength,
        [System.Object]$Tags,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters

    if ($Subnet -match '/\d') {
        $IPandMask = $Subnet -Split '/'
        $Subnet = $IPandMask[0]
        $CIDR = $IPandMask[1]
    }

    $splat = @{
        "address" = $Subnet
        "cidr" = $CIDR
        "name" = $Name
        "comment" = $Description
        "federated_realm" = $RealmID
        "network_compliance" = @{}
    }

    $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict).id
    if ($RealmID -eq $null) {
        Write-Error "No Federated Realm found with name '$Realm'. Cannot create Federated Pool without a valid Federated Realm."
        return
    }

    if ($Pool) {
        $PoolID = (Get-B1FederatedPool -Name $Pool -RealmID $RealmID -Strict).id
        if ($PoolID -eq $null) {
            Write-Error "No Federated Pool found with name '$Pool'."
            return
        }
        $splat | Add-Member -MemberType NoteProperty -Name "federated_pool_id" -Value $PoolID
    }

    $B1FederatedBlock = Get-B1FederatedBlock -Subnet $Subnet -CIDR $CIDR -Strict -RealmID $RealmID -PoolID $PoolID 6> $null
    if ($B1FederatedBlock) {
        if ($Pool) {
            Write-Error "Federated Block already exists with the subnet: $($Subnet)/$($CIDR) in Federated Pool: $($Pool) and Federated Realm: $($Realm)"
            return
        } else {
            Write-Error "Federated Block already exists with the subnet: $($Subnet)/$($CIDR) in Federated Realm: $($Realm)"
            return
        }
    } else {
        $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict).id
        if ($RealmID -eq $null) {
            Write-Error "No Federated Realm found with name '$Realm'. Cannot create Federated Pool without a valid Federated Realm."
            return
        }

        if (!$CIDR) {
            Write-Error "CIDR is required to create a Federated Block. Please specify a CIDR value."
            return
        }

        if ($DefaultPrefixLength) {
            $splat.network_compliance | Add-Member -MemberType NoteProperty -Name "default_netmask_length" -Value $DefaultPrefixLength
        }
        if ($MinimumPrefixLength) {
            $splat.network_compliance | Add-Member -MemberType NoteProperty -Name "minimum_netmask_length" -Value $MinimumPrefixLength
        }
        if ($MaximumPrefixLength) {
            $splat.network_compliance | Add-Member -MemberType NoteProperty -Name "maximum_netmask_length" -Value $MaximumPrefixLength
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4 -Compress

        if($PSCmdlet.ShouldProcess("Create new Federated Block:`n$(JSONPretty($splat))","Create new Federated Block: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/federated_block" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($Result.name -eq $Name) {
                return $Result
            } else {
                Write-Host "Failed to create Federated Block $($Name)." -ForegroundColor Red
                break
            }
        }
    }
}