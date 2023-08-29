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

    .Example
        Set-B1Host -Name "bloxoneddihost1.mydomain.corp" -IP "10.10.20.11" -TimeZone "Europe/London" -Space "Global"
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
    param(
      [String]$Name,
      [String]$IP,
      [String]$Space,
      [String]$TimeZone,
      [String]$Description,
      [switch]$NoIPSpace,
      [System.Object]$Tags
    )
    if ($IP) {
        if ($NoIPSpace) {
            $OnPremHost = Get-B1Host -IP $IP -NoIPSpace:$NoIPSpace
        } else {
            $OnPremHost = Get-B1Host -IP $IP -Space $Space
        }
        if (!($OnPremHost)) {
            Write-Host "On-Prem Host $IP does not exist." -ForegroundColor Gray
        } else {
          $hostID = $OnPremHost.id
        }
    } elseif ($Name) {
        if ($NoIPSpace) {
            $OnPremHost = Get-B1Host -Name $Name -NoIPSpace:$NoIPSpace
        } else {
            $OnPremHost = Get-B1Host -Name $Name -Space $Space
        }
        if (!($OnPremHost)) {
            Write-Host "On-Prem Host $Name does not exist." -ForegroundColor Gray
        } else {
          $hostID = $OnPremHost.id
        }
    }
    $OnPremHost.display_name = $Name
    if ($TimeZone) {$OnPremHost.timezone = $TimeZone}
    if ($Space) {
        if ($OnPremHost.ip_space) {
            $OnPremHost.ip_space = (Get-B1Space -Name $Space -Strict).id
        } else {
            $OnPremHost | Add-Member -MemberType NoteProperty -Name "ip_space" -Value (Get-B1Space -Name $Space -Strict).id
        }
    }
    if ($Description) {
        if ($OnPremHost.description) {
            $OnPremHost.description = $Description
        } else {
            $OnPremHost | Add-Member -MemberType NoteProperty -Name "description" -Value $Description
        }
    }
    if ($Tags) {
        if ($OnPremHost.tags) {
            $OnPremHost.tags = $Tags
        } else {
            $OnPremHost | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }
    }

    $hostID = $hostID.replace("infra/host/","")

    $splat = $OnPremHost | select * -ExcludeProperty configs,created_at | ConvertTo-Json -Depth 10 -Compress
    if ($Debug) {$splat}
    $Results = Query-CSP -Method PUT -Uri "https://csp.infoblox.com/api/infra/v1/hosts/$hostID" -Data $splat | select -ExpandProperty result -ErrorAction SilentlyContinue
    if ($Results.display_name -eq $Name) {
        Write-Host "Updated BloxOneDDI Host Configuration $Name successfuly." -ForegroundColor Green
    } else {
        Write-Host "Failed to update BloxOneDDI Host Configuration on $Name." -ForegroundColor Red
    }

}