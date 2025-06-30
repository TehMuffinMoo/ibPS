function New-B1FixedAddress {
    <#
    .SYNOPSIS
        Creates a new fixed addresses in Universal DDI IPAM

    .DESCRIPTION
        This function is used to create a new fixed addresses in Universal DDI IPAM

    .PARAMETER IP
        The IP of the fixed address

    .PARAMETER Name
        The name of the fixed address

    .PARAMETER Description
        The description of the fixed address

    .PARAMETER MatchType
        The match type for the new fixed address (i.e MAC)

    .PARAMETER MatchValue
        The match value for the new fixed address (i.e ab:cd:ef:ab:cd:ef)

    .PARAMETER DHCPOptions
        A list of DHCP Options you want to apply to the new fixed address.

        Example usage when combined with Get-B1DHCPOptionCode

        $DHCPOptions = @()
        $DHCPOptions += @{"type"="option";"option_code"=(Get-B1DHCPOptionCode -Name "routers").id;"option_value"="10.10.100.1";}

    .PARAMETER Tags
        Any tags you want to apply to the fixed address

    .PARAMETER Space
        Use this parameter to filter the list of fixed addresses by Space

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1FixedAddress -IP 10.10.100.12 -Name "New name" -Description "A new description"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$IP,
      [Parameter(Mandatory=$false)]
      [String]$Name,
      [Parameter(Mandatory=$false)]
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [ValidateSet("mac","client_text","client_hex","relay_text","relay_hex")]
      [String]$MatchType,
      [Parameter(Mandatory=$true)]
      [String]$MatchValue,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [System.Object]$DHCPOptions,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if ($Space) {$SpaceUUID = (Get-B1Space -Name $Space -Strict).id}

    $splat = @{
      name = $Name
      comment = $Description
      ip_space = $SpaceUUID
      address = $IP
      match_type = $MatchType
      match_value = $MatchValue
      dhcp_options = $DHCPOptions
      tags = $Tags
    }
    $splat = $splat | ConvertTo-Json -Depth 10
    if($PSCmdlet.ShouldProcess("Create new Fixed Address:`n$($splat)","Create new Fixed Address: $($Name)",$MyInvocation.MyCommand)){
        $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/fixed_address" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Result.address -eq $IP) {
            Write-Host "Created Fixed Address Successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create Fixed Address." -ForegroundColor Red
        }
    }
}