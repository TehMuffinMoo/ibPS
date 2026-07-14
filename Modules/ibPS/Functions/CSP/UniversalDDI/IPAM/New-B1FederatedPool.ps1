function New-B1FederatedPool {
    <#
    .SYNOPSIS
        Creates a new Federated Pool in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new Federated Pool in Universal DDI IPAM

    .PARAMETER Name
        The name of the Federated Pool

    .PARAMETER Description
        The description of the Federated Pool you are creating

    .PARAMETER Realm
        The name of the Federated Realm to associate with the new Federated Pool

    .PARAMETER Protocol
        The protocol of the Federated Pool you are creating. Valid values are: ip4, ip6 or ip4/ip6. Default is ip4.

    .PARAMETER Tags
        Any tags you want to apply to the new Federated Pool

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1FederatedPool -Name "Pool-1" -Description "This is a test pool" -Realm "Realm-1" -Protocol "ip4" -Tags @{Environment="Test";Owner="Admin"}

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
      [String]$Name,
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [String]$Realm,
      [ValidateSet("ip4", "ip6", "ip4/ip6")]
      [String]$Protocol = "ip4",
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $B1FederatedPool = Get-B1FederatedPool -Name $Name -Strict 6> $null
    if ($B1FederatedPool) {
        Write-Error "Federated Pool already exists with the name: $($Name)"
    } else {
        # {"federated_realm":"federation/federated_realm/1a66bea9-4001-47df-b79b-5271cd2da3bb","name":"mcox-pool2","protocol":"ip4/ip6","provider":"NIOS_X"}
        $RealmID = (Get-B1FederatedRealm -Name $Realm -Strict).id
        if ($RealmID -eq $null) {
            Write-Error "No Federated Realm found with name '$Realm'. Cannot create Federated Pool without a valid Federated Realm."
            return
        }
        $splat = @{
            "name" = $Name
            "protocol" = $Protocol
            "description" = $Description
            "provider" = "NIOS_X"
            "federated_realm" = $RealmID
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4 -Compress

        if($PSCmdlet.ShouldProcess("Create new Federated Pool:`n$(JSONPretty($splat))","Create new Federated Pool: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/federated_pool" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($Result.name -eq $Name) {
                return $Result
            } else {
                Write-Host "Failed to create Federated Pool $($Name)." -ForegroundColor Red
                break
            }
        }
    }
}