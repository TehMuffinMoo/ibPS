function Set-B1DNSHost {
    <#
    .SYNOPSIS
        Updates an existing DNS Host

    .DESCRIPTION
        This function is used to updates an existing DNS Host

    .PARAMETER Name
        The name of the BloxOneDDI DNS Host

    .PARAMETER DNSConfigProfile
        The name of the DNS Config Profile to apply to the DNS Host. This will overwrite the existing value. Using the value 'None' will remove the DNS Config Profile from the host.

    .PARAMETER DNSName
        The DNS FQDN to use for this DNS Server. This will overwrite the existing value. Using the value 'None' will remove the DNS Name from the host.

    .PARAMETER Tags
        Any tags you want to apply to the DNS Host

    .PARAMETER Object
        The DNS Host Object to update. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -DNSConfigProfile "Data Centre" -DNSName "bloxoneddihost1.mydomain.corp"

    .EXAMPLE
        Get-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" | Set-B1DNSHost -DNSConfigProfile "Data Centre" -DNSName "bloxoneddihost1.mydomain.corp"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(ParameterSetName="Default",Mandatory=$true)]
        [String]$Name,
        [String]$DNSConfigProfile,
        [String]$DNSName,
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
        if ($Object) {
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/host") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/host' objects as input"
              return $null
          }
        } else {
            $Object = Get-B1DNSHost -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find Forward DNS Server Group: $($Name)"
                return $null
            }
        }
        if ($Object) {
            $NewObj = $Object | Select-Object * -ExcludeProperty id,site_id,provider_id,current_version,dfp,dfp_service,external_providers_metadata,ophid,address,name,anycast_addresses,comment,tags,protocol_absolute_name
            $NewObj.associated_server = $NewObj.associated_server | Select-Object id
            if ($DNSConfigProfile) {
                if ($DNSConfigProfile -eq 'None') {
                    $NewObj.associated_server = $null
                } else {
                    $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $DNSConfigProfile -Strict).id
                    if ($DNSConfigProfileId) {
                        $NewObj.inheritance_sources = @{
                            "kerberos_keys" = @{
                                "action" = "inherit"
                            }
                        }
                        $NewObj.type = "bloxone_ddi"
                        $NewObj.associated_server = @{
                            "id" = $DNSConfigProfileId
                        }
                    } else {
                        Write-Error "DNS Config Profile $($DNSConfigProfile) not found."
                        return $null
                    }
                }
            }
            if ($DNSName) {
                if ($DNSName -eq 'None') {
                    $NewObj.absolute_name = $null
                } else {
                    $NewObj.absolute_name = $DNSName
                }
            }
            $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress

            if($PSCmdlet.ShouldProcess("Update DNS Host:`n$(JSONPretty($JSON))","Update DNS Host: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
                $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
                if ($($Results.id) -eq $($Object.id)) {
                    Write-Host "DNS Host: $($NewObj.name) updated successfully." -ForegroundColor Green
                    return $Results
                } else {
                    Write-Host "Failed to update DNS Host: $($NewObj.name)." -ForegroundColor Red
                }
            }
        }
    }
}