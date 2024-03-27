function Get-B1PoPRegion {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Threat Defense PoP Regions

    .DESCRIPTION
        This function is used to query a list of BloxOne Threat Defense Point of Presence (PoP) Regions

    .PARAMETER Region
        Filter results by Region

    .PARAMETER Location
        Filter results by Location

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
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="notid")]
    param(
      [parameter(ParameterSetName="notid")]
      [String]$Region,
      [parameter(ParameterSetName="notid")]
      [String]$Location,
      [parameter(ParameterSetName="With ID")]
      [String]$id
    )

    [System.Collections.ArrayList]$Filters = @()
    if ($Region) {
        $Filters.Add("region==`"$Region`"") | Out-Null
    }
    if ($Location) {
        $Filters.Add("location~`"$Location`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($id) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions/$id" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
    } elseif ($Filter) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/pop_regions" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}