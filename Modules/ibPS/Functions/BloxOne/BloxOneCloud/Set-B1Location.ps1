function Set-B1Location {
    <#
    .SYNOPSIS
        Updates a Location within BloxOne Cloud

    .DESCRIPTION
        This function is used to update a Location within BloxOne Cloud

    .PARAMETER Name
        The name of the location to update

    .PARAMETER NewName
        The new name for the specified location

    .PARAMETER Description
        The new description for the specified location

    .PARAMETER Address
        The new address for the specified location

    .PARAMETER City
        The new city for the specified location

    .PARAMETER State
        The new state for the specified location

    .PARAMETER PostCode
        The new zip/post code for the specified location

    .PARAMETER Country
        The new country for the specified location

    .PARAMETER ContactEmail
        The new contact email address for the specified location

    .PARAMETER ContactName
        The new contact name for the specified location

    .PARAMETER ContactPhone
        The new contact phone number for the specified location

    .PARAMETER Object
        The Location Object. Accepts pipeline input from Get-B1Location

    .EXAMPLE
        PS> Get-B1Location -Name "Madrid" | Set-B1Location -NewName "Rome" -Description "Rome Office (Moved from Madrid)" -Address "1 Via Cavour" -PostCode "00184" -State "Rome" -Country "Italy" -ContactName "Curator" -ContactEmail "Curator@rome.com"

        Multiple addresses found, please select the correct address

        # Address                        City                    Country PostCode State longitude latitude
        - -------                        ----                    ------- -------- ----- --------- --------
        0 1, Via Cavour                  Villanova               Italy   00012    Rome     12.753   41.964
        1 1, Via Cavour                  Mentana                 Italy   00013    Rome     12.697   42.058
        2 1, Via Cavour, Castro Pretorio Rome                    Italy   00184    Rome     12.500   41.901
        3 1, Via Cavour                  Monterotondo            Italy   00015    Rome     12.615   42.053
        4 1, Via Cavour                  Valmontone              Italy   00038    Rome     12.921   41.772
        5 1, Via Cavour                  Fiano Romano            Italy   00065    Rome     12.593   42.172
        6 1, Via Cavour                  Lariano                 Italy   00040    Rome     12.841   41.724
        7 1, Via Cavour                  Frascati                Italy   00044    Rome     12.681   41.806
        8 1, Via Cavour                  Albano                  Italy   00041    Rome     12.661   41.727
        9 1, Via Cavour                  San Gregorio da Sassola Italy   00010    Rome     12.874   41.920

        Select the correct address by entering the # or x to cancel.: 9

        #   Address       City                    Country PostCode State longitude latitude
        -   -------       ----                    ------- -------- ----- --------- --------
        9   1, Via Cavour San Gregorio da Sassola Italy   00010    Rome     12.874   41.920

        Do you want to replace the address information with those listed? (Yes/No): Yes

        address      : @{address=1, Via Cavour; city=San Gregorio da Sassola; country=Italy; postal_code=00010; state=Rome}
        contact_info : @{email=Curator@rome.com; name=Curator}
        description  : Rome Office (Moved from Madrid)
        id           : infra/location/fsf44f43g45gh45h4g34tgvgrdh6jtrhbcx
        latitude     : 41.919847
        longitude    : 12.873967
        name         : Madrid
        updated_at   : 2024-05-01T13:06:44.873541805Z
        
    .FUNCTIONALITY
        BloxOneDDI
    #>
    [Parameter(ParameterSetName="Default",Mandatory=$true)]
    param(
        [Parameter(ParameterSetName='Default',Mandatory=$true)]
        [String]$Name,
        [String]$NewName,
        [String]$Description,
        [String]$Address,
        [String]$City,
        [String]$State,
        [String]$PostCode,
        [String]$Country,
        [String]$ContactEmail,
        [String]$ContactName,
        [String]$ContactPhone,
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName="Pipeline",
            Mandatory=$true
        )]
        [System.Object]$Object
    )

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/location") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/location' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1Location -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find Location: $($Name)"
                return $null
            }
        }

        if ($Description) {
            $Object.description = $($Description)
        }
        if ($Address) {
            $Object.address.address = $($Address)
        }
        if ($City) {
            $Object.address.city = $($City)
        }
        if ($State) {
            $Object.address.state = $($State)
        }
        if ($PostCode) {
            $Object.address.postal_code = $($PostCode)
        }
        if ($Country) {
            $Object.address.country = $($Country)
        }
        if ($ContactEmail -or $ContactName -or $ContactPhone) {
            $Object.contact_info = @{}
        }
        if ($ContactEmail) {
            $Object.contact_info.email = $($ContactEmail)
        }
        if ($ContactName) {
            $Object.contact_info.name = $($ContactName)
        }
        if ($ContactPhone) {
            $Object.contact_info.phone = $($ContactPhone)
        }

        if ($Address -or $City -or $State -or $PostCode -or $Country) {
            $GeoCodeJSON = @{
                "address" = $Object.address
            } | ConvertTo-Json -Depth 5
    
            $GeoCode = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/infra/v1/locations/geocode" -Data ([System.Text.Encoding]::UTF8.GetBytes($GeoCodeJSON)) `
                        | Select-Object -ExpandProperty results `
                        | Select-Object @{name="Address";expression={$_.address.address}}, `
                        @{name="City";expression={$_.address.city}}, `
                        @{name="Country";expression={$_.address.country}}, `
                        @{name="PostCode";expression={$_.address.postal_code}}, `
                        @{name="State";expression={$_.address.state}}, `
                        Longitude, Latitude
    
            if ($GeoCode) {
                if ($GeoCode.count -gt 1) {
                    $Count = 0
                    Write-Host "Multiple addresses found, please select the correct address" -ForegroundColor Cyan
                    $GeoCodes = $GeoCode
                    foreach ($GeoCode in $GeoCodes) {
                        $GeoCode | Add-Member -MemberType NoteProperty -Name '#' -Value $Count
                        $Count++
                    }
                    $ValidChoices = 0..$GeoCodes.'#'.GetUpperBound(0) + 'x'
                    $Choice = ''
    
                    while ([string]::IsNullOrEmpty($Choice)) {
                        $GeoCodes | Format-Table '#',Address,City,Country,PostCode,State,Longitude,Latitude -AutoSize
    
                        $Choice = Read-Host -Prompt 'Select the correct address by entering the # or x to cancel.'
                        Write-Host ''
            
                        if ($Choice -notin $ValidChoices) {
                            Write-Warning ('    [ {0} ] is not a valid selection.' -f $Choice)
                            Write-Warning '    Please try again.'
                            $Choice = ''
                            pause
                        }
                    }
            
                    if ($Choice -eq 'x') {
                        return $null
                    } else {
                        $GeoCode = $GeoCodes[$Choice]
                    }
                }
                $Choice = ''
                while ([string]::IsNullOrEmpty($Choice)) {
                    $GeoCode | Format-Table '#',Address,City,Country,PostCode,State,Longitude,Latitude -AutoSize
                    $Choice = Read-Host -Prompt 'Do you want to replace the address information with those listed? (Yes/No)'
                    Write-Host ''
    
                    if ($Choice -notin @('Yes','No')) {
                        Write-Warning ('    [ {0} ] is not a valid selection.' -f $Choice)
                        Write-Warning '    Please use Yes or No.'
                        $Choice = ''
                        pause
                    }
                }
    
                if ($Choice -eq 'Yes') {
                    if ($GeoCode.Address) {
                        $Object.address.address = $GeoCode.Address
                    }
                    if ($GeoCode.City) {
                        $Object.address.city = $GeoCode.City
                    }
                    if ($GeoCode.Country) {
                        $Object.address.country = $GeoCode.Country
                    }
                    if ($GeoCode.PostCode) {
                        $Object.address.postal_code = $GeoCode.PostCode
                    }
                    if ($GeoCode.State) {
                        $Object.address.state = $GeoCode.State
                    }
                }
            } else {
                Write-Error 'Unable to find Longitude & Latitude from the specified address. Please re-enter the address and try again.'
                return $null
            }
    
            $Object.longitude = $GeoCode.longitude
            $Object.latitude = $GeoCode.latitude
        }
        
        $JSON = $Object | Select-Object -ExcludeProperty id,updated_at,created_at | ConvertTo-Json -Depth 5 -Compress

        $ObjectID = ($Object.id -Split ('/'))[2]
        $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/locations/$($ObjectID)" -Data ([System.Text.Encoding]::UTF8.GetBytes($JSON))

        if ($Results) {
            return $Results | Select-Object -ExpandProperty result
        }
    }
}