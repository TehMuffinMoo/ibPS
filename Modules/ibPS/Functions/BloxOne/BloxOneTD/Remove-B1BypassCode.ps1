function Remove-B1BypassCode {
    <#
    .SYNOPSIS
        Removes a bypass code from BloxOne Cloud

    .DESCRIPTION
        This function is used to remove a bypass code from BloxOne Cloud

    .PARAMETER Name
        The name of the bypass code to remove

    .PARAMETER Access_Key
        The Access Key of the bypass code to remove

    .PARAMETER Object
        The Bypass Code object to remove. Expects pipeline input from Get-B1BypassCode

    .EXAMPLE
        PS> Get-B1BypassCode -Name 'My Bypass Code' | Remove-B1BypassCode

        Successfully deleted Bypass Code: My Bypass Code
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
      [Parameter(Mandatory=$true,ParameterSetName="Default")]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="Pipeline",
        Mandatory=$true
      )]
      [System.Object]$Access_Key
    )

    process {
      if (!($Access_Key)) {
        $Access_Key = (Get-B1BypassCode -Name $Name -Strict).access_key
        if (!($Access_Key)) {
          Write-Error "Unable to find Bypass Code with name: $($Name)"
        }
      }

      $Result = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/access_codes/$($Access_Key)"
      if (Get-B1BypassCode -Name $Name -Strict) {
        Write-Error "Failed to delete Bypass Code: $($Access_Key)"
        break
      } else {
        Write-Host "Successfully deleted Bypass Code: $($Access_Key)" -ForegroundColor Green
      }
    }
}