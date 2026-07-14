function New-B1FederatedRealm {
    <#
    .SYNOPSIS
        Creates a new Federated Realm in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new Federated Realm in Universal DDI IPAM

    .PARAMETER Name
        The name of the Federated Realm

    .PARAMETER Description
        The description of the Federated Realm you are creating

    .PARAMETER Tags
        Any tags you want to apply to the new Federated Realm

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1FederatedRealm -Name "Realm-1" -Description "This is a test realm" -Tags @{Environment="Test";Owner="Admin"}

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
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $B1FederatedRealm = Get-B1FederatedRealm -Name $Name -Strict 6> $null
    if ($B1FederatedRealm) {
        Write-Error "Federated Realm already exists with the name: $($Name)"
    } else {
        $splat = @{
            "name" = $Name
            "comment" = $Description
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        $splat = $splat | ConvertTo-Json -Depth 4 -Compress

        if($PSCmdlet.ShouldProcess("Create new Federated Realm:`n$(JSONPretty($splat))","Create new Federated Realm: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/federation/federated_realm" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            if ($Result.name -eq $Name) {
                return $Result
            } else {
                Write-Host "Failed to create Federated Realm $($Name)." -ForegroundColor Red
                break
            }
        }
    }
}