
function Store-B1APIKey {
    <#
    .SYNOPSIS
        Stores a new BloxOneDDI API Key

    .DESCRIPTION
        This function will store a new BloxOneDDI API Key for the current user on the local machine. If a previous API Key exists, it will be overwritten.

    .PARAMETER APIKey
        This is the BloxOneDDI API Key retrieves from the Cloud Services Portal

    .PARAMETER Persist
        Using the -Persist switch will save the API Key across powershell sessions. Without using this switch, the API Key will only be stored for the current powershell session.

    .Example
        Set-B1APIKey "mylongapikeyfromcsp" -Persist

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Authentication
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$APIKey,
      [switch]$Persist
    )
    if ($Persist) {
        if ($IsWindows) {
          [System.Environment]::SetEnvironmentVariable('B1APIKey',$APIKey,[System.EnvironmentVariableTarget]::User)
          $ENV:B1APIKey = $APIKey
          Write-Host "BloxOne API key has been stored permenantly for $env:USERNAME on $env:COMPUTERNAME." -ForegroundColor Green
        } elseif ($IsMacOS) {
          $ENV:B1APIKey = $APIKey
          if (!(Test-Path ~/.bash_profile)) {
            touch ~/.bash_profile
          }
          sed -i '' -e '/B1APIKey/d' ~/.bash_profile
          echo "export B1APIKey=$B1APIKey" >> ~/.bash_profile
          Write-Host "BloxOne API key has been stored permenantly for $env:USER on $(scutil --get LocalHostName)." -ForegroundColor Green
        }
    } else {
        $ENV:B1APIKey = $APIKey
        Write-Host "BloxOne API key has been stored for this session." -ForegroundColor Green
        Write-Host "You can make the API key persistent for this user on this machine by using the -persist parameter." -ForegroundColor Gray
    }
}