﻿function New-B1HAGroup {
    <#
    .SYNOPSIS
        Creates a new HA Group in Universal DDI

    .DESCRIPTION
        This function is used to create a new HA Group in Universal DDI

    .PARAMETER Name
        The name of the new HA Group

    .PARAMETER Mode
        The mode of the new HA Group

    .PARAMETER PrimaryNode
        The hostname or FQDN of the primary NIOS-X Host

    .PARAMETER SecondaryNode
        The hostname or FQDN of the secondary NIOS-X Host

    .PARAMETER Description
        The description of the new HA Group

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
          PS> New-B1HAGroup -Name "MyHAGroup" -Mode "active-passive" -PrimaryNode "ddihost1.mydomain.corp" -SecondaryNode "ddihost2.mydomain.corp" -Description "DHCP HA Group"

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
      [Parameter(Mandatory=$true)]
      [ValidateSet("active-active","active-passive","advanced-active-passive")]
      [String]$Mode,  ## active-active / active-passive
      [Parameter(Mandatory=$true)]
      [String]$PrimaryNode,
      [Parameter(Mandatory=$true)]
      [String]$SecondaryNode,
      [String]$Description,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if (Get-B1HAGroup -Name $Name -Strict) {
        Write-Host "HA Group already exists by the name $Name." -ForegroundColor Red
    } else {
        $HostA = "dhcp/host/"+(Get-B1Host -Name $PrimaryNode -BreakOnError).legacy_id
        $HostARole = "active"
        $HostB = "dhcp/host/"+(Get-B1Host -Name $SecondaryNode -BreakOnError).legacy_id
        $HostBRole = "active"
        if ($Mode -eq "active-passive" -or $Mode -eq "advanced-active-passive") {
            $HostBRole = "passive"
        }

        $HAHosts = New-Object System.Collections.ArrayList
        $HAHosts.Add(@{"host"="$HostA";"role"="$HostARole";}) | Out-Null
        $HAHosts.Add(@{"host"="$HostB";"role"="$HostBRole";}) | Out-Null

        $splat = @{
            "name" = $Name
            "mode" = $Mode
            "comment" = $Description
            "hosts" = $HAHosts
        }

        $splat = $splat | ConvertTo-Json
        if($PSCmdlet.ShouldProcess("Create new DHCP HA Group:`n$($splat)","Create new DHCP HA Group: $($Name)",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dhcp/ha_group" -Data $splat | Select-Object -ExpandProperty result
            if ($Result.name -eq $Name) {
                Write-Host "Created DHCP HA Group $Name Successfully." -ForegroundColor Green
                return $Result
            } else {
                Write-Host "Failed to create DHCP HA Group $Name." -ForegroundColor Red
            }
        }
    }
}