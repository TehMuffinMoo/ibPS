function New-B1Record {
    <#
    .SYNOPSIS
        Creates a new DNS record in BloxOneDDI

    .DESCRIPTION
        This function is used to create a new DNS record in BloxOneDDI

    .PARAMETER Type
        The record type to create

    .PARAMETER Name
        The name of the record to create

    .PARAMETER Zone
        The zone which the record will be created in

    .PARAMETER rdata
        The RDATA for the record to be created

    .PARAMETER View
        The DNS View the record will be created in

    .PARAMETER TTL
        Use this parameter to set a custom TTL when creating the record

    .PARAMETER Description
        The description of the record to be created

    .PARAMETER CreatePTR
        Whether to create an associated PTR record (where applicable). This defaults to $true

    .PARAMETER Priority
        Used to set the priority for applicable records. (i.e SRV)

    .PARAMETER Weight
        Used to set the weight for applicable records. (i.e SRV)

    .PARAMETER Port
        Used to set the port for applicable records. (i.e SRV)

    .PARAMETER SkipExistsErrors
        Whether to skip errors if the record already exists. Default is $false

    .PARAMETER IgnoreExists
        Whether to ignore if a record already exists and attempt to create it anyway

    .Example
        New-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default" -rdata "10.10.30.10" -TTL 300
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(Mandatory=$true)]
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Zone,
      [Parameter(Mandatory=$true)]
      [String]$rdata,
      [Parameter(Mandatory=$true)]
      [String]$view,
      [int]$TTL,
      [string]$Description,
      [bool]$CreatePTR = $true,
      [int]$Priority,
      [int]$Weight,
      [int]$Port,
      [switch]$SkipExistsErrors = $false,
      [switch]$IgnoreExists = $false
    )
    
    $SupportedRecords = "A","CNAME","PTR","TXT","SRV"
    ## To be added: "NS","SOA"
    if (!($Type -in $SupportedRecords)) {
        Write-Host "Invalid type specified. The following record types are supported: $SupportedRecords" -ForegroundColor Red
        break
    }

    if ($view) {
        $viewId = (Get-B1DNSView -Name $view -Strict).id
    }

    $TTLAction = "inherit"
    $FQDN = $Name+"."+$Zone
    $Record = Get-B1Record -Name $Name -View $view -Strict | where {$_.absolute_zone_name -match "^$($Zone)"}
    if ($Record -and -not $IgnoreExists) {
        if (!$SkipExistsErrors -and !$Debug) {Write-Host "DNS Record $($Name).$($Zone) already exists." -ForegroundColor Yellow}
        return $false
    } else {
        $AuthZoneId = (Get-B1AuthoritativeZone -FQDN $Zone -Strict -View $view).id
        if (!($AuthZoneId)) {
            Write-Host "Error. Authorative Zone not found." -ForegroundColor Red
        } else {
            switch ($Type) {
                "A" {
                    if (!(Get-B1Record -Name $Name -rdata $rdata -Strict | where {$_.absolute_zone_name -match "^$($Zone)"})) {
                        if ([bool]($rdata -as [ipaddress])) {
                            $rdataSplat = @{
	                            "address" = $rdata
	                        }
                            $Options = @{
		                            "create_ptr" = $CreatePTR
		                            "check_rmz" = $false
	                        }
                        } else {
                            Write-Host "Error. Invalid IP Address." -ForegroundColor Red
                            break
                        }
                    } else {
                        Write-Host "DNS Record $($Name).$($Zone) already exists." -ForegroundColor Yellow
                    }
                }
                "CNAME" {
                    if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}(\.)?$)") {
                        if (!($rdata.EndsWith("."))) {
                            $rdata = "$rdata."
                        }
                        $rdataSplat = @{
	                        "cname" = $rdata
	                    }
                    } else {
                        Write-Host "Error. CNAME must be an FQDN: $rdata" -ForegroundColor Red
                        break
                    }
                }
                "TXT" {
                    $rdataSplat = @{
                        "text" = $rdata
	                }
                }
                "PTR" {
                    $rdataSplat = @{
                        "dname" = $rdata
	                }
                }
                "SRV" {
                    if ($rdata -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)") {
                        if ($Priority -and $Weight -and $Port) {
                            $rdataSplat = @{
		                        "priority" = $Priority
		                        "weight" = $Weight
		                        "port" = $Port
		                        "target" = $rdata
	                        }
                        } else {
                            Write-Host "Error. When creating SRV records, -Priority, -Weight & -Port parameters are all required." -ForegroundColor Red
                            break
                        }
                    } else {
                        Write-Host "Error. SRV target must be an FQDN: $rdata" -ForegroundColor Red
                        break
                    }
                }
                default {
                    Write-Host "Error. Invalid record type: $Type" -ForegroundColor Red
                    Write-Host "Please use a supported record type: $SupportedRecords" -ForegroundColor Gray
                    break
                }
            }
            if ($rdataSplat) {
                Write-Host "Creating $Type Record for $FQDN.." -ForegroundColor Gray
            
                if ($TTL) {
                    $TTLAction = "override"
                }
                $splat = @{
	                "name_in_zone" = $Name
	                "zone" = $AuthZoneId
	                "type" = $Type
	                "rdata" = $rdataSplat
	                "inheritance_sources" = @{
		                "ttl" = @{
			                "action" = $TTLAction
		                }
	                }
                }
                if ($Options) {
                    $splat | Add-Member -Name "options" -Value $Options -MemberType NoteProperty
                }               
                if ($TTL) {
                    $splat | Add-Member -Name "ttl" -Value $TTL -MemberType NoteProperty
                }
                if ($viewId) {
                    #$splat | Add-Member -Name "view" -Value $viewId -MemberType NoteProperty
                }
                if ($Description) {
                    $splat | Add-Member -Name "comment" -Value $Description -MemberType NoteProperty
                }

                $splat = $splat | ConvertTo-Json
                if ($Debug) {$splat}
                $Result = Query-CSP -Method POST -Uri "dns/record" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
                if ($Debug) {$Result}
                if ($Result.dns_rdata -match $rdata) {
                    Write-Host "DNS $Type Record has been successfully created for $FQDN." -ForegroundColor Green
                    #return $Result
                } else {
                    Write-Host "Failed to create DNS $Type Record for $FQDN." -ForegroundColor Red
                }

            }
        }
    }

}