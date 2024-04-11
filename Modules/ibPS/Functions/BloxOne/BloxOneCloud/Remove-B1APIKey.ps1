function Remove-B1APIKey {
    <#
    .SYNOPSIS
        Removes a BloxOne Cloud API Key

    .DESCRIPTION
        This function is used to remove an API Key from the BloxOne Cloud
        The API Key must be disabled prior to deleting

    .PARAMETER User
        Filter the results by user_email

    .PARAMETER Name
        Filter the results by the name of the API Key

    .PARAMETER Type
        Filter the results by the API Key Type

    .PARAMETER State
        Filter the results by the state of the API Key

    .PARAMETER id
        The id of the API Key. Accepts pipeline input

    .EXAMPLE
        PS> Remove-B1APIKey -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled

    .EXAMPLE
        PS> Get-B1APIKey -Name "MyAPIKey" | Set-B1APIKey -State Disabled | Remove-B1APIKey

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [Parameter(Mandatory=$true,ParameterSetName="Default")]
        $Name,
        [Parameter(ParameterSetName="Default")]
        $User,
        [Parameter(ParameterSetName="Default")]
        [ValidateSet("Interactive", "Legacy", "Service")]
        $Type,
        [Parameter(ParameterSetName="Default")]
        [ValidateSet("Enabled", "Disabled")]
        $State,
        [Parameter(
          ValueFromPipelineByPropertyName = $true,
          ParameterSetName="With ID",
          Mandatory=$true
        )]
        [String]$id
    )

    process { 
        if ($id) {
            $APIKey = Get-B1APIkey -id $id
        } else {
            if ($Type -and $State) {
                $APIKey = Get-B1APIKey -User $User -Name $Name -Type $Type -State $State -Strict
            } elseif ($Type) {
                $APIKey = Get-B1APIKey -User $User -Name $Name -Type $Type -Strict
            } elseif ($State) {
                $APIKey = Get-B1APIKey -User $User -Name $Name -State $State -Strict
            } else {
                $APIKey = Get-B1APIKey -User $User -Name $Name -Strict
            }
        }
        if ($APIKey) {
          if ($APIKey.count -eq 1) {
            $APIKeyIdSplit = $APIKey.id -split "identity/apikeys/"
            if ($APIKeyIdSplit[1]) {
                
                Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/v2/api_keys/$($APIKeyIdSplit[1])"
            }
            if (Get-B1APIkey -id $($APIKey.id)) {
              Write-Error "Error. Failed to delete API Key: $($APIKey.name)"
            } else {
              Write-Host "Successfully deleted API Key: $($APIKey.name)" -ForegroundColor Green
            }
          } else {
            Write-Error "More than one result returned. To remove multiple objects, pipe Get-B1APIKey into Remove-B1APIKey instead"
          }
        } else {
            Write-Error "API Key not found"
        }
    }
}