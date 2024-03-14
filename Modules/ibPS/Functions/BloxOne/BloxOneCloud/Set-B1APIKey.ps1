function Set-B1APIKey {
    <#
    .SYNOPSIS
        Updates an existing BloxOne Cloud API Key

    .DESCRIPTION
        This function is used to update an existing API Key from the BloxOne Cloud, such as disabling/enabling it.

    .PARAMETER User
        Filter the results by user_email

    .PARAMETER Name
        Filter the results by the name of the API Key

    .PARAMETER Type
        Filter the results by the API Key Type

    .PARAMETER State
        Toggle the state of the API Key

    .PARAMETER id
        The id of the API Key. Accepts pipeline input

    .EXAMPLE
        PS> Set-B1APIKey -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled

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
            if ($Type) {
                $APIKey = Get-B1APIKey -User $User -Name $Name -Type $Type -Strict
            } else {
                $APIKey = Get-B1APIKey -User $User -Name $Name -Strict
            }
        }
        if ($APIKey) {
          if ($APIKey.count -eq 1) {
            $APIKeyIdSplit = $APIKey.id -split "identity/apikeys/"
            if ($APIKeyIdSplit[1]) {
                if ($State) {
                  $APIKey.state = $State.toLower()
                }
                $APIKeyJson = $APIKey | ConvertTo-Json -Depth 5
                Query-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/v2/api_keys/$($APIKeyIdSplit[1])" -Data $APIKeyJson | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            }
            if (Get-B1APIkey -id $($APIKey.id)) {
              Write-Host "Successfully updated API Key: $($APIKey.name)" -ForegroundColor Green
              return $APIKey
            } else {
              Write-Error "Error. Failed to update API Key: $($APIKey.name)" -ForegroundColor Green
              return $APIKey
            }
          } else {
            Write-Error "More than one result returned. To update multiple objects, pipe Get-B1APIKey into Set-B1APIKey instead"
          }
        } else {
            Write-Error "API Key not found"
        }
    }
}