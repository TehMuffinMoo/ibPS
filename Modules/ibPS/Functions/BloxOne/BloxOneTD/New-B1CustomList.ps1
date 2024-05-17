function New-B1CustomList {
    <#
    .SYNOPSIS
        Creates a new Custom List in BloxOne Threat Defense

    .DESCRIPTION
        This function is used to create a new named list in BloxOne Threat Defense. These are referred to and displayed as Custom Lists within the CSP.

    .PARAMETER Name
        The name of the new custom list.

    .PARAMETER Description
        The description for the new custom list.

    .PARAMETER Items
        Either a key-value hashtable of domains/IP addresses and their description or a list of objects with headers 'item' & 'description'. See examples for usage

    .PARAMETER ThreatLevel
        Set the threat level for the custom list (info/low/medium/high)

    .PARAMETER ConfidenceLevel
        Set the confidence level for the custom list (low/medium/high)

    .PARAMETER Tags
        A list of tags to add to the new Custom List

    .EXAMPLE
        $Items = @{                                      
         "domain.com" = "Description 1"
         "domain1.com" = "Description 2"
         "123.123.123.123" = "Some IP Address"
        }
        New-B1CustomList -Name "Bad Stuff" -Description "This is a list of really bad stuff" -Items $Items -ThreatLevel HIGH -ConfidenceLevel MEDIUM

    .EXAMPLE
        -- CSV File
         item,description  
         domain3.com,Description 3
         domain4.com,Description 4
         234.234.234.234,Some Other IP Address
        --
        $Csv = Import-Csv $CsvFile
        New-B1CustomList -Name "Not so bad stuff" -Description "This is a list of not so bad stuff" -Items $Csv -ThreatLevel MEDIUM -ConfidenceLevel HIGH

    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [System.Object]$Items,
      [Parameter(Mandatory=$true)]
      [ValidateSet('INFO','LOW','MEDIUM','HIGH')]
      [String]$ThreatLevel,
      [Parameter(Mandatory=$true)]
      [ValidateSet('LOW','MEDIUM','HIGH')]
      [String]$ConfidenceLevel,
      [System.Object]$Tags
    )

    process {
        $Splat = @{
            "name" = $($Name)
            "description" = $($Description)
            "items_described" = @()
            "type" = "custom_list"
            "threat_level" = $($ThreatLevel)
            "confidence_level" = $($ConfidenceLevel)
            "tags" = $($Tags)
        }

        $NewItems = @()
        Switch ($Items.GetType().Name) {
          "Hashtable" {
            foreach ($Item in $Items.GetEnumerator()) {
                $NewItems += @{
                    "item" = $Item.Name
                    "description" = $Item.Value
                }
            }
          }
          "Object[]" {
            if ($Items.item -and $Items.description) {
                $NewItems = $Items
            } else {
                Write-Error "Unsupported format. Ensure the object headers are 'item' and 'description' for each entry, see examples for details."
            }
          }
        }
        $Splat.items_described = $NewItems
        $JSON = $Splat | ConvertTo-Json -Depth 5

        $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists" -Data $JSON | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
        if ($Result.name -eq $Name) {
            Write-Host "Custom List: $Name created successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create Custom List: $Name." -ForegroundColor Red
            break
        }

    }
}