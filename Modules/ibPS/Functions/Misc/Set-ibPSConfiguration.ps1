function Set-ibPSConfiguration {
    <#
    .SYNOPSIS
        Used to set ibPS specific configuration

    .DESCRIPTION
        This function is used to set ibPS specific configuration, such as enabling development or debug mode

    .PARAMETER DevelopmentMode
        Enabling development mode will expose additional functions to allow development of new cmdlets

    .PARAMETER DebugMode
        Enabling Debug Mode will return additional debug data when using the module

    .EXAMPLE
        Set-ibPSConfiguration -DebugMode Enabled

    .EXAMPLE
        Set-ibPSConfiguration -DevelopmentMode Enabled

    .FUNCTIONALITY
        ibPS
    #>
  param (
    [ValidateSet('Enabled','Disabled')]
    [String]$DevelopmentMode,
    [ValidateSet('Enabled','Disabled')]
    [String]$DebugMode
  )

  if ($DevelopmentMode) {
    $Platform = Detect-OS
    if ($Platform -eq "Windows") {
      [System.Environment]::SetEnvironmentVariable('IBPSDevelopment',$DevelopmentMode,[System.EnvironmentVariableTarget]::User)
    } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
      if (!(Test-Path ~/.zshenv)) {
        touch ~/.zshenv
      }
      sed -i '' -e '/IBPSDevelopment/d' ~/.zshenv
      echo "export IBPSDevelopment=$DevelopmentMode" >> ~/.zshenv
      $ENV:IBPSDevelopment = $DevelopmentMode
    }
    if ($DevelopmentMode -eq 'Enabled') {
      Write-Host "Enabling Development Mode.." -ForegroundColor Cyan
      $ModulePath = (Get-Module ibPS -ListAvailable).Path
      $Keys = (Test-ModuleManifest $ModulePath).ExportedCommands.Keys
      $Keys += DevelopmentFunctions
      Update-ModuleManifest $ModulePath -FunctionsToExport $Keys
      Import-Module $ModulePath -Force -DisableNameChecking
      Write-Host "Enabled Development Mode. A restart of the Powershell session is required for this to take effect." -ForegroundColor Green
    } elseif ($DevelopmentMode -eq 'Disabled') {
      Write-Host "Disabling Development Mode.." -ForegroundColor Cyan
      $ModulePath = (Get-Module ibPS -ListAvailable).Path
      $Keys = (Test-ModuleManifest $ModulePath).ExportedCommands.Keys | Where-Object {$_ -notin $(DevelopmentFunctions)}
      Update-ModuleManifest $ModulePath -FunctionsToExport $Keys
      Import-Module $ModulePath -Force -DisableNameChecking
      Write-Host "Disabled Development Mode. A restart of the Powershell session may be required for this to take effect." -ForegroundColor Green
    }
  }

  if ($DebugMode) {
    $Platform = Detect-OS
    if ($Platform -eq "Windows") {
      [System.Environment]::SetEnvironmentVariable('IBPSDebug',$DebugMode,[System.EnvironmentVariableTarget]::User)
    } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
      if (!(Test-Path ~/.zshenv)) {
        touch ~/.zshenv
      }
      sed -i '' -e '/IBPSDebug/d' ~/.zshenv
      echo "export IBPSDebug=$DebugMode" >> ~/.zshenv
      $ENV:IBPSDebug = $DebugMode
    }
    Write-Host "$($DebugMode) Development Mode." -ForegroundColor Green
  }

}