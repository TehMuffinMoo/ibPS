function DeprecationNotice {
    param (
      $Date,
      $Command,
      $AlternateCommand
    )
    $ParsedDate = [datetime]::parseexact($Date, 'dd/MM/yy', $null)
    if ($ParsedDate -gt (Get-Date)) {
      Write-Host "Cmdlet Deprecation Notice! $Command will be deprecated on $Date. Please switch to using $AlternateCommand before this date." -ForegroundColor Yellow
    } else {
      Write-Host "Cmdlet was deprecated on $Date. $Command will likely no longer work. Please switch to using $AlternateCommand instead." -ForegroundColor Red
    }
  }