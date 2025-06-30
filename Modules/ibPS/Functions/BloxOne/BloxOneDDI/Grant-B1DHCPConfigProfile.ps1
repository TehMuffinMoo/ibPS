function Grant-B1DHCPConfigProfile {
    <#
    .SYNOPSIS
        Applies a DHCP Config Profile to one or most BloxOneDDI Hosts

    .DESCRIPTION
        This function is used to apply a DHCP Config Profile to one or most BloxOneDDI Hosts

    .PARAMETER Name
        The name of the new DHCP Config Profile

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to apply the DHCP Config Profile to

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .PARAMETER Object
        The DHCP Host object(s) to grant the DHCP Config Profile to

    .EXAMPLE
        PS> Grant-B1DHCPConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DHCP
    #>
    [Alias("Apply-B1HostDHCPConfigProfile")]
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
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
      Write-Error "Failed to get DHCP Config Profile."
      break
    } else {
      foreach ($iObject in $Objects) {
        $splat = @{
            "server" = $DHCPConfigProfileId
        }

        $splat = $splat | ConvertTo-Json

        if($PSCmdlet.ShouldProcess("Assign DHCP Config Profile: $($Name) to Host: $($iObject.name)","Assign DHCP Config Profile: $($Name) to Host: $($iObject.name)",$MyInvocation.MyCommand)){
          $Result = Invoke-CSP -Method "PATCH" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($iObject.id)" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
          if ($Result.server -eq $DHCPConfigProfileId) {
              Write-Host "DHCP Config Profile `"$Name`" has been successfully applied to $($iObject.name)" -ForegroundColor Green
          } else {
              Write-Host "Failed to apply DHCP Config Profile `"$Name`" to $($iObject.name)" -ForegroundColor Red
          }
        }
      }
    }
  }
}