function Set-B1Host {
    <#
    .SYNOPSIS
        Updates an existing BloxOneDDI Host

    .DESCRIPTION
        This function is used to update an existing BloxOneDDI Host

    .PARAMETER Name
        The name of the BloxOneDDI host to update. If -IP is specified, the Name parameter will overwrite the existing display name.

    .PARAMETER IP
        The IP of the BloxOneDDI host to update.

    .PARAMETER TimeZone
        The TimeZone to set the BloxOneDDI host to, i.e "Europe/London"

    .PARAMETER Space
        The IPAM space where the BloxOneDDI host is located

    .PARAMETER Description
        The description to update the BloxOneDDI Host to

    .PARAMETER NoIPSpace
        This parameter is required when applying changes to BloxOneDDI Hosts which are not assigned to an IPAM Space

    .PARAMETER Tags
        A list of tags to apply to this BloxOneDDI Host. This will overwrite existing tags.

    .PARAMETER id
        The id of the host to update. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"
    
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
      [String]$Space,
      [String]$TimeZone,
      [String]$Description,
      [Parameter(ParameterSetName="Default")]
      [switch]$NoIPSpace,
      [System.Object]$Tags,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {

      if ($id) {
        $B1Host = Get-B1Host -id $id
      } else {
        if ($IP) {
          if ($NoIPSpace) {
              $B1Host = Get-B1Host -IP $IP -NoIPSpace:$NoIPSpace
          } else {
              $B1Host = Get-B1Host -IP $IP -Space $Space
          }
          if (!($B1Host)) {
              Write-Host "On-Prem Host $IP does not exist." -ForegroundColor Gray
          }
        } elseif ($Name) {
          if ($NoIPSpace) {
              $B1Host = Get-B1Host -Name $Name -NoIPSpace:$NoIPSpace -Strict
          } else {
              $B1Host = Get-B1Host -Name $Name -Space $Space -Strict
          }
          if (!($B1Host)) {
              Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
          }
        }
      }

      if ($B1Host) {

        if ($Name) {
          $B1Host.display_name = $Name
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
        if ($Tags) {
          if ($B1Host.tags) {
              $B1Host.tags = $Tags
          } else {
              $B1Host | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
          }
        }

        $hostID = $B1Host.id.replace("infra/host/","")

        $splat = $B1Host | Select-Object * -ExcludeProperty configs,created_at | ConvertTo-Json -Depth 10 -Compress
        $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/hosts/$hostID" -Data $splat | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($($Results.id) -eq $($B1Host.id)) {
          Write-Host "Updated BloxOneDDI Host Configuration $($B1Host.display_name) successfuly." -ForegroundColor Green
        } else {
          Write-Host "Failed to update BloxOneDDI Host Configuration on $($B1Host.display_name)." -ForegroundColor Red
        }
      }
    }
}