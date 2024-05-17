function Set-B1Record {
    <#
    .SYNOPSIS
        Updates an existing DNS record in BloxOneDDI

    .DESCRIPTION
        This function is used to update an existing DNS record in BloxOneDDI

    .PARAMETER Type
        The type of the record to update

    .PARAMETER Name
        The name of the record to update.

    .PARAMETER Zone
        The zone of the record to update

    .PARAMETER NewName
        Use -NewName to update the name of the record

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

    .PARAMETER State
        Set whether the DNS Record is enabled or disabled.

    .PARAMETER Tags
        Any tags you want to apply to the record

    .PARAMETER Object
        The Range Object to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1Record -Type A -Name "myArecord" -Zone "corp.mydomain.com" -View "default" -rdata "10.10.50.10" -TTL 600
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        DNS
    #>
    param(
      [Parameter(ParameterSetName="NameAndZone",Mandatory=$true)]
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [Parameter(ParameterSetName="RDATA",Mandatory=$true)]
      [ValidateSet("A","CNAME","PTR","NS","TXT","SOA","SRV")]
      [String]$Type,
      [Parameter(ParameterSetName="NameAndZone",Mandatory=$true)]
      [String]$Name,
      [Parameter(ParameterSetName="NameAndZone",Mandatory=$true)]
      [String]$Zone,
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [String]$FQDN,
      [Parameter(ParameterSetName="NameAndZone",Mandatory=$true)]
      [Parameter(ParameterSetName="FQDN",Mandatory=$true)]
      [Parameter(ParameterSetName="RDATA",Mandatory=$true)]
      [String]$View,
      [Parameter(ParameterSetName="RDATA",Mandatory=$true)]
      [String]$CurrentRDATA,
      [String]$rdata,
      [String]$NewName,
      [int]$TTL,
      [string]$Description,
      [int]$Priority,
      [int]$Weight,
      [int]$Port,
      [ValidateSet("Enabled","Disabled")]
      [String]$State,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Object",
        Mandatory=$true
      )]
      [System.Object]$Object
    )
    
    process {
      if ($Object) {
        $SplitID = $Object.id.split('/')
        if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/record") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/record' objects as input"
            return $null
        }
        $Type = $Object.type
    } else {
        $Object = Get-B1Record -Name $Name -View $view -Zone "$Zone" -rdata $CurrentRDATA
        if (!($Object)) {
            Write-Error "Unable to find DNS Record: $($StartAddress) - $($EndAddress)"
            return $null
        }
        if ($Object.count -gt 1) {
            Write-Error "Multiple Subnet were found, to update more than one Subnet you should pass those objects using pipe instead."
            return $null
        }
    }
    $NewObj = $Object | Select-Object * -ExcludeProperty id,provider_metadata,source,view_name,dns_name_in_zone,dns_absolute_zone_name,dns_absolute_name_spec,absolute_name_spec,absolute_zone_name,absolute_zone_spec,dns_rdata,delegation,created_at,updated_at,ipam_host,subtype,type,view,record,zone

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
              Write-Host "Error. When updating SRV records, -Priority, -Weight & -Port parameters are all required."
              break
            }
          } else {
            Write-Error "Error. SRV target must be an FQDN: $rdata"
            return $null
          }
        }
        default {
          Write-Error "Error. Invalid record type: $Type"
          Write-Error "Please use a supported record type: $SupportedRecords"
          return $null
        }
      }
      $NewObj.rdata = $rdatasplat
    }
    if ($NewName) {
      $NewObj.name_in_zone = $NewName
    }
    if ($TTL) {
      $NewObj.inheritance_sources
      $NewObj.inheritance_sources = @{
        "ttl" = @{
          "action" = "override"
          }
      }
      $NewObj.ttl = $TTL
    }
    if ($Tags) {
      $NewObj.tags = $Tags
    }     
    if ($Description) {
      $NewObj.comment = $Description
    }
    if ($State) {
      $NewObj.disabled = $(if ($State -eq 'Enabled') { $false } else { $true })
    }
    $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
    $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
    if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
        $Results | Select-Object -ExpandProperty result
    } else {
        $Results
    }
  }
}