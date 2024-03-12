function Remove-B1TDLookalikeTarget {
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
    PS> Remove-B1TDLookalikeTarget -Domain "mydomain.com"
    
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

  $LookalikeTargetList = Get-B1TDLookalikeTargets

  if ($Domain -in $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {

    $LookalikeTargetList.items_described = $LookalikeTargetList.items_described | Where-Object {$_.item -ne $($Domain)}
    
    if (!$NoWarning) {
        Write-Warning "Are you sure you want to delete: $($Domain)?" -WarningAction Inquire
    }

    Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method PUT -Data ($LookalikeTargetList | Select-Object items_described | ConvertTo-Json -Depth 5)

    if ($Domain -in $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
      Write-Error "Failed to remove lookalike target: $($Domain)"
    } else {
      Write-Host "Successfully removed lookalike target: $($Domain)" -ForegroundColor Green
    }
  } else {
    Write-Host "Lookalike target does not exist: $($Domain)" -ForegroundColor Yellow
  }
}