function Set-B1ForwardNSG {
    <#
    .SYNOPSIS
        Updates a Forward DNS Server Group in BloxOneDDI

    .DESCRIPTION
        This function is used to update a Forward DNS Server Group in BloxOneDDI

    .PARAMETER Name
        The name of the Forward DNS Server Group

    .PARAMETER NewName
        Use -NewName to update the name of the Forward DNS Server Group

    .PARAMETER Description
        The new description for the Forward DNS Server Group

    .PARAMETER AddHosts
        This switch indicates you are adding hosts to the Forward NSG using the -Hosts parameter

    .PARAMETER RemoveHosts
        This switch indicates you are removing hosts to the Forward NSG using the -Hosts parameter

    .PARAMETER Hosts
        This is a list of hosts to be added or removed from the Forward NSG, indicated by the -AddHosts & -RemoveHosts parameters

    .PARAMETER Tags
        Any tags you want to apply to the forward NSG

    .PARAMETER Object
        The Forward DNS Server Group Object to update. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1ForwardNSG -Name "InfoBlox DTC" -AddHosts -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp"

    .EXAMPLE
        PS> Get-B1ForwardNSG -Name "InfoBlox DTC" | Set-B1ForwardNSG -AddHosts -Hosts "bloxoneddihost1.mydomain.corp","bloxoneddihost2.mydomain.corp" -NewName "Infoblox DTC New"

    .FUNCTIONALITY
        BloxOneDDI

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
      [String]$NewName,
      [String]$Description,
      [Switch]$AddHosts,
      [Switch]$RemoveHosts,
      [System.Object]$Hosts,
      [System.Object]$Tags,
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
      if ($AddHosts -and $RemoveHosts) {
        Write-Error "Error. -AddHosts and -RemoveHosts are mutually exclusive."
        return $null
      }
      if (($AddHosts -or $RemoveHosts) -and !($Hosts)) {
        Write-Error "Error. You must specify a list of hosts using -Hosts when specifying -AddHosts or -RemoveHosts"
        return $null
      }
      if ($Object) {
        $SplitID = $Object.id.split('/')
        if (("$($SplitID[0])/$($SplitID[1])") -ne "dns/forward_nsg") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/forward_nsg' objects as input"
            return $null
        }
      } else {
          $Object = Get-B1ForwardNSG -Name $Name -Strict
          if (!($Object)) {
              Write-Error "Unable to find Forward DNS Server Group: $($Name)"
              return $null
          }
      }

      if ($Object) {
        $NewObj = $Object | Select-Object * -ExcludeProperty id

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($Hosts) {
          if ($AddHosts) {
            foreach ($B1Host in $Hosts) {
              $DNSHostId = (Get-B1DNSHost -Name $B1Host -Strict).id
              if ($DNSHostId) {
                if ($DNSHostId -notin $NewObj.hosts) {
                  Write-Host "Adding $B1Host to $($NewObj.name)" -ForegroundColor Cyan
                  $NewObj.hosts += $DNSHostId
                } else {
                  Write-Host "$B1Host is already in forward NSG: $($NewObj.name)" -ForegroundColor Yellow
                }
              } else {
                Write-Host "Error. DNS Host $B1Host not found." -ForegroundColor Red
              }
            }
          } elseif ($RemoveHosts) {
            foreach ($B1Host in $Hosts) {
              $DNSHostId = (Get-B1DNSHost -Name $B1Host -Strict).id
              if ($DNSHostId) {
                if ($DNSHostId -in $NewObj.hosts) {
                  $Update = $true
                  Write-Host "Removing $B1Host from $($NewObj.name)" -ForegroundColor Cyan
                  $NewObj.hosts = $NewObj.hosts | Where-Object {$_ -ne $DNSHostId}
                } else {
                  Write-Host "$B1Host is not in forward NSG: $($NewObj.name)" -ForegroundColor Yellow
                }
              } else {
                Write-Host "Error. DNS Host $B1Host not found." -ForegroundColor Red
              }
            }
          }
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        if($PSCmdlet.ShouldProcess("Update Foward DNS Server Group:`n$(JSONPretty($JSON))","Update Foward DNS Server Group: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
          $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
          if ($Results.id -eq $Object.id) {
            Write-Host "Successfully updated Forward NSG: $($NewObj.name)" -ForegroundColor Green
            return $Results
          } else {
            Write-Host "Error. Failed to update Forward NSG: $($NewObj.name)" -ForegroundColor Red
          }
        }
      }
    }
}