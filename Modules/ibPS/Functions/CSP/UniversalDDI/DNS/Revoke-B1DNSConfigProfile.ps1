function Revoke-B1DNSConfigProfile {
    <#
    .SYNOPSIS
        Revokes a DNS Config Profile from one or more NIOS-X Hosts

    .DESCRIPTION
        This function is used to revoke a DNS Config Profile from one or more NIOS-X Hosts

    .PARAMETER Hosts
        A list of NIOS-X Hosts to revoke the DNS Config Profile from

    .PARAMETER Object
        The DHCP Host object(s) to revoke DNS Config Profiles from. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Revoke-B1DNSConfigProfile -Hosts "ddihost1.mydomain.corp","ddihost2.mydomain.corp"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [Alias("Remove-B1HostDNSConfigProfile")]
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(
          ParameterSetName="Default",
          Mandatory=$true
        )]
        [System.Object]$Hosts,
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
          if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/host") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/host' objects as input"
              return $null
          } else {
            $Objects += $Object
          }
        } else {
            foreach ($DNSHost in $Hosts) {
                $Objects += Get-B1DNSHost -Name $DNSHost -Strict
            }
        }

        foreach ($iObject in $Objects) {
            $splat = @{
                "server" = $null
            }

            $splat = $splat | ConvertTo-Json

            if($PSCmdlet.ShouldProcess("Revoke DNS Config Profiles from Host: $($iObject.name)","Revoke DNS Config Profiles from Host: $($iObject.name)",$MyInvocation.MyCommand)){
                $Result = Invoke-CSP -Method "PATCH" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($iObject.id)" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
                if ($Result.server -eq $null) {
                    Write-Host "DNS Config Profiles have been successfully removed from: $($iObject.name)" -ForegroundColor Green
                } else {
                    Write-Host "Failed to remove DNS Config Profiles from: $($iObject.name)" -ForegroundColor Red
                }
            }
        }
    }
}