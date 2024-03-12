function New-B1TDLookalikeTarget {
  <#
  .SYNOPSIS
    Adds a new lookalike target domain for the account

  .DESCRIPTION
    This function is used to add a new lookalike target domain for the account.
    
    The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

  .PARAMETER Domain
    This is the domain to be added to the watched lookalike domain list

  .PARAMETER Description
    The description to apply to the above domain

  .EXAMPLE
    PS> New-B1TDLookalikeTarget -Domain "mydomain.com" -Description "Some description.." 
    
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
    [Parameter(Mandatory=$false)]
    [String[]]$Description
  )

  $LookalikeTargetList = Get-B1TDLookalikeTargets

  if ($Domain -notin $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
    $NewLookalike = @{
      "item" = $Domain
      "description" = $Description
    }

    $LookalikeTargetList.items_described += $NewLookalike

    Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method PUT -Data ($LookalikeTargetList | ConvertTo-Json -Depth 5)

    if ($Domain -notin $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
      Write-Error "Failed to create new lookalike target: $($Domain)"
    } else {
      Write-Host "Successfully created new lookalike target: $($Domain)" -ForegroundColor Green
    }
  } else {
    Write-Host "Lookalike target already exists: $($Domain)" -ForegroundColor Yellow
  }
}