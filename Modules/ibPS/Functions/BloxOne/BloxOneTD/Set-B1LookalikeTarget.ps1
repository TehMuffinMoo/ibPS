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

  .PARAMETER Force
    Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

  .EXAMPLE
    PS> Set-B1LookalikeTarget -Domain "mydomain.com" -Description "New description.."

  .EXAMPLE
    PS> Set-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "New Description 1","New Description 2"

  .EXAMPLE
    PS> Set-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "New Common description"

  .FUNCTIONALITY
    BloxOneDDI

  .FUNCTIONALITY
    Infoblox Threat Defense

  .NOTES
    Credits: Ollie Sheridan
  #>
  [CmdletBinding(
    SupportsShouldProcess,
    ConfirmImpact = 'Medium'
  )]
  param(
    [Parameter(Mandatory=$true)]
    [String[]]$Domain,
    [Parameter(Mandatory=$true)]
    [String[]]$Description,
    [Switch]$Force
  )
  $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
  $LookalikeTargetList = Get-B1LookalikeTargets
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
  $JSON = ($LookalikeTargetList | ConvertTo-Json -Depth 5 -Compress)
  if($PSCmdlet.ShouldProcess("Update Lookalike Targets:`n$(JSONPretty($JSON))","Update Lookalike Targets: $($Domain -join ', ')",$MyInvocation.MyCommand)){
    $null = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method PUT -Data

    $LookalikeTargetList = Get-B1LookalikeTargets
    foreach ($UpdatedLookalike in $UpdatedLookalikes) {
      if ($UpdatedLookalike -notin $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
        Write-Error "Failed to update lookalike target: $($UpdatedLookalike)"
      } else {
        Write-Host "Successfully updated lookalike target: $($UpdatedLookalike)" -ForegroundColor Green
      }
    }
  }
}