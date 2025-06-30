function Grant-B1DNSConfigProfile {
    <#
    .SYNOPSIS
        Applies a DNS Config Profile to one or most BloxOneDDI Hosts

    .DESCRIPTION
        This function is used to apply a DNS Config Profile to one or most BloxOneDDI Hosts

    .PARAMETER Name
        The name of the new DNS Config Profile

    .PARAMETER Hosts
        A list of BloxOneDDI Hosts to apply the DNS Config Profile to

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .PARAMETER Object
        The DNS Host object(s) to grant the DNS Config Profile to

    .EXAMPLE
        PS> Grant-B1DNSConfigProfile -Name "Data Centre" -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [Alias("Apply-B1HostDNSConfigProfile")]
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

        $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $Name -Strict).id
        if (!$DNSConfigProfileId) {
            Write-Error "Failed to get DNS Config Profile."
            break
        } else {
            foreach ($iObject in $Objects) {
                $splat = @{
                    "server" = $DNSConfigProfileId
                }

                $splat = $splat | ConvertTo-Json

                if($PSCmdlet.ShouldProcess("Assign DNS Config Profile: $($Name) to Host: $($iObject.name)","Assign DNS Config Profile: $($Name) to Host: $($iObject.name)",$MyInvocation.MyCommand)){
                    $Result = Invoke-CSP -Method "PATCH" -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($iObject.id)" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
                    if ($Result.server -eq $DNSConfigProfileId) {
                        Write-Host "DNS Config Profile `"$Name`" has been successfully applied to: $($iObject.name)" -ForegroundColor Green
                    } else {
                        Write-Host "Failed to apply DNS Config Profile `"$Name`" to: $($iObject.name)" -ForegroundColor Red
                    }
                }
            }
        }
    }
}