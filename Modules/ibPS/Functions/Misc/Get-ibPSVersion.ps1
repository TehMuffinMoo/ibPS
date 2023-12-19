function Get-ibPSVersion {
    <#
    .SYNOPSIS
        Checks the version of ibPS, with the option to update if a version is available

    .DESCRIPTION
        This function is used check the current version of ibPS, with the option to check for updates and update if a version is available

    .PARAMETER CheckForUpdates
        This switch indicates you want to check for new versions

    .PARAMETER Update
        This switch will perform an upgrade if one is available

    .PARAMETER Details
        This switch will return installation details, such as module location and install type

    .PARAMETER Force
        This switch will force an update, whether or not one is available

    .EXAMPLE
        Get-ibPSVersion

    .EXAMPLE
        Get-ibPSVersion -CheckForUpdates

    .EXAMPLE
        Get-ibPSVersion -Update
    
    .FUNCTIONALITY
        ibPS
    #>
  param (
    [Switch]$CheckForUpdates,
    [Switch]$Update,
    [Switch]$Details,
    [Switch]$Force
  )
  $PSGalleryModule = Get-InstalledModule -Name ibPS -EA SilentlyContinue -WA SilentlyContinue
  if ($PSGalleryModule) {
    [System.Version]$CurrentVersion = $PSGalleryModule.Version.ToString()
  } else {
    [System.Version]$CurrentVersion = (Get-Module -ListAvailable -Name ibPS).Version.ToString()
  }
  if ($CheckForUpdates -or $Update) {
    if ($PSGalleryModule) {
      [System.Version]$LatestVersion = (Find-Module -Name ibPS | Where-Object {$_.CompanyName -eq "TehMuffinMoo"}).Version.ToString()
      if (($LatestVersion -gt $CurrentVersion) -or $Force) {
        if ($Force) {
          Write-Host "Forcing update. Current Version: $($CurrentVersion) - Latest Version: $($LatestVersion)" -BackgroundColor DarkRed -ForegroundColor Yellow
          Update-Module ibPS -Force
        } else {
          Write-Host "New version available! Current Version: $($CurrentVersion) - Latest Version: $($LatestVersion)" -BackgroundColor Yellow -ForegroundColor DarkGreen
          if ($Update) {
            Update-Module ibPS
          }
        }
      } else {
        Write-Host "ibPS is up to date! Current Version: $CurrentVersion - Latest Version: $LatestVersion" -BackgroundColor Green -ForegroundColor Blue
      }
    } else {
      $ModuleManifest = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TehMuffinMoo/ibPS/main/Modules/ibPS/ibPS.psd1" -Headers @{"Cache-Control"="no-cache"}
      if ($ModuleManifest) {
        [System.Version]$LatestVersion = ($ModuleManifest.RawContent | Select-String -Pattern 'ModuleVersion\s\=\s(.*)').Matches.Groups[1].Value -replace "'",""
        if (($LatestVersion -gt $CurrentVersion) -or $Force) {
          if ($Force) {
            Write-Host "Forcing update. Current Version: $($CurrentVersion) - Latest Version: $($LatestVersion)" -BackgroundColor DarkRed -ForegroundColor Yellow
          } else {
            Write-Host "New version available! Current Version: $($CurrentVersion) - Latest Version: $($LatestVersion)" -BackgroundColor Yellow -ForegroundColor DarkGreen
          }
          if ($Update) {
            Write-Warning "Confirmation: Do you want to proceed with updating from v$($CurrentVersion) to v$($LatestVersion)?" -WarningAction Inquire
            Invoke-WebRequest -Uri "https://github.com/TehMuffinMoo/ibPS/archive/refs/heads/main.zip" -OutFile ibPS.zip -Headers @{"Cache-Control"="no-cache"}
            if (Test-Path ibPS.zip) {
              Expand-Archive ibPS.zip
            }
            if (Test-Path ibPS) {
              $ModulePath = (Get-Module -ListAvailable -Name ibPS).Path
              $Platform = Detect-OS
              if ($Platform -eq "Windows") {
                if ($ModulePath -like "$ENV:USERPROFILE\*") {
                  $Selection = "i"
                } elseif ($ModulePath -like "C:\Windows\System32\WindowsPowerShell\*") {
                  $Selection = "g"
                }
              }
              if ($Platform -eq "Mac" -or $Platform -eq "Unix") {
                if ($ModulePath -like "$($ENV:HOME)/*") {
                  $Selection = "i"
                } elseif ($ModulePath -like "/usr/local/*") {
                  $Selection = "g"
                }
              }
              Set-Location ibPS/ibPS-main
              .\Install.ps1 -Selection $Selection
            }
            Set-Location ../../
            Remove-Item ibPS,ibPS.zip -Recurse -Force
            if ($CurrentVersion = (Get-Module -ListAvailable -Name ibPS).Version.ToString() -eq $LatestVersion) {
              Write-Host "Successfully updated ibPS to latest version: $LatestVersion" -ForegroundColor Green
            } else {
              Write-Error "Failed to update ibPS to latest version. Current Version: $CurrentVersion"
            }
          }
        } else {
          Write-Host "ibPS is up to date! Current Version: $CurrentVersion - Latest Version: $LatestVersion" -BackgroundColor Green -ForegroundColor Blue
        }
      } else {
        Write-Error "Unable to retrieve latest version information from Github."
      }
    }
  } else {
    if ($Details) {
      return @{
        "Version" = $CurrentVersion.ToString()
        "Install Type" = $(if ($PSGalleryModule) { "Powershell Gallery" } else { "Local"})
        "Install Path" = (Get-Module -ListAvailable -Name ibPS).Path
      } | ConvertTo-Json | ConvertFrom-Json | Select-Object "Version","Install Type","Install Path"
    } else {
      return $CurrentVersion.ToString()
    }
  }
}