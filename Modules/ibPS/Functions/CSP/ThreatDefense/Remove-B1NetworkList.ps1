function Remove-B1NetworkList {
    <#
    .SYNOPSIS
        Removes a network list from Infoblox Threat Defense

    .DESCRIPTION
        This function is used to remove a network list from Infoblox Threat Defense

    .PARAMETER Name
        The name of the network list to remove

    .PARAMETER Object
        The network list object(s) to remove. Accepts pipeline input.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1NetworkList -Name "My Network List"

    .EXAMPLE
        PS> Get-B1NetworkList -Name "My Network List" | Remove-B1NetworkList

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
      DefaultParameterSetName="Default",
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Name,
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
        $NetworkList = Get-B1NetworkList -id $Object.id
      } elseif ($Name) {
        $NetworkList = Get-B1NetworkList -Name $Name -Strict
      } else {
        Write-Error "No network list was specified."
        break
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
        $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists/$($NetworkList.id)"
        $NetworkListCheck = Get-B1NetworkList -id $Object.id -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 6> $null
        if ($NetworkListCheck) {
            Write-Error "Failed to delete network list: $($NetworkList.name)"
        } else {
            Write-Host "Successfully deleted network list: $($NetworkList.name)" -ForegroundColor Green
        }
      }
    }
}