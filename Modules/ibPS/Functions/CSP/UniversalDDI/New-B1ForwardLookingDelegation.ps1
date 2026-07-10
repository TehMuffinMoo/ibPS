function New-B1ForwardLookingDelegation {
    <#
    .SYNOPSIS
        Creates a new Forward Looking Delegation in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new Forward Looking Delegation in Universal DDI IPAM

    .PARAMETER Subnet
        The network address of the Forward Looking Delegation you are creating. If subnet is entered in CIDR notation, the CIDR will overwrite the -CIDR parameter.

    .PARAMETER CIDR
        The CIDR of the Forward Looking Delegation you are creating

    .PARAMETER Name
        The name of the Forward Looking Delegation you are creating

    .PARAMETER Description
        The description of the Forward Looking Delegation you are creating

    .PARAMETER Realm
        The name of the Federated Realm to associate with the new Forward Looking Delegation

    .PARAMETER Pool
        The name of the Federated Pool to associate with the new Forward Looking Delegation

    .PARAMETER Tags
        Any tags you want to apply to the new Forward Looking Delegation

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1ForwardLookingDelegation -Subnet 10.0.0.0/8 -Name "Delegation-1" -Description "My FLD" -Realm "Realm-1" -Pool "Pool-1" -Tags @{Environment="Test";Owner="Admin"}

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

    $splat = @{
        "address" = $Subnet
        "cidr" = $CIDR
        "name" = $Name
        "comment" = $Description
    }

    $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict).id
    if ($RealmID -eq $null) {
        Write-Error "No Federated Realm found with name '$Realm'. Cannot create Forward Looking Delegation without a valid Federated Realm."
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
    # $B1ForwardLookingDelegation = Get-B1ForwardLookingDelegation -Subnet $Subnet -CIDR $CIDR -RealmID $RealmID -PoolID $PoolID -ErrorAction SilentlyContinue
    # if ($B1ForwardLookingDelegation) {
    #     if ($Pool) {
    #         Write-Error "Forward Looking Delegation already exists with the subnet: $($Subnet)/$($CIDR) in Federated Pool: $($Pool) and Federated Realm: $($Realm)"
    #         return
    #     } else {
    #         Write-Error "Forward Looking Delegation already exists with the subnet: $($Subnet)/$($CIDR) in Federated Realm: $($Realm)"
    #         return
    #     }
    # } else {
        $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict).id
        if ($RealmID -eq $null) {
            Write-Error "No Federated Realm found with name '$Realm'. Cannot create Forward Looking Delegation without a valid Federated Realm."
            return
        } else {
            $splat | Add-Member -MemberType NoteProperty -Name "federated_realms" -Value @($RealmID)
        }

        if ($Subnet -match '/\d') {
            $IPandMask = $Subnet -Split '/'
            $Subnet = $IPandMask[0]
            $CIDR = $IPandMask[1]
        }

        if (!$CIDR) {
            Write-Error "CIDR is required to create a Forward Looking Delegation. Please specify a CIDR value."
            return
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4 -Compress

        if($PSCmdlet.ShouldProcess("Create new Forward Looking Delegation:`n$(JSONPretty($splat))","Create new Forward Looking Delegation: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/forward_looking_delegation" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($Result.name -eq $Name) {
                return $Result
            } else {
                Write-Host "Failed to create Forward Looking Delegation $($Name)." -ForegroundColor Red
                break
            }
        }
    # }
}