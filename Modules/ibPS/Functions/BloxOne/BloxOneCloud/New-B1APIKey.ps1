function New-B1APIKey {
    <#
    .SYNOPSIS
        Creates a new BloxOne Cloud API Key

    .DESCRIPTION
        This function is used to create a new API Key from the BloxOne Cloud.

    .PARAMETER Name
        The name for the new API Key

    .PARAMETER Type
        The type of API Key to create.
        Interactive will create a user API Key assigned to your user.
        Service will create a service API Key assigned to the selected service user.

    .PARAMETER UserEmail
        The UserEmail parameter is used in conjunction with '-Type Service' to specify which user to associate with the key

        The UserEmail & UserName parameters are mutually exclusive, with UserEmail taking preference if both are specified.

    .PARAMETER UserName
        The UserName parameter is used in conjunction with '-Type Service' to specify which user to associate with the key

        The UserName & UserEmail parameters are mutually exclusive, with UserEmail taking preference if both are specified.

    .PARAMETER Expires
        The date/time when the key will expire. Defaults to 1 year.

    .EXAMPLE
        New-B1APIKey -Name "somename" -Type Interactive

    .EXAMPLE
        PS> New-B1APIKey -Name "serviceapikey" -Type Service -UserName "svc-account-name"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        [ValidateSet("Interactive", "Service")]
        [String]$Type,
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [DateTime]$Expires = $(Get-Date).AddYears(1)
    )

    DynamicParam {
        if ($Type -eq "Service") {
             $userEmailAttribute = New-Object System.Management.Automation.ParameterAttribute
             $userEmailAttribute.Position = 3
             $userEmailAttribute.HelpMessage = "The UserEmail parameter is required when creating a Service API Key."

             $userNameAttribute = New-Object System.Management.Automation.ParameterAttribute
             $userNameAttribute.Position = 4
             $userNameAttribute.HelpMessage = "The UserName parameter is required when creating a Service API Key."

             $userNameAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $userNameAttributeCollection.Add($userNameAttribute)

             $userEmailAttributeCollection = new-object System.Collections.ObjectModel.Collection[System.Attribute]
             $userEmailAttributeCollection.Add($userEmailAttribute)

             #add our paramater specifying the attribute collection
             $userEmailParam = New-Object System.Management.Automation.RuntimeDefinedParameter('UserEmail', [String], $userEmailAttributeCollection)
             $userNameParam = New-Object System.Management.Automation.RuntimeDefinedParameter('UserName', [String], $userNameAttributeCollection)

             #expose the name of our parameter
             $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
             $paramDictionary.Add('UserEmail', $userEmailParam)
             $paramDictionary.Add('UserName', $userNameParam)
             return $paramDictionary
       }
   }

    process {
      $ExpiresAt = Get-Date $Expires -Format o
      switch($Type) {
        "Service" {
          $UserEmail = $PSBoundParameters['UserEmail']
          $UserName = $PSBoundParameters['UserName']
          $ExistingAPIKey = Get-B1APIKey -Name $Name -User $UserEmail -Type Service
          if ($UserEmail) {
            $AttachUser = Get-B1User -Email $UserEmail -Strict -Type Service
          } elseif ($UserName) {
            $AttachUser = Get-B1User -Name $UserName -Strict -Type Service
          }
          if ($AttachUser) {
            if ($AttachUser.count -gt 1) {
              Write-Error "Error. More than one user returned via search for: $($UserName) $($UserEmail)."
              break
            } else {
              $UserIDSplit = $($AttachUser.id) -split "identity/users/"
              $UserID = $UserIDSplit[1]
            }
          } else {
            Write-Error "Error. User: $($UserEmail)$($UserName) could not be found. This must be a Service User when attaching to a Service API Key."
            break
          }
          if ($ExistingAPIKey) {
            Write-Error "Error. API Key: $($ExistingAPIKey.name) already exists."
            break
          }
          $NewAPIKeyJson = @{
            "name" = $Name
            "user_id" = $UserID
            "expires_at" = $ExpiresAt
          } | ConvertTo-Json -Depth 2
          $Results = Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/v2/api_keys" -Data $NewAPIKeyJson | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
        "Interactive" {
            $ExistingAPIKey = Get-B1UserAPIKey -Name $Name -Strict
            if ($ExistingAPIKey) {
              Write-Error "Error. API Key: $($ExistingAPIKey.name) already exists."
              break
            }
          $NewAPIKeyJson = @{
            "name" = $Name
            "expires_at" = $ExpiresAt
          } | ConvertTo-Json -Depth 2
          $Results = Query-CSP -Method POST -Uri "$(Get-B1CSPUrl)/v2/current_api_keys" -Data $NewAPIKeyJson | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
      }

      if ($Results) {
        Write-Host "Successfully created API Key: $($Results.name)" -ForegroundColor Green
        Write-Host "Your new API Key is: $($Results.key)" -ForegroundColor Cyan
        Write-Host "Please ensure you copy this key somewhere safe, it is not retrievable again." -ForegroundColor Yellow
        return $Results
      } else {
        Write-Error "Failed to create new API Key: $($Name)"
        break
      }
    }
}