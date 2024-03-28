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

    .PARAMETER Branch
        Use the -Branch parameter to select the github branch to update with. Only works when installed from Github, not from PowerShell Gallery.

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
    [String]$DebugMode,
    [ValidateSet("main", "dev")]
    [String]$Branch
  )

  if ($DevelopmentMode) {
    $Platform = Detect-OS
    $ENV:IBPSDevelopment = $DevelopmentMode
    if ($Platform -eq "Windows") {
      [System.Environment]::SetEnvironmentVariable('IBPSDevelopment',$DevelopmentMode,[System.EnvironmentVariableTarget]::User)
    } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
      if (!(Test-Path ~/.zshenv)) {
        touch ~/.zshenv
      }
      sed -i '' -e '/IBPSDevelopment/d' ~/.zshenv
      echo "export IBPSDevelopment=$DevelopmentMode" >> ~/.zshenv
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
    }
    $ENV:IBPSDebug = $DebugMode
    Write-Host "$($DebugMode) Development Mode." -ForegroundColor Green
  }

  if ($Branch) {
    $Platform = Detect-OS
    if ($Platform -eq "Windows") {
      [System.Environment]::SetEnvironmentVariable('IBPSBranch',$Branch,[System.EnvironmentVariableTarget]::User)
    } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
      if (!(Test-Path ~/.zshenv)) {
        touch ~/.zshenv
      }
      sed -i '' -e '/IBPSBranch/d' ~/.zshenv
      echo "export IBPSBranch=$Branch" >> ~/.zshenv
    }
    $ENV:IBPSBranch = $Branch
  }
}