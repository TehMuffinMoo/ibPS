param(
  $Selection
)

$ibPSDir = $PSScriptRoot

. $ibPSDir\Modules\ibPS\Functions\BloxOneDDI\Private\Misc.ps1

$Platform = Detect-OS

if ($Platform -eq "Windows") {
  $UserDocuments = "$ENV:USERPROFILE\Documents"
  $UserModuleDirectory = "$UserDocuments\WindowsPowerShell\Modules"
  $GlobalModuleDirectory = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"

  $elevated = ([Security.Principal.WindowsPrincipal] `
  [Security.Principal.WindowsIdentity]::GetCurrent()
 ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) 
}

if ($Platform -eq "Mac" -or $Platform -eq "Unix") {
  $UserDocuments = "$ENV:HOME/.local/share"
  $UserModuleDirectory = "$UserDocuments/powershell/Modules"
  $GlobalModuleDirectory = "/usr/local/microsoft/powershell/7/Modules"
  if ($(whoami) -eq "root") {
    $elevated = $true
  }
}

## Context Menu
function Context-Menu {
    param (
        [string]$Title = 'ibPS Installation Menu'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "i: Press 'i' to install ibPS as current user."
    Write-Host "g: Press 'g' to install globally (Must be run as Administrator/Sudo)."
    Write-Host "r: Press 'r' to uninstall ibPS from current user."
    Write-Host "u: Press 'a' to uninstall ibPS globally."
    Write-Host "Q: Press 'Q' to quit."
}

## Show Menu
do {
    if (!$Selection) {
      Context-Menu
      $selection = Read-Host "Please make a selection"
      $endwheninstalled = $false
    } else {
      $endwheninstalled = $true
    }
    switch ($selection)
    {
      'i' {
        Write-Host "Installing ibPS for current user.." -ForegroundColor Yellow

        if ($Platform -eq "Windows") {
          if (!(Test-Path "$UserDocuments\WindowsPowerShell")) {
              New-Item -ItemType Directory -Name "WindowsPowershell" -Path $UserDocuments
          }
          if (!(Test-Path $UserModuleDirectory)) {
              New-Item -ItemType Directory -Name "Modules" -Path "$UserDocuments\WindowsPowerShell"
          }
        }

        if ($Platform -eq "Mac" -or $Platform -eq "Unix") {
          if (!(Test-Path "$UserDocuments/powershell")) {
              New-Item -ItemType Directory -Name "powershell" -Path $UserDocuments
          }
          if (!(Test-Path $UserModuleDirectory)) {
              New-Item -ItemType Directory -Name "Modules" -Path "$UserDocuments\powershell"
          }
        }

        if (Test-Path "$UserModuleDirectory\ibPS") {
            Write-Host "Found existing version, removing.." -ForegroundColor Yellow
            Remove-Item "$UserModuleDirectory\ibPS" -Recurse -Force
        }
        Copy-Item "$ibPSDir\Modules\ibPS" $UserModuleDirectory -Recurse -Force
        if ($env:PSModulePath -notlike "*$UserModuleDirectory*") {
            Write-Host "Adding $UserModuleDirectory to PSModulePath" -ForegroundColor Yellow
            $PSModuleDirectories = $env:PSModulePath += ";$UserModuleDirectory"
            [System.Environment]::SetEnvironmentVariable('PSModulePath',$PSModuleDirectories,[System.EnvironmentVariableTarget]::User)
        }
        Get-Module ibPS -ListAvailable | Import-Module -DisableNameChecking -Force
        if (Test-Path "$UserModuleDirectory\ibPS") {
            Write-Host "File installation succeeded." -ForegroundColor Green
            if (Get-ibPSVersion) {
                Write-Host "Module loaded successfully." -ForegroundColor Green
            } else {
                Write-Host "Module failed to load." -ForegroundColor Red
            }
        } else {
            Write-Host "File installation failed." -ForegroundColor Red
        }
      }
      'g' {
        if (!($elevated)) {
            Write-Host "You must run this script as an administrator/sudo to install ibPS globally." -ForegroundColor Red
            break      
        } else {
              Write-Host "Installing ibPS Globally.." -ForegroundColor Yellow
              if (!(Test-Path "$GlobalModuleDirectory")) {
                  Write-Host "Failed to locate global module directory: $GlobalModuleDirectory"
              }
        }
        if (Test-Path "$GlobalModuleDirectory\ibPS") {
            Write-Host "Found existing version, removing.." -ForegroundColor Yellow
            Remove-Item "$GlobalModuleDirectory\ibPS" -Recurse -Force
        }
        Copy-Item "$ibPSDir\Modules\ibPS" $GlobalModuleDirectory -Recurse -Force
        Get-Module ibPS -ListAvailable | Import-Module -DisableNameChecking -Force
          if (Test-Path "$GlobalModuleDirectory\ibPS") {
              Write-Host "File installation succeeded." -ForegroundColor Green
              if (Get-ibPSVersion) {
                  Write-Host "Module loaded successfully." -ForegroundColor Green
              } else {
                  Write-Host "Module failed to load." -ForegroundColor Red
              }
          } else {
              Write-Host "File installation failed." -ForegroundColor Red
          }
      }
      'r' {
        Write-Host "Uninstalling ibPS from current user.." -ForegroundColor Yellow
        if (!(Test-Path "$UserModuleDirectory\ibPS" -ErrorAction SilentlyContinue)) {
            Write-Host "Failed to locate ibPS module directory: $UserModuleDirectory\ibPS"
        } else {
            Remove-Item "$UserModuleDirectory\ibPS" -Recurse -Force
            if (!(Test-Path "$UserModuleDirectory\ibPS")) {
                Write-Host "ibPS uninstall succeeded." -ForegroundColor Green
            } else {
                Write-Host "ibPS uninstall failed." -ForegroundColor Red
            }
        }
      } 
      'a' {
        if (!($elevated)) {
            Write-Host "You must run this script as an administrator to uninstall ibPS globally." -ForegroundColor Red
        } else {
            Write-Host "Uninstalling ibPS Globally.." -ForegroundColor Yellow
            if (!(Test-Path "$GlobalModuleDirectory\ibPS")) {
                Write-Host "Failed to locate ibPS module directory: $GlobalModuleDirectory\ibPS"
            } else {
                Remove-Item "$GlobalModuleDirectory\ibPS" -Recurse -Force
                if (!(Test-Path "$GlobalModuleDirectory\ibPS")) {
                    Write-Host "ibPS uninstall succeeded." -ForegroundColor Green
                } else {
                    Write-Host "ibPS uninstall failed." -ForegroundColor Red
                }
            }
        }
      } 
    }
    if ($endwheninstalled -or $Selection -eq "q") {
      $selection = "q"
    } else {
      $Selection = $null
      pause
    }
 }
 until ($selection -eq 'q')