function Remove-B1LookalikeTarget {
  <#
  .SYNOPSIS
    Remove a lookalike target domain from the account

  .DESCRIPTION
    This function is used to remove a lookalike target domain from the account.

    The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

  .PARAMETER Domain
    This is the domain to be removed from the watched lookalike domain list

  .PARAMETER NoWarning
    Using -NoWarning will stop warnings prior to deleting a lookalike

  .EXAMPLE
    PS> Remove-B1LookalikeTarget -Domain "mydomain.com"

  .FUNCTIONALITY
    BloxOneDDI

  .FUNCTIONALITY
    BloxOne Threat Defense

  .NOTES
    Credits: Ollie Sheridan
  #>

  param(
    [Parameter(Mandatory=$true)]
    [String[]]$Domain,
    [Switch]$NoWarning
  )

  $LookalikeTargetList = Get-B1LookalikeTargets

  foreach ($DomainToRemove in $Domain) {

    if ($DomainToRemove -in $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {

      $LookalikeTargetList.items_described = $LookalikeTargetList.items_described | Where-Object {$_.item -ne $($DomainToRemove)}

      if (!$NoWarning) {
          Write-Warning "Are you sure you want to delete: $($Domain)?" -WarningAction Inquire
      }

      $Changed = $true
    } else {
      Write-Host "Lookalike target does not exist: $($DomainToRemove)" -ForegroundColor Yellow
    }
  }

  if ($Changed) {
    $Result = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method PUT -Data ($LookalikeTargetList | Select-Object items_described | ConvertTo-Json -Depth 5)

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