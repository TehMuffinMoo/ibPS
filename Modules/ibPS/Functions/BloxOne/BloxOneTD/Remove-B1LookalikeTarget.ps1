function Remove-B1LookalikeTarget {
  <#
  .SYNOPSIS
    Remove a lookalike target domain from the account

  .DESCRIPTION
    This function is used to remove a lookalike target domain from the account.

    The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

  .PARAMETER Domain
    This is the domain to be removed from the watched lookalike domain list

  .PARAMETER Force
    Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

  .EXAMPLE
    PS> Remove-B1LookalikeTarget -Domain "mydomain.com"

  .FUNCTIONALITY
    BloxOneDDI

  .FUNCTIONALITY
    Infoblox Threat Defense

  .NOTES
    Credits: Ollie Sheridan
  #>
  [CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact = 'High'
  )]
  param(
    [Parameter(Mandatory=$true)]
    [String[]]$Domain,
    [Switch]$Force
  )
  $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
  $LookalikeTargetList = Get-B1LookalikeTargets

  foreach ($DomainToRemove in $Domain) {

    if ($DomainToRemove -in $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {

      $LookalikeTargetList.items_described = $LookalikeTargetList.items_described | Where-Object {$_.item -ne $($DomainToRemove)}

      $Changed = $true
    } else {
      Write-Host "Lookalike target does not exist: $($DomainToRemove)" -ForegroundColor Yellow
    }
  }
  $JSON = ($LookalikeTargetList | Select-Object items_described | ConvertTo-Json -Depth 5)
  if($PSCmdlet.ShouldProcess("Remove Lookalike Target:`n$($JSON)","Remove Lookalike Target: $($Domain -join ', ')",$MyInvocation.MyCommand)){
    if ($Changed) {
      $null = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method PUT -Data $JSON

      $LookalikeTargetList = Get-B1LookalikeTargets
      foreach ($DomainToRemove in $Domain) {
        if ($DomainToRemove -in $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
          Write-Error "Failed to remove lookalike target: $($DomainToRemove)"
        } else {
          Write-Host "Successfully removed lookalike target: $($DomainToRemove)" -ForegroundColor Green
        }
      }
    }
  }
}