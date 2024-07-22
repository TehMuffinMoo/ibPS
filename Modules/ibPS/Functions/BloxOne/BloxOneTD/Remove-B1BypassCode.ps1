function Remove-B1BypassCode {
    <#
    .SYNOPSIS
        Removes a bypass code from BloxOne Cloud

    .DESCRIPTION
        This function is used to remove a bypass code from BloxOne Cloud

    .PARAMETER Name
        The name of the bypass code to remove

    .PARAMETER Object
        The bypass code object(s) to remove. Accepts pipeline input from Get-B1BypassCode

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1BypassCode -Name 'My Bypass Code' | Remove-B1BypassCode

        Successfully deleted Bypass Code: My Bypass Code

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(Mandatory=$true,ParameterSetName="Default")]
      [String]$Name,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Pipeline",
        Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      if (!($Object)) {
        $Object = (Get-B1BypassCode -Name $Name -Strict).access_key
        if (!($Object)) {
          Write-Error "Unable to find Bypass Code with name: $($Name)"
          break
        }
      } else {
        if (!($Object.access_key)) {
          Write-Error "Error. Unsupported pipeline object. This function only supports objects from Get-B1BypassCode as input."
          break
        }
      }
      if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.access_key))")){
        $Result = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/access_codes/$($Object.access_key)"
        if (Get-B1BypassCode -Name $Name -Strict -EA SilentlyContinue -WA SilentlyContinue) {
          Write-Error "Failed to delete Bypass Code: $($Object.name) ($($Object.access_key))"
          break
        } else {
          Write-Host "Successfully deleted Bypass Code: $($Object.name) ($($Object.access_key))" -ForegroundColor Green
        }
      }
    }
}