function Remove-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Removes a Infoblox Threat Defense Security Policy

    .DESCRIPTION
        This function is used to remove a Infoblox Threat Defense Security Policy

    .PARAMETER Object
        The Infoblox Threat Defense Security Policy Object(s) to remove. Accepts pipeline input

    .PARAMETER Name
        The name of the Infoblox Threat Defense Security Policy to delete.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1SecurityPolicy -Name "Remote Users"

    .EXAMPLE
        PS> Get-B1SecurityPolicy -Name "Remote Users" | Remove-B1SecurityPolicy

    .FUNCTIONALITY
        BloxOneDDI

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
      if ($Name) {
        $SecurityPolicy = Get-B1SecurityPolicy -Name $Name -Strict
      } elseif ($Object) {
        $SecurityPolicy = Get-B1SecurityPolicy -id $Object.id
      } else {
        Write-Error "No security policy was selected."
        break
      }
      if (($SecurityPolicy).Count -gt 1) {
        Write-Error "More than one Security Policy returned. To remove multiple objects, you should use pipe Get-B1SecurityPolicy into Remove-B1SecurityPolicy instead."
        break
      }
      if ($SecurityPolicy) {
        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
          $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies/$($SecurityPolicy.id)"
          if ($Name) {
              $SecurityPolicyCheck = Get-B1SecurityPolicy -Name $Name -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
          } elseif ($id) {
              $SecurityPolicyCheck = Get-B1SecurityPolicy -id $($Object.id) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 6> $null
          }
          if ($SecurityPolicyCheck) {
              Write-Error "Failed to delete security policy: $($SecurityPolicy.name)"
          } else {
              Write-Host "Successfully deleted security policy: $($SecurityPolicy.name)" -ForegroundColor Green
          }
        }
      } else {
        Write-Error "Unable to find security policy."
      }
    }
}