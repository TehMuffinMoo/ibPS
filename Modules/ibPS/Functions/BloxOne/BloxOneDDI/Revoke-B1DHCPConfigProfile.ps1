function Revoke-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Removes a DHCP Config Profile from one or more BloxOneDDI hosts

    .DESCRIPTION
        This function is used to remove a DHCP Config Profile from one or more BloxOneDDI hosts

    .PARAMETER Name
        The name of the DHCP Config Profile to remove

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to remove the DHCP Config Profile from

    .PARAMETER Object
        The DHCP Host object(s) to revoke DHCP Config Profiles from

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Revoke-B1DHCPConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DHCP
    #>
    [Alias("Remove-B1HostDHCPConfigProfile")]
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
      )]
    param(
        [Parameter(
          ParameterSetName="Default",
          Mandatory=$true
        )]
        [String[]]$Hosts,
        [Parameter(
          ValueFromPipeline = $true,
          ParameterSetName="Object",
          Mandatory=$true
        )]
        [System.Object]$Object,
        [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        $Objects = @()
        if ($Object) {
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "dhcp/host") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'dhcp/host' objects as input"
              return $null
          } else {
            $Objects += $Object
          }
        } else {
            foreach ($DHCPHost in $Hosts) {
                $Objects += Get-B1DHCPHost -Name $DHCPHost -Strict
            }
        }

        $DHCPConfigProfileId = (Get-B1DHCPConfigProfile -Name $Name -Strict).id
        if (!$DHCPConfigProfileId) {
          Write-Error "Failed to find DHCP Config Profile: $($Name)."
          break
        } else {
            foreach ($iObject in $Objects) {
                $splat = @{
                    "server" = $null
                }

                $splat = $splat | ConvertTo-Json

                if($PSCmdlet.ShouldProcess("Revoke DHCP Config Profiles from Host: $($iObject.name)","Revoke DHCP Config Profiles from Host: $($iObject.name)",$MyInvocation.MyCommand)){
                    $Result = Invoke-CSP -Method "PATCH" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($iObject.id)" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
                    if ($Result.server -eq $null) {
                        Write-Host "DHCP Config Profiles have been successfully removed from: $($iObject.name)" -ForegroundColor Green
                    } else {
                        Write-Host "Failed to remove DHCP Config Profiles from: $($iObject.name)" -ForegroundColor Red
                    }
                }
            }
        }
    }
}