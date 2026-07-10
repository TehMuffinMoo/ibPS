function New-B1ReservedBlock {
    <#
    .SYNOPSIS
        Creates a new Reserved Block in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new Reserved Block in Universal DDI IPAM

    .PARAMETER Subnet
        The network address of the Reserved Block you are creating. If subnet is entered in CIDR notation, the CIDR will overwrite the -CIDR parameter.

    .PARAMETER CIDR
        The CIDR of the Reserved Block you are creating

    .PARAMETER Name
        The name of the Reserved Block you are creating

    .PARAMETER Description
        The description of the Reserved Block you are creating

    .PARAMETER Realm
        The name of the Federated Realm to associate with the new Reserved Block

    .PARAMETER Pool
        The name of the Federated Pool to associate with the new Reserved Block

    .PARAMETER Tags
        Any tags you want to apply to the new Reserved Block

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1ReservedBlock -Subnet 10.0.0.0/8 -Name "ReservedBlock-1" -Description "My Reserved Block" -Realm "Realm-1" -Pool "Pool-1" -Tags @{Environment="Test";Owner="Admin"}

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
    }

    $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict).id
    if ($RealmID -eq $null) {
        Write-Error "No Federated Realm found with name '$Realm'. Cannot create Reserved Block without a valid Federated Realm."
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

    ## Temporarily disabled due to backend API issues. This check will be re-enabled once the backend API is fixed.
    # $B1ReservedBlock = Get-B1ReservedBlock -Subnet $Subnet -CIDR $CIDR -RealmID $RealmID -PoolID $PoolID -ErrorAction SilentlyContinue
    # if ($B1ReservedBlock) {
    #     if ($Pool) {
    #         Write-Error "Reserved Block already exists with the subnet: $($Subnet)/$($CIDR) in Federated Pool: $($Pool) and Federated Realm: $($Realm)"
    #         return
    #     } else {
    #         Write-Error "Reserved Block already exists with the subnet: $($Subnet)/$($CIDR) in Federated Realm: $($Realm)"
    #         return
    #     }
    # } else {
        $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict).id
        if ($RealmID -eq $null) {
            Write-Error "No Federated Realm found with name '$Realm'. Cannot create Reserved Block without a valid Federated Realm."
            return
        } else {
            $splat | Add-Member -MemberType NoteProperty -Name "federated_realm" -Value $RealmID
        }

        if (!$CIDR) {
            Write-Error "CIDR is required to create a Reserved Block. Please specify a CIDR value."
            return
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4 -Compress

        if($PSCmdlet.ShouldProcess("Create new Reserved Block:`n$(JSONPretty($splat))","Create new Reserved Block: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/reserved_block" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($Result.name -eq $Name) {
                return $Result
            } else {
                Write-Host "Failed to create Reserved Block $($Name)." -ForegroundColor Red
                break
            }
        }
    # }
}