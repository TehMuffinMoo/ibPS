function Get-B1TDNetworkList {
    <#
    .SYNOPSIS
        Retrieves network lists (External Networks) from BloxOne Threat Defense

    .DESCRIPTION
        This function is used to retrieve network lists from BloxOne Threat Defense. These are referred to and displayed as "External Networks" within the CSP.

    .PARAMETER Name
        Filter results by Name

    .PARAMETER Description
        Filter results by Description

    .PARAMETER PolicyID
        Filter results by policy_id

    .PARAMETER DefaultSecurityPolicy
        Filter results by those assigned to the default security policy

    .PARAMETER id
        Filter the results by id

    .PARAMETER Strict
        Use strict filter matching. By default, filters are searched using wildcards where possible. Using strict matching will only return results matching exactly what is entered in the applicable parameters.

    .EXAMPLE
        PS> Get-B1TDNetworkList -Name "something"

        created_time : 12/23/2021 9:29:20AM
        description  : something
        id           : 123456
        items        : {88.88.88.88/32}
        name         : something
        policy_id    : 654321
        updated_time : 9/6/2023 9:49:10PM

    .EXAMPLE
        PS> Get-B1TDNetworkList | ft -AutoSize

        created_time          description                                            id items                                                                     name                               policy_id updated_time
        ------------          -----------                                            -- -----                                                                     ----                               --------- ------------
        7/5/2020 5:02:01PM    Site A Network List                                123456 {1.2.3.4/32, 1.0.0.0/29, 134.1.2.3/32…}                                   site-a-network                         12345 1/27/2024 2:23:21PM
        7/21/2020 10:36:16AM  Site B Network List                                234567 {9.4.2.6/32}                                                              site-b-network                         23456 10/13/2023 11:26:51AM
        10/7/2020 6:37:33PM   Site C Network List                                345678 {123.234.123.234}                                                         site-c-network                         34567 9/6/2023 9:53:51PM
        ...
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="notid")]
    param(
      [parameter(ParameterSetName="notid")]
      [String]$Name,
      [parameter(ParameterSetName="notid")]
      [String]$Description,
      [parameter(ParameterSetName="notid")]
      [Int]$PolicyID,
      [parameter(ParameterSetName="notid")]
      [Switch]$DefaultSecurityPolicy,
      [parameter(ParameterSetName="id")]
      [Int]$id,
      [parameter(ParameterSetName="notid")]
      [Switch]$Strict
    )

    $MatchType = Match-Type $Strict

    [System.Collections.ArrayList]$Filters = @()
    if ($Name) {
        $Filters.Add("name$($MatchType)`"$Name`"") | Out-Null
    }
    if ($Description) {
        $Filters.Add("description$($MatchType)`"$Description`"") | Out-Null
    }
    if ($PolicyID) {
        $Filters.Add("policy_id==$PolicyID") | Out-Null
    }
    if ($DefaultSecurityPolicy) {
        $Filters.Add("default_security_policy==`"$DefaultSecurityPolicy`"") | Out-Null
    }
    if ($id) {
        $Filters.Add("id==$id") | Out-Null
    }
    if ($Location) {
        $Filters.Add("location~`"$Location`"") | Out-Null
    }
    if ($Filters) {
        $Filter = Combine-Filters $Filters
    }

    if ($Filter) {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists?_filter=$Filter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    } else {
        $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
    }

    if ($Results) {
        return $Results
    }
}