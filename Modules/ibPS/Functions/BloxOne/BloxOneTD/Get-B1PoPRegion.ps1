function Get-B1PoPRegion {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Threat Defense PoP Regions

    .DESCRIPTION
        This function is used to query a list of BloxOne Threat Defense Point of Presence (PoP) Regions

    .PARAMETER Region
        Filter results by Region. Whilst this is here, the API does not currently support filtering by region. 22/05/24

    .PARAMETER Location
        Filter results by Location. Whilst this is here, the API does not currently support filtering by region. 22/05/24

    .PARAMETER Limit
        Use this parameter to limit the quantity of results.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER id
        Filter the results by id

    .EXAMPLE
        PS> Get-B1PoPRegion                 

        addresses                   id location             region
        ---------                   -- --------             ------
        {52.119.41.51, 103.80.6.51}  1 California, US       us-west-1
        {52.119.41.52, 103.80.6.52}  2 Virginia, US         us-east-1
        {52.119.41.53, 103.80.6.53}  3 London, UK           eu-west-2
        {52.119.41.54, 103.80.6.54}  4 Frankfurt, Germany   eu-central-1
        {52.119.41.55, 103.80.6.55}  5 Mumbai, India        ap-south-1
        {52.119.41.56, 103.80.6.56}  6 Tokyo, Japan         ap-northeast-1
        {52.119.41.57, 103.80.6.57}  7 Singapore            ap-southeast-1
        {52.119.41.58, 103.80.6.58}  8 Toronto, Canada      ca-central-1
        {52.119.41.59, 103.80.6.59}  9 Sydney, Australia    ap-southeast-2
        {52.119.41.60, 103.80.6.60} 10 Sao Paulo, Brazil    sa-east-1
        {52.119.41.61, 103.80.6.61} 11 Manama, Bahrain      me-south-1
        {52.119.41.62, 103.80.6.62} 12 Cape Town, S. Africa af-south-1
        {52.119.41.63, 103.80.6.63} 13 Ohio, US             us-east-2
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Region,
      [parameter(ParameterSetName="Default")]
      [String]$Location,
      [Parameter(ParameterSetName="Default")]
      [Int]$Limit,
      [Parameter(ParameterSetName="Default")]
      [Int]$Offset,
      [Parameter(ParameterSetName="Default")]
      [String[]]$Fields,
      [parameter(ParameterSetName="With ID")]
      [String]$id
    )

    [System.Collections.ArrayList]$Filters = @()
    [System.Collections.ArrayList]$QueryFilters = @()
    if ($Region) {
        $Filters.Add("region==`"$Region`"") | Out-Null
    }
    if ($Location) {
        $Filters.Add("location~`"$Location`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
        $QueryFilters.Add("_filter=$Filter") | Out-Null
    }
    if ($Limit) {
        $QueryFilters.Add("_limit=$Limit") | Out-Null
    }
    if ($Offset) {
        $QueryFilters.Add("_offset=$Offset") | Out-Null
    }
    if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
    }
    if ($QueryFilters) {
        $QueryString = ConvertTo-QueryString $QueryFilters
    }
    Write-DebugMsg -Filters $QueryFilters
    if ($id) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions/$id" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    } elseif ($QueryString) {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions$QueryString" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }
    if (($id -eq '100') -or (!($QueryString))) {
        $Results += [PSCustomObject]@{
            "addresses" = @(
                '52.119.41.100'
                '103.80.6.100'
            )
            "id" = 100
            "location" = "Global AnyCast"
            "region" = "Global"
        }
    }

    if ($Results) {
        return $Results
    }
}