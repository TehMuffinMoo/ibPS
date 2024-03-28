function Set-B1Record {
    <#
    .SYNOPSIS
        Updates an existing DNS record in BloxOneDDI

    .DESCRIPTION
        This function is used to update an existing DNS record in BloxOneDDI

    .PARAMETER Type
        The type of the record to update

    .PARAMETER Name
        The name of the record to update

    .PARAMETER Zone
        The zone of the record to update

    .PARAMETER rdata
        The RDATA to update the record to

    .PARAMETER View
        The DNS View the record exists in

    .PARAMETER CurrentRDATA
        Optional parameter to select record based on current RDATA. Will be deprecated once pipeline input is implemented.

    .PARAMETER TTL
        The TTL to update the record to

    .PARAMETER Description
        The description to update the record to

    .PARAMETER Priority
        Used to update the priority for applicable records. (i.e SRV)

    .PARAMETER Weight
        Used to update the weight for applicable records. (i.e SRV)

    .PARAMETER Port
        Used to update the port for applicable records. (i.e SRV)

    .PARAMETER Tags
        Any tags you want to apply to the record

    .PARAMETER id
        The id of the DNS record to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default" -rdata "10.10.50.10" -TTL 600
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Zone,
      [String]$rdata,
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$view,
      [Parameter(ParameterSetName="Default")]
      [String]$CurrentRDATA,
      [int]$TTL,
      [string]$Description,
      [int]$Priority,
      [int]$Weight,
      [int]$Port,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )
    
    process {

      $TTLAction = "inherit"
      $FQDN = $Name+"."+$Zone
      if ($id) {
        $Record = Get-B1Record -id $id
      } else {
        $Record = Get-B1Record -Name $Name -View $view -Zone "$Zone" -rdata $CurrentRDATA
      }
      if (!($Record)) {
        Write-Host "Error. Record doesn't exist." -ForegroundColor Red
        break
      } else {
        $splat = @{}
        if ($rdata) {
          switch ($Type) {
            "A" {
              if ([bool]($rdata -as [ipaddress])) {
                $rdataSplat = @{
                    "address" = $rdata
                }
              } else {
                Write-Host "Error. Invalid IP Address." -ForegroundColor Red
                break
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
                  Write-Host "Error. When updating SRV records, -Priority, -Weight & -Port parameters are all required." -ForegroundColor Red
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
            $splat.rdata = $rdataSplat
          }
        }

        if ($Name) {
          $splat.name_in_zone = $Name
        }
        if ($TTL) {
          $TTLAction = "override"
          $Record.inheritance_sources
          $Splat.inheritance_sources = @{
            "ttl" = @{
              "action" = $TTLAction
             }
          }
          $Splat.ttl = $TTL
        }
        if ($Options) {
          $splat.options = $Options
        }          
        if ($Tags) {
          $splat.tags = $Tags
        }     
        if ($Description) {
          $splat | Add-Member -Name "comment" -Value $Description -MemberType NoteProperty
        }

        Write-Host "Updating $($Record.type) Record for $($Record.absolute_name_spec)" -ForegroundColor Gray
        $splat = $splat | ConvertTo-Json
        if ($ENV:IBPSDebug -eq "Enabled") {$splat}
        $Result = Query-CSP -Method PATCH -Uri $($Record.id) -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($ENV:IBPSDebug -eq "Enabled") {$Result}
        if ($Result.dns_rdata -match $rdata) {
          Write-Host "DNS $($Record.type) Record has been successfully updated for $($Record.absolute_name_spec)" -ForegroundColor Green
        } else {
          Write-Host "Failed to update DNS $($Record.type) Record for $($Record.absolute_name_spec)" -ForegroundColor Red
      }
    }
  }
}