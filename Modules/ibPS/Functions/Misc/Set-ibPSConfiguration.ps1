function Set-ibPSConfiguration {
    <#
    .SYNOPSIS
        Used to set ibPS specific configuration

    .DESCRIPTION
        This function is used to set ibPS specific configuration, such as the BloxOne CSP API Key, Region/URL and enabling/disabling development or debug mode

    .PARAMETER CSPAPIKey
        This is the BloxOneDDI API Key retrieves from the Cloud Services Portal

    .PARAMETER CSPRegion
        Optionally configure the the CSP Region to use (i.e EU for the EMEA instance). The region defaults to US if not defined. You only need to use -CSPRegion OR -CSPUrl.

    .PARAMETER CSPUrl
        Optionally configure the the CSP URL to use manually. The CSP URL defaults to https://csp.infoblox.com if not defined. You only need to use -CSPUrl OR -CSPRegion.

    .PARAMETER DoHServer
        Optionally configure the DNS over HTTPS Server to use when calling Resolve-DoHQuery

    .PARAMETER Persist
        Setting the -Persist parameter will save the configuration permanently for your user on this device. Without using this switch, the settings will only be saved for the duration of the PowerShell session.

    .PARAMETER DevelopmentMode
        Enabling development mode will expose additional functions to allow development of new cmdlets. Enabling development mode will always apply as a persistent setting until it is disabled. This is because in some cases it may require a restart of the PowerShell session to fully enable.

    .PARAMETER DebugMode
        Enabling Debug Mode will return additional debug data when using the module.  Enabling debug mode will always apply as a persistent setting until it is disabled. This is because in some cases it may require a restart of the PowerShell session to fully enable.

    .PARAMETER Telemetry
        Disabling Telemetry will prevent the module sending diagnostic information to Google Analytics. None of the diagnostic information sent contains any sensitive information, only the name of the executed function, any error associated error categories and source platform information (OS/Version).

    .EXAMPLE
        PS> Set-ibPSConfiguration -CSPAPIKey 'longapikeygoeshere' -Persist

        BloxOne API key has been stored permanently for user on MAC-DSD984HG

    .EXAMPLE
        PS> Set-ibPSConfiguration -CSPRegion EU

        BloxOne CSP URL (https://csp.eu.infoblox.com) has been stored for this session.
        You can make the CSP URL persistent for this user on this machine by using the -persist parameter.

    .EXAMPLE
        PS> Set-ibPSConfiguration -DebugMode Enabled -DevelopmentMode Enabled

    .FUNCTIONALITY
        ibPS
    #>
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification='Required to obtain API Key')]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', 'echo', Justification = 'echo required for Mac/Unix')]
  [CmdletBinding()]
  param (
    [String]$CSPAPIKey,
    [ValidateSet("US","EU")]
    [String]$CSPRegion,
    [String]$CSPUrl,
    [String]$DoHServer,
    [Switch]$Persist,
    [ValidateSet('Enabled','Disabled')]
    [String]$DevelopmentMode,
    [ValidateSet('Enabled','Disabled')]
    [String]$DebugMode,
    [ValidateSet('Enabled','Disabled')]
    [String]$Telemetry
  )

  if ($CSPRegion -and $CSPUrl) {
    Write-Error "-CSPRegion and -CSPUrl are mutually exclusive and will overwrite one another. You must use only one of these parameters."
    break
  } else {
    if ($CSPRegion -or $CSPUrl) {
      switch ($CSPRegion) {
        "US" {
            $CSPUrl = "https://csp.infoblox.com"
        }
        "EU" {
            $CSPUrl = "https://csp.eu.infoblox.com"
        }
      }
      if ($Persist) {
        $Platform = Detect-OS
        if ($Platform -eq "Windows") {
          [System.Environment]::SetEnvironmentVariable('B1CSPUrl',$CSPUrl,[System.EnvironmentVariableTarget]::User)
          $ENV:B1CSPUrl = $CSPUrl
          Write-Host "BloxOne CSP URL ($CSPUrl) has been stored permanently for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
        } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
          $ENV:B1CSPUrl = $CSPUrl
          if (!(Test-Path ~/.zshenv)) {
            touch ~/.zshenv
          }
          sed -i '' -e '/B1CSPUrl/d' ~/.zshenv
          echo "export B1CSPUrl=$CSPUrl" >> ~/.zshenv
          Write-Host "BloxOne CSP URL ($CSPUrl) has been stored permanently for $env:USER on $(scutil --get LocalHostName)." -ForegroundColor Green
        }
      } else {
          $ENV:B1CSPUrl = $CSPUrl
          Write-Host "BloxOne CSP URL ($CSPUrl) has been stored for this session." -ForegroundColor Green
          Write-Host "You can make the CSP URL persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
      }
    }
  }

  if ($CSPAPIKey) {
    $B1APIKey = $CSPAPIKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($B1APIKey)
    $Base64 = [Convert]::ToBase64String($Bytes)
    if ($Persist) {
      $Platform = Detect-OS
      if ($Platform -eq "Windows") {
        [System.Environment]::SetEnvironmentVariable('B1APIKey',$Base64,[System.EnvironmentVariableTarget]::User)
        $ENV:B1APIKey = $Base64
        Write-Host "BloxOne API key has been stored permanently for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
      } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
        $ENV:B1APIKey = $Base64
        if (!(Test-Path ~/.zshenv)) {
          touch ~/.zshenv
        }
        sed -i '' -e '/B1APIKey/d' ~/.zshenv
        echo "export B1APIKey=$Base64" >> ~/.zshenv
        Write-Host "BloxOne API key has been stored permanently for $env:USER on $(scutil --get LocalHostName)." -ForegroundColor Green
      }
    } else {
        $ENV:B1APIKey = $Base64
        Write-Host "BloxOne API key has been stored for this session." -ForegroundColor Green
        Write-Host "You can make the API key persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
    }
  }

  if ($DoHServer) {
    $Platform = Detect-OS
    if ($Platform -eq "Windows") {
      [System.Environment]::SetEnvironmentVariable('IBPSDoH',$DoHServer,[System.EnvironmentVariableTarget]::User)
    } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
      if (!(Test-Path ~/.zshenv)) {
        touch ~/.zshenv
      }
      sed -i '' -e '/IBPSDoH/d' ~/.zshenv
      echo "export IBPSDoH=$DoHServer" >> ~/.zshenv
    }
    $ENV:IBPSDoH = $DoHServer
    Write-Host "Set DNS over HTTPS Server to: $($DoHServer)." -ForegroundColor Green
  }

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
    Write-Host "$($DebugMode) Debug Mode." -ForegroundColor Green
  }

  if ($Telemetry) {
    $Platform = Detect-OS
    if ($Platform -eq "Windows") {
      [System.Environment]::SetEnvironmentVariable('IBPSTelemetry',$Telemetry,[System.EnvironmentVariableTarget]::User)
    } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
      if (!(Test-Path ~/.zshenv)) {
        touch ~/.zshenv
      }
      sed -i '' -e '/IBPSTelemetry/d' ~/.zshenv
      echo "export IBPSTelemetry=$Telemetry" >> ~/.zshenv
    }
    $ENV:IBPSTelemetry = $Telemetry
    Write-Host "$($Telemetry) Telemetry." -ForegroundColor Green
  }
}