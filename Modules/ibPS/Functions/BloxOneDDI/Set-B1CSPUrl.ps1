function Set-B1CSPUrl {
    <#
    .SYNOPSIS
        Sets/updates the BloxOneDDI CSP Url.

    .DESCRIPTION
        This function will set/update the BloxOneDDI CSP Url. This is used when using an alternate CSP Region (i.e EU)

    .PARAMETER Region
        Specify the CSP Region to use (i.e EU for the EMEA instance)

    .PARAMETER URL
        Optionally specify a URL manually

    .EXAMPLE
        PS> Set-B1CSPUrl -Region EU
                                                                                                                  
        BloxOne CSP URL (https://csp.eu.infoblox.com) has been stored for this session.
        You can make the CSP URL persistent for this user on this machine by using the -persist parameter.

    .EXAMPLE
        PS> Set-B1CSPUrl -Region EU -Persist
        
        BloxOne CSP URL (https://csp.eu.infoblox.com) has been stored permenantly for user on computername.

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        API
    #>
    param(
        [Parameter(ParameterSetName="Region")]
        [ValidateSet("US","EU")]
        [String]$Region,
        [Parameter(ParameterSetName="URL")]
        [String]$URL,
        [switch]$Persist
      )

      switch ($Region) {
        "US" {
            $URL = "https://csp.infoblox.com"
        }
        "EU" {
            $URL = "https://csp.eu.infoblox.com"
        }
      }

      if ($Persist) {
          $Platform = Detect-OS
          if ($Platform -eq "Windows") {
            [System.Environment]::SetEnvironmentVariable('B1CSPUrl',$URL,[System.EnvironmentVariableTarget]::User)
            $ENV:B1CSPUrl = $URL
            Write-Host "BloxOne CSP URL ($URL) has been stored permenantly for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
          } elseif ($Platform -eq "Mac" -or $Platform -eq "Unix") {
            $ENV:B1CSPUrl = $URL
            if (!(Test-Path ~/.zshenv)) {
              touch ~/.zshenv
            }
            sed -i '' -e '/B1CSPUrl/d' ~/.zshenv
            echo "export B1CSPUrl=$URL" >> ~/.zshenv
            Write-Host "BloxOne CSP URL ($URL) has been stored permenantly for $env:USER on $(scutil --get LocalHostName)." -ForegroundColor Green
          }
      } else {
          $ENV:B1CSPUrl = $URL
          Write-Host "BloxOne CSP URL ($URL) has been stored for this session." -ForegroundColor Green
          Write-Host "You can make the CSP URL persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
      }
}