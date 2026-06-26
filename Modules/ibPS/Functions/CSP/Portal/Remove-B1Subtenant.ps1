function Remove-B1Subtenant {
    <#
    .SYNOPSIS
        Removes an existing Infoblox Portal Subtenant

    .DESCRIPTION
        This function is used to remove an existing Infoblox Portal Subtenant

    .PARAMETER Name
        The name of the Infoblox Portal Subtenant to remove

    .PARAMETER Object
        The Infoblox Portal Subtenant Object(s) to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Subtenant -Name "My Subtenant"

    .EXAMPLE
        PS> Get-B1Subtenant -Name "My Subtenant" | Remove-B1Subtenant

    .FUNCTIONALITY
        NIOS-X

    .FUNCTIONALITY
        Service
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
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
      if ($Object) {
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "identity/accounts") {
            Write-Error "Error. Unsupported pipeline object. This function only supports 'identity/accounts' objects as input"
            return $null
          } else {
            $SubtenantID = $SplitID[2]
          }
      } else {
          $Object = Get-B1Subtenant -Name $Name -Strict
          if ($Object.count -gt 1) {
              Write-Error "Error. Multiple subtenants found with the name: $($Name). Please use pipeline input."
              return $null
          }
          $SplitID = $Object.id.split('/')
          if (!($Object)) {
              Write-Error "Unable to find Subtenant: $($Name)"
              return $null
          }
          $SubtenantID = $SplitID[2]
      }

      if($PSCmdlet.ShouldProcess("$($Object.name) ($($SubtenantID))")){
        Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/v2/sandbox/accounts/$($SubtenantID)" | Out-Null
        $B1Subtenant = Get-B1Subtenant -id $($Object.id)
        if ($B1Subtenant) {
          Write-Host "Failed to delete subtenant: $($B1Subtenant.name)" -ForegroundColor Red
        } else {
          Write-Host "Subtenant deleted successfully: $($Object.name)." -ForegroundColor Green
        }
      }
    }
}