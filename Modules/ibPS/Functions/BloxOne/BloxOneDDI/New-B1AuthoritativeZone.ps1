function New-B1AuthoritativeZone {
    <#
    .SYNOPSIS
        Creates a new Authoritative Zone in BloxOneDDI

    .DESCRIPTION
        This function is used to create a new Authoritative Zone in BloxOneDDI

    .PARAMETER Type
        The type of authoritative zone to create (Primary / Secondary)
    
    .PARAMETER FQDN
        The FQDN of the zone to create

    .PARAMETER View
        The DNS View the zone will be created in

    .PARAMETER DNSHosts
        A list of DNS Hosts to assign to the zone

    .PARAMETER AuthNSGs
        A list of Authoritative DNS Server Groups to assign to the zone

    .PARAMETER DNSACL
        The DNS ACL to assign to the zone for zone transfers

    .PARAMETER Description
        The description for the new zone

    .PARAMETER Tags
        Any tags you want to apply to the authoritative zone

    .EXAMPLE
       PS> New-B1AuthoritativeZone -Type Primary -FQDN "mysubzone.mycompany.corp" -View "default" -AuthNSGs "Data Centre" -Description "My Subzone"
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("Primary","Secondary")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$FQDN,
      [Parameter(Mandatory=$true)]
      [System.Object]$View,
      [System.Object]$DNSHosts,
      [System.Object]$AuthNSGs,
      [String]$DNSACL,
      [String]$Description,
      [System.Object]$Tags
    )

    if (Get-B1AuthoritativeZone -FQDN $FQDN -View $View -Strict) {
        Write-Host "The $FQDN Zone already exists in DNS." -ForegroundColor Red
        break
    } else {

        $ViewUUID = (Get-B1DNSView -Name $View -Strict).id

        switch($Type) {
            "Primary" {
                $PrimaryType = "cloud"
            }
            "Secondary" {
                $PrimaryType = "external"
            }
        }

        $splat = @{
	        "fqdn" = $FQDN
	        "disabled" = $false
	        "view" = $ViewUUID
            "primary_type" = $PrimaryType
        }

        if ($DNSHosts) {
            $B1Hosts = New-Object System.Collections.ArrayList
            foreach ($DNSHost in $DNSHosts) {
                $B1Hosts.Add(@{"host"=(Get-B1DNSHost -Name $DNSHost).id;}) | Out-Null
            }
            $splat | Add-Member -Name "internal_secondaries" -Value $B1Hosts -MemberType NoteProperty
        }

        if ($AuthNSGs) {
            $B1AuthNSGs = @()
            foreach ($AuthNSG in $AuthNSGs) {
                $B1AuthNSGs += (Get-B1AuthoritativeNSG -Name $AuthNSG -Strict).id
            }
            $splat | Add-Member -Name "nsgs" -Value $B1AuthNSGs -MemberType NoteProperty
        }

        if ($DNSACL) {
            $DNSACLID = (Get-B1DNSACL -Name $DNSACL).id
            if ($DNSACLID) {
                $UpdateACL = @(@{
	                  "element" = "acl"
	                  "acl" = $DNSACLID
	            })
                $splat | Add-Member -Name "update_acl" -Value $UpdateACL -MemberType NoteProperty
            } else {
                Write-Host "Error. DNS ACL not found." -ForegroundColor Red
                break
            }
        }

        if ($Tags) {
            $splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }

        if ($Description) {
            $splat | Add-Member -Name "comment" -Value $Description -MemberType NoteProperty
        }

        $splat = $splat | ConvertTo-Json
        if ($Debug) {$splat}

        $Result = Query-CSP -Method POST -Uri "dns/auth_zone" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue

        if ($Result) {
            Write-Host "Created Authorative DNS Zone $FQDN successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create Authorative DNS Zone $FQDN." -ForegroundColor Red
        }

    }

}