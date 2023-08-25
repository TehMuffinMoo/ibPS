function Set-B1DNSHost {
    <#
    .SYNOPSIS
        Updates an existing DNS Host

    .DESCRIPTION
        This function is used to updates an existing DNS Host

    .PARAMETER Name
        The name of the BloxOneDDI DNS Host

    .PARAMETER DNSConfigProfile
        The name of the DNS Config Profile to apply to the DNS Host. This will overwrite the existing value.

    .PARAMETER DNSName
        The DNS FQDN to use for this DNS Server. This will overwrite the existing value.

    .Example
        Set-B1DNSHost -Name "bloxoneddihost1.mydomain.corp" -DNSConfigProfile "Data Centre" -DNSName "bloxoneddihost1.mydomain.corp"
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [String]$DNSConfigProfile,
        [String]$DNSName
    )
    $DNSHost = Get-B1DNSHost -Name $Name -Strict
    if ($DNSConfigProfile) {
        $DNSConfigProfileId = (Get-B1DNSConfigProfile -Name $DNSConfigProfile -Strict).id
    }
    if ($DNSHost) {
        
        $splat = @{
            "inheritance_sources" = @{
		        "kerberos_keys" = @{
			        "action" = "inherit"
		        }
	        }
            "type" = "bloxone_ddi"
            "associated_server" = @{
                "id" = $DNSConfigProfileId
            }
        }

        if ($DNSName) {
            $splat | Add-Member -Name "absolute_name" -Value $DNSName -MemberType NoteProperty
        }

        $splat = $splat | ConvertTo-Json
        if ($debug) {$splat}
        
        $Results = Query-CSP -Method PATCH -Uri $($DNSHost.id) -Data $splat | Select -ExpandProperty result -ErrorAction SilentlyContinue

        if ($Results.name -eq $Name) {
            Write-Host "DNS Host: $Name updated successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to update DNS Host: $Name." -ForegroundColor Red
        }
    }
}