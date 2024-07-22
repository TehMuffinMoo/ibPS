function New-B1LookalikeTarget {
  <#
  .SYNOPSIS
    Adds a new lookalike target domain for the account

  .DESCRIPTION
    This function is used to add a new lookalike target domain for the account.

    The Lookalike Target Domains are second-level domains BloxOne uses to detect lookalike FQDNs against, i.e the list of defined lookalike domains to monitor.

  .PARAMETER Domain
    This is the domain to be added to the watched lookalike domain list

  .PARAMETER Description
    The description to apply to the selected domain

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

  .EXAMPLE
    PS> New-B1LookalikeTarget -Domain "mydomain.com" -Description "Some description.."

  .EXAMPLE
    PS> New-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "Description 1","Description 2"

  .EXAMPLE
    PS> New-B1LookalikeTarget -Domain "mydomain.com","seconddomain.com" -Description "Common description"

  .FUNCTIONALITY
    BloxOneDDI

  .FUNCTIONALITY
    BloxOne Threat Defense

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
    [Parameter(Mandatory=$false)]
    [String[]]$Description,
    [Switch]$Force
  )
  $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
  $LookalikeTargetList = Get-B1LookalikeTargets
  $NewLookalikes = @()

  if ($Domain.Count -gt 1) {
    if ($Description.Count -eq 1) {
      Write-Host "Only one description submitted. The same description will be used for all new target domains." -ForegroundColor Yellow
    } else {
      if ($Description -and ($Domain.Count -ne $Description.Count)) {
        Write-Host "Domains: $($Domain.Count) - Descriptions: $($Description.Count)"
        Write-Error "Number of values submitted to -Domain and -Description do not match"
        break
      }
    }
  }

  foreach ($NewDomain in $Domain) {
    if ($NewDomain -notin $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
      $NewEntry = @{
        "item" = $NewDomain
        "description" = if ($Description.Count -le 1) {$Description} else {$Description[$Domain.IndexOf($NewDomain)]}
      }
      $LookalikeTargetList.items_described += $NewEntry
      $NewLookalikes += $NewDomain
    } else {
      Write-Host "Lookalike target already exists: $($NewDomain)" -ForegroundColor Yellow
    }
  }
  $JSON = ($LookalikeTargetList | ConvertTo-Json -Depth 5)
  if($PSCmdlet.ShouldProcess("Create new Lookalike Target:`n$($JSON)","Create new Lookalike Target: $($Domain)",$MyInvocation.MyCommand)){
    $null = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/tdlad/v1/lookalike_targets" -Method PUT -Data 

    $LookalikeTargetList = Get-B1LookalikeTargets
    foreach ($NewLookalike in $NewLookalikes) {
      if ($NewLookalike -notin $($LookalikeTargetList | Select-Object -ExpandProperty items_described | Select-Object -ExpandProperty item)) {
        Write-Error "Failed to create new lookalike target: $($NewLookalike)"
      } else {
        Write-Host "Successfully created new lookalike target: $($NewLookalike)" -ForegroundColor Green
        $($LookalikeTargetList) | Select-Object -ExpandProperty items_described | Where-Object {$_.item -eq $NewLookalike}
      }
    }
  }

}