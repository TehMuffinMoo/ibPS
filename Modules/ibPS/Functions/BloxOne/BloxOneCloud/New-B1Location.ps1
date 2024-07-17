function New-B1Location {
    <#
    .SYNOPSIS
        Creates a new Location within BloxOne Cloud

    .DESCRIPTION
        This function is used to create a new Location within BloxOne Cloud

    .PARAMETER Name
        The name of the location to create

    .PARAMETER Description
        The description of the new location

    .PARAMETER Address
        The first line of the address for the new location

    .PARAMETER City
        The city for the new location

    .PARAMETER State
        The state/county for the new location

    .PARAMETER PostCode
        The zip/postal code for the new location

    .PARAMETER Country
        The country for the new location

    .PARAMETER ContactEmail
        The contact email address for the new location

    .PARAMETER ContactName
        The contact name for the new location

    .PARAMETER ContactPhone
        The contact phone number for the new location

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1Location -Name "Madrid" -Description "Real Madrid Museum" -Address "Estadio Santiago Bernabeu Avenida Concha Espina" -PostCode "28036" -State "Madrid" -Country "Spain" -ContactName "Curator" -ContactEmail "Curator@realmadrid.com"

        # Address                                                                           City   Country PostCode State               longitude latitude
        - -------                                                                           ----   ------- -------- -----               --------- --------
        Santiago Bernabeu Stadium, 1, Avenida de Concha Espina, Hispanoamérica, Chamartín Madrid Spain   28036    Community of Madrid    -3.687   40.453

        Do you want to replace the address information with those listed? (Yes/No): Yes

        address      : @{address=Santiago Bernabeu Stadium, 1, Avenida de Concha Espina, Hispanoamérica, Chamartín; city=Madrid; country=Spain; postal_code=28036; state=Community of Madrid}
        contact_info : @{email=Curator@realmadrid.com; name=Curator}
        created_at   : 2024-05-01T12:22:09.849259517Z
        description  : Real Madrid Museum
        id           : infra/location/fsf44f43g45gh45h4g34tgvgrdh6jtrhbcx
        latitude     : 40.4530225
        longitude    : -3.68742195874704
        name         : Madrid
        updated_at   : 2024-05-01T12:22:09.849259517Z

    .FUNCTIONALITY
        BloxOneDDI
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [String]$Description,
        [Parameter(Mandatory=$true)]
        [String]$Address,
        [String]$City,
        [String]$State,
        [String]$PostCode,
        [Parameter(Mandatory=$true)]
        [String]$Country,
        [String]$ContactEmail,
        [String]$ContactName,
        [String]$ContactPhone,
        [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $Splat = @{
        "name" = $($Name)
        "address" = @{
            "address" = $($Address)
            "country" = $($Country)
        }
    }
    if ($Description) {
        $Splat.description = $($Description)
    }
    if ($City) {
        $Splat.address.city = $($City)
    }
    if ($State) {
        $Splat.address.state = $($State)
    }
    if ($PostCode) {
        $Splat.address.postal_code = $($PostCode)
    }
    if ($Country) {
        $Splat.address.country = $($Country)
    }
    if ($ContactEmail -or $ContactName -or $ContactPhone) {
        $Splat.contact_info = @{}
    }
    if ($ContactEmail) {
        $Splat.contact_info.email = $($ContactEmail)
    }
    if ($ContactName) {
        $Splat.contact_info.name = $($ContactName)
    }
    if ($ContactPhone) {
        $Splat.contact_info.phone = $($ContactPhone)
    }

    $GeoCodeJSON = @{
        "address" = $Splat.address
    } | ConvertTo-Json -Depth 5

    $GeoCode = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/infra/v1/locations/geocode" -Data $GeoCodeJSON `
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
                $Splat.address.address = $GeoCode.Address
            }
            if ($GeoCode.City) {
                $Splat.address.city = $GeoCode.City
            }
            if ($GeoCode.Country) {
                $Splat.address.country = $GeoCode.Country
            }
            if ($GeoCode.PostCode) {
                $Splat.address.postal_code = $GeoCode.PostCode
            }
            if ($GeoCode.State) {
                $Splat.address.state = $GeoCode.State
            }
        }
    } else {
        Write-Error 'Unable to find Longitude & Latitude from the specified address. Please re-enter the address and try again.'
        return $null
    }

    $Splat.longitude = $GeoCode.longitude
    $Splat.latitude = $GeoCode.latitude

    $JSON = $Splat | ConvertTo-Json -Depth 5 -Compress
    if($PSCmdlet.ShouldProcess($(JSONPretty($JSON)),"Create new BloxOne Location",$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/infra/v1/locations" -Data ([System.Text.Encoding]::UTF8.GetBytes($JSON))

        if ($Results) {
            return $Results | Select-Object -ExpandProperty result
        }
    }
}