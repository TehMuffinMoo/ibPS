function Set-B1Host {
    <#
    .SYNOPSIS
        Updates an existing NIOS-X Host

    .DESCRIPTION
        This function is used to update an existing NIOS-X Host

    .PARAMETER Name
        The name of the NIOS-X Host to update.

    .PARAMETER NewName
        Use -NewName to update the name of the NIOS-X Host

    .PARAMETER IP
        The IP of the NIOS-X Host to update.

    .PARAMETER TimeZone
        The TimeZone to set the NIOS-X Host to, i.e "Europe/London"

    .PARAMETER Space
        The name of the IP Space to assign the NIOS-X Host to

    .PARAMETER Description
        The description to update the NIOS-X Host to

    .PARAMETER Location
        The updated Location for the specific NIOS-X Host. Using the value 'None' will set it to Empty

    .PARAMETER Tags
        A list of tags to apply to this 
         Host. This will overwrite existing tags.

    .PARAMETER Object
        The host object to update. Accepts pipeline input from Get-B1Host

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1Host -Name "ddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"

    .EXAMPLE
        PS> Get-B1Host -Name "ddihost1.mydomain.corp" | Set-B1Host -NewName "mynewhostname.mydomain.corp"

    .FUNCTIONALITY
        NIOS-X

    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Medium'
    )]
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
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      if ($Object) {
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/host") {
              $Object = Get-B1Host -id $($Object.id) -Detailed
              if (-not $Object) {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/host' objects as input"
                return $null
              }
              $HostID = $Object.id
          } else {
            $HostID = $SplitID[2]
          }
      } else {
          if ($IP) {
            $Object = Get-B1Host -IP $IP -Strict
            if (!($Object)) {
                Write-Host "On-Prem Host $IP does not exist." -ForegroundColor Gray
            }
          } elseif ($Name) {
            $Object = Get-B1Host -Name $Name -Strict
            if (!($Object)) {
                Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
            }
          }
          $HostID = $Object.id
      }

      $NewObj = $Object | Select-Object * -ExcludeProperty id,configs,created_at

      if ($NewName) {
        $NewObj.display_name = $NewName
      }
      if ($TimeZone) {$NewObj.timezone = $TimeZone}
      if ($Space) {
        if ($NewObj.ip_space) {
            $NewObj.ip_space = (Get-B1Space -Name $Space -Strict).id
        } else {
            $NewObj | Add-Member -MemberType NoteProperty -Name "ip_space" -Value (Get-B1Space -Name $Space -Strict).id
        }
      }
      if ($Description) {
        if ($NewObj.description) {
            $NewObj.description = $Description
        } else {
            $NewObj | Add-Member -MemberType NoteProperty -Name "description" -Value $Description
        }
      }
      if ($Location) {
        if ($Location -eq 'None') {
          if ($NewObj.location) {
            $NewObj.location_id = $null
          } else {
              $NewObj | Add-Member -MemberType NoteProperty -Name "location_id" -Value $null
          }
        } else {
          $LocationID = (Get-B1Location -Name $Location -Strict).id
          if ($LocationID) {
            if ($NewObj.location) {
              $NewObj.location_id = $LocationID
            } else {
                $NewObj | Add-Member -MemberType NoteProperty -Name "location_id" -Value $LocationID
            }
          } else {
            Write-Error "Unable to find Location: $($Location)"
            return $null
          }
        }
      }
      if ($Tags) {
        if ($NewObj.tags) {
            $NewObj.tags = $Tags
        } else {
            $NewObj | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }
      }

      $JSON = $NewObj | Select-Object * -ExcludeProperty id,configs,created_at | ConvertTo-Json -Depth 10 -Compress

      if($PSCmdlet.ShouldProcess("Update NIOS-X Host`n$(JSONPretty($JSON))","Update NIOS-X Host: $($NewObj.display_name) ($($NewObj.id))",$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/hosts/$HostID" -Data $JSON | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($($Results.id.split('/')[2]) -eq $($HostID)) {
          Write-Host "Updated NIOS-X Host Configuration $($NewObj.display_name) successfuly." -ForegroundColor Green
          return $Results
        } else {
          Write-Error "Failed to update NIOS-X Host Configuration on $($NewObj.display_name)."
          return $Results
        }
      }
    }
}