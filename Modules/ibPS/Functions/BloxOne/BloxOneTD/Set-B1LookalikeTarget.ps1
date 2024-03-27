function Set-B1LookalikeTarget {
  <#
  .SYNOPSIS
    Updates an existing lookalike target domain for the account

  .DESCRIPTION
    This function is used to update an existing lookalike target domain for the account.
    
    The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

  .PARAMETER Domain
    This is the domain to be updated from the watched lookalike domain list

  .PARAMETER Description
    The updated description from the selected domain

  .EXAMPLE
    PS> Set-B1LookalikeTarget -Domain "mydomain.com" -Description "New description.." 

  .EXAMPLE
    PS> Set-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "New Description 1","New Description 2"

  .EXAMPLE
    PS> Set-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "New Common description"
    
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
    [Parameter(Mandatory=$true)]
    [String[]]$Description
  )

  $LookalikeTargetList = Get-B1LookalikeTarget
  $UpdatedLookalikes = @()

  if ($Domain.Count -gt 1) {
    if ($Description.Count -eq 1) {
      Write-Host "Only one description submitted. The same description will be used for all updated target domains." -ForegroundColor Yellow
    } else {
      if ($Description -and ($Domain.Count -ne $Description.Count)) {
        Write-Host "Domains: $($Domain.Count) - Descriptions: $($Description.Count)"
        Write-Error "Number of values submitted to -Domain and -Description do not match"
        break
      }
    }
  }

  foreach ($UpdatedDomain in $Domain) {
    if ($UpdatedDomain -in $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
      
      ($LookalikeTargetList | Select-Object -ExpandProperty items_described | Where-Object {$_.item -eq $UpdatedDomain}).description = if ($Description.Count -le 1) {$Description} else {$Description[$Domain.IndexOf($UpdatedDomain)]}
      $UpdatedLookalikes += $UpdatedDomain
    } else {
      Write-Host "Lookalike target already exists: $($NewDomain)" -ForegroundColor Yellow
    }
  }

  $Result = Query-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method PUT -Data ($LookalikeTargetList | ConvertTo-Json -Depth 5)

  $LookalikeTargetList = Get-B1LookalikeTarget
  foreach ($UpdatedLookalike in $UpdatedLookalikes) {
    if ($UpdatedLookalike -notin $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
      Write-Error "Failed to update lookalike target: $($UpdatedLookalike)"
    } else {
      Write-Host "Successfully updated lookalike target: $($UpdatedLookalike)" -ForegroundColor Green
    }
  }
}