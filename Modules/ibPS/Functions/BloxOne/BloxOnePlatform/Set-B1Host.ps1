function Set-B1Host {
    <#
    .SYNOPSIS
        Updates an existing BloxOne Host

    .DESCRIPTION
        This function is used to update an existing BloxOne Host

    .PARAMETER Name
        The name of the BloxOne Host to update.

    .PARAMETER NewName
        Use -NewName to update the name of the BloxOne Host

    .PARAMETER IP
        The IP of the BloxOne Host to update.

    .PARAMETER TimeZone
        The TimeZone to set the BloxOne Host to, i.e "Europe/London"

    .PARAMETER Space
        The name of the IP Space to assign the BloxOne Host to

    .PARAMETER Description
        The description to update the BloxOne Host to

    .PARAMETER Location
        The updated Location for the specific BloxOne Host. Using the value 'None' will set it to Empty

    .PARAMETER Tags
        A list of tags to apply to this BloxOne Host. This will overwrite existing tags.

    .PARAMETER Object
        The host object to update. Accepts pipeline input from Get-B1Host

    .EXAMPLE
        PS> Set-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"

    .EXAMPLE
        PS> Get-B1Host -Name "bloxoneddihost1.mydomain.corp" | Set-B1Host -NewName "mynewhostname.mydomain.corp"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
    param(
      [Parameter(ParameterSetName="Default")]
      [String]$Name,
      [Parameter(ParameterSetName="Default")]
      [String]$IP,
      [String]$NewName,
      [String]$Space,
      [String]$TimeZone,
      [String]$Description,
      [String]$Location,
      [Parameter(ParameterSetName="Default")]
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Pipeline",
        Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {

      if ($Object) {
        $SplitID = $Object.id.split('/')
        if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/host") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/host' objects as input"
            return $null
        } else {
          $B1Host = $Object
        }
      } else {
        if ($IP) {
          $B1Host = Get-B1Host -IP $IP -Strict
          if (!($B1Host)) {
              Write-Host "On-Prem Host $IP does not exist." -ForegroundColor Gray
          }
        } elseif ($Name) {
          $B1Host = Get-B1Host -Name $Name -Strict
          if (!($B1Host)) {
              Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
          }
        }
      }

      if ($B1Host) {
        if ($NewName) {
          $B1Host.display_name = $NewName
        }
        if ($TimeZone) {$B1Host.timezone = $TimeZone}
        if ($Space) {
          if ($B1Host.ip_space) {
              $B1Host.ip_space = (Get-B1Space -Name $Space -Strict).id
          } else {
              $B1Host | Add-Member -MemberType NoteProperty -Name "ip_space" -Value (Get-B1Space -Name $Space -Strict).id
          }
        }
        if ($Description) {
          if ($B1Host.description) {
              $B1Host.description = $Description
          } else {
              $B1Host | Add-Member -MemberType NoteProperty -Name "description" -Value $Description
          }
        }
        if ($Location) {
          if ($Location -eq 'None') {
            if ($B1Host.location) {
              $B1Host.location_id = $null
            } else {
                $B1Host | Add-Member -MemberType NoteProperty -Name "location_id" -Value $null
            }
          } else {
            $LocationID = (Get-B1Location -Name $Location -Strict).id
            if ($LocationID) {
              if ($B1Host.location) {
                $B1Host.location_id = $LocationID
              } else {
                  $B1Host | Add-Member -MemberType NoteProperty -Name "location_id" -Value $LocationID
              }
            } else {
              Write-Error "Unable to find Location: $($Location)"
              return $null
            }
          }
        }
        if ($Tags) {
          if ($B1Host.tags) {
              $B1Host.tags = $Tags
          } else {
              $B1Host | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
          }
        }

        $hostID = $B1Host.id.replace("infra/host/","")

        $splat = $B1Host | Select-Object * -ExcludeProperty id,configs,created_at | ConvertTo-Json -Depth 10 -Compress
        $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/hosts/$hostID" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($($Results.id) -eq $($B1Host.id)) {
          Write-Host "Updated BloxOne Host Configuration $($B1Host.display_name) successfuly." -ForegroundColor Green
          return $Results
        } else {
          Write-Error "Failed to update BloxOne Host Configuration on $($B1Host.display_name)."
          return $Results
        }
      }
    }
}