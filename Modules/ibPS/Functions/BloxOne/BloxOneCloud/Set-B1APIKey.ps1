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
          ValueFromPipeline = $true,
          ParameterSetName="Object",
          Mandatory=$true
        )]
        [System.Object]$Object
    )

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "identity/apikeys") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'identity/apikeys' objects as input"
                return $null
            }
            $Type = $Object.type
        } else {
            if ($Type) {
                $Object = Get-B1APIKey -User $User -Name $Name -Type $Type -Strict
            } else {
                $Object = Get-B1APIKey -User $User -Name $Name -Strict
            }
            if (!($Object)) {
                Write-Error "Unable to find API Key: $($Name)"
                return $null
            }
            if ($Object.count -gt 1) {
                Write-Error "Multiple API Keys were found, to update more than one API Keys you should pass those objects using pipe instead."
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty id

        $APIKeyIdSplit = $Object.id -split "identity/apikeys/"
        if ($State) {
            $NewObj.state = $State.toLower()
        }

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/v2/api_keys/$($APIKeyIdSplit[1])" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}