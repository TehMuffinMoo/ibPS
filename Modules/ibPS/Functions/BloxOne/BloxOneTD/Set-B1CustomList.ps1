function Set-B1CustomList {
    <#
    .SYNOPSIS
        Updates a custom list object

    .DESCRIPTION
        This function is used to update a custom list object within BloxOne Threat Defense

    .PARAMETER Name
        The name of the Custom List to remove.
        
        Whilst this is here, the API does not currently support filtering by name. (01/04/24)
        
        For now, you should instead use pipeline to update objects as shown in the examples.

    .PARAMETER NewName
        Use -NewName to update the name of the Custom List

    .PARAMETER Description
        The description for the new policy object

    .PARAMETER Items
        Enter a key-value hashtable of domains/IP addresses and their description or a list of objects with headers 'item' & 'description'. See examples for usage

        This will overwrite the current list of domains/addresses. If you only want to add or remove items then you should use the corresponding -AddItems or -RemoveItems parameters.

    .PARAMETER AddItems
        Enter a key-value hashtable of domains/IP addresses and their description or a list of objects with headers 'item' & 'description'.

        Duplicate items will be silently skipped, only new items are appended to the custom list.

    .PARAMETER RemoveItems
        Enter a list of domains/IP addresses, or a hashtable/object the same format as -Items & -AddItems

        These items will be removed from the custom list, if the item does not exist it will be silently skipped.

    .PARAMETER ThreatLevel
        Set the threat level for the custom list (info/low/medium/high)

    .PARAMETER ConfidenceLevel
        Set the confidence level for the custom list (low/medium/high)

    .PARAMETER Tags
        The list of tags to apply to the custom list. This will overwrite the current list of tags.

    .PARAMETER Object
        The Custom List object to update. Accepts pipeline input from Get-B1CustomList.

    .EXAMPLE
        $Items = @{                                      
         "domain.com" = "Description 1"
         "domain1.com" = "Description 2"
         "123.123.123.123" = "Some IP Address"
        }
        Get-B1CustomList | Where-Object {$_.name -eq "My Custom List"} | Set-B1CustomList -AddItems $Items

        confidence_level : HIGH
        created_time     : 5/3/2024 4:43:02 PM
        description      : New Description
        id               : 123456
        item_count       : 4
        items            : {123.123.123.123/32, somedomain.com, domain1.com, domain.com}
        items_described  : {@{description=Some IP Address; item=123.123.123.123/32}, @{description=A Domain!; item=somedomain.com}, @{description=Description 2; item=domain1.com}, @{description=Description 1; item=domain.com}}
        name             : My Custom List
        policies         : {}
        tags             : @{Owner=Me}
        threat_level     : MEDIUM
        type             : custom_list
        updated_time     : 5/3/2024 6:10:44 PM

    .EXAMPLE
        $Items = @("domain.com","domain1.com","123.123.123.123")
        Get-B1CustomList | Where-Object {$_.name -eq "My Custom List"} | Set-B1CustomList -RemoveItems $Items

        confidence_level : HIGH
        created_time     : 5/3/2024 4:43:02 PM
        description      : New Description
        id               : 123456
        item_count       : 1
        items            : {somedomain.com}
        items_described  : {@{description=A Domain!; item=somedomain.com}}
        name             : My Custom List
        policies         : {}
        tags             : @{Owner=Me}
        threat_level     : MEDIUM
        type             : custom_list
        updated_time     : 5/3/2024 6:11:32 PM

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [Parameter(ParameterSetName="Default",Mandatory=$true)]
    param(
      [Parameter(ParameterSetName='Default',Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [System.Object]$Items,
      [System.Object]$AddItems,
      [System.Object]$RemoveItems,
      [ValidateSet('INFO','LOW','MEDIUM','HIGH')]
      [String]$ThreatLevel,
      [ValidateSet('LOW','MEDIUM','HIGH')]
      [String]$ConfidenceLevel,
      [System.Object]$Tags,
      [Parameter(
          ValueFromPipeline = $true,
          ParameterSetName="Pipeline",
          Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {
        if ($Object) {
            if ($Object.type -ne "custom_list") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'custom_list' objects as input"
                return $null
            } else {
                if (!($Object.items_described)) {
                    $Object = Get-B1CustomList -id $($Object.id)
                }
            }
        } else {
            $Object = Get-B1CustomList -Name $($Name) -Strict
            if (!($Object)) {
                Write-Error "Unable to find Custom List: $($Name)"
                return $null
            }
        }

        if (($Items -and $AddItems) -or ($Items -and $RemoveItems)) {
            if ($AddItems) {
                Write-Error '-Items and -AddItems are mutually exclusive parameters. See documentation for help.'
                return $null
            }
            if ($RemoveItems) {
                Write-Error '-Items and -RemoveItems are mutually exclusive parameters. See documentation for help.'
                return $null
            }
        }
        
        $NewObj = $Object | Select-Object -ExcludeProperty created_time,updated_time,items,item_count,policies

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.description = $Description
        }
        if ($ThreatLevel) {
            $NewObj.threat_level = $ThreatLevel
        }
        if ($ConfidenceLevel) {
            $NewObj.confidence_level = $ConfidenceLevel
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }

        $NewItems = @()
        if ($Items -or $AddItems) {
            if ($Items) { $Objects = $($Items) } else { $Objects = $($AddItems) }
            Switch ($Objects.GetType().Name) {
                "Hashtable" {
                  foreach ($O in $Objects.GetEnumerator()) {
                      $NewItems += @{
                          "item" = $O.Name
                          "description" = $O.Value
                      }
                  }
                }
                "Object[]" {
                  if ($Objects.item -and $Objects.description) {
                      $NewItems = $Objects
                  } else {
                      Write-Error "Unsupported format. Ensure the object headers are 'item' and 'description' for each entry, see examples for details."
                  }
                }
            }
        }

        if ($Items) {
            $NewObj.items_described = $NewItems
        }

        if ($NewName -or $Description -or $ThreatLevel -or $ConfidenceLevel -or $Tags -or $Items) {
            $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
            $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists/$($Object.id)" -Data $JSON
        }
        if ($AddItems) {
            $NewItemsToAdd = @{
                "items_described" = $NewItems
            }
            $JSON = $NewItemsToAdd | ConvertTo-Json -Depth 5 -Compress
            $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists/$($Object.id)/items" -Data $JSON
        }
        if ($RemoveItems) {
            if ($RemoveItems.item) {
                $ItemsToRemove = @{
                    "items_described" = $RemoveItems
                }
            } else {
                $ItemsToRemove = @{
                    "items" = @($RemoveItems)
                }
            }
            $JSON = $ItemsToRemove | ConvertTo-Json -Depth 5 -Compress
            $Results = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists/$($Object.id)/items" -Data $JSON
        }

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        if ($AddItems -or $RemoveItems) {
            if (($AddItems -and $Results.ToString() -eq "") -or ($RemoveItems -and -not $Results)) {
                return Get-B1CustomList -id $($Object.id)
            } else {
                Write-Error "Failed to update items for Custom List: $($Object.name)"
                return $Results
            }
        } else {
            if ($Results | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty results
            } else {
                $Results
            }
        }        
    }
}