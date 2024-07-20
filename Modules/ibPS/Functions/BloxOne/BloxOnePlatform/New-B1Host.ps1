function New-B1Host {
    <#
    .SYNOPSIS
        Creates a new BloxOneDDI Host

    .DESCRIPTION
        This function is used to create a new BloxOneDDI Host

    .PARAMETER Name
        The name of the BloxOneDDI host to create

    .PARAMETER Space
        The IPAM space where the BloxOneDDI host should be placed

    .PARAMETER Description
        The description of the new BloxOneDDI Host

    .PARAMETER Location
        The Location for the new BloxOne Host.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1Host -Name "bloxoneddihost1.mydomain.corp" -Description "My BloxOneDDI Host" -Space "Global"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [Parameter(Mandatory=$true)]
      [String]$Space,
      [String]$Location,
      [String]$Description,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    if (Get-B1Host -Name $Name -Strict) {
        Write-Host "$Name already exists as an On-Prem host." -ForegroundColor Red
        break
    }

    $splat = @{
        "display_name" = $Name
        "ip_space" = (Get-B1Space -Name $Space -Strict).id
        "description" = $Description
    }

    if ($Location) {
      $LocationID = (Get-B1Location -Name $Location -Strict).id
      if ($LocationID) {
        $splat.location_id = $LocationID
      } else {
        Write-Error "Unable to find Location: $($Location)"
        return $null
      }
    }

    $JSON = $splat | ConvertTo-Json
    if($PSCmdlet.ShouldProcess("Create new BloxOne Host:`n$($JSON)","Create new BloxOne Host",$MyInvocation.MyCommand)){
        $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/infra/v1/hosts" -Data $JSON | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        $Result
        if ($Result.display_name -eq $Name) {
            Write-Host "On-Prem host $Name created successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to create On-Prem host $Name." -ForegroundColor Red
        }
    }
}