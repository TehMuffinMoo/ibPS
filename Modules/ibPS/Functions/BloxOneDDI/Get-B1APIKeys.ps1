function Get-B1APIKeys {
    <#
    .SYNOPSIS
        Retrieves a list of BloxOne Cloud API Keys

    .DESCRIPTION
        This function is used to retrieve a list of API Keys from the BloxOne Cloud
        The actual API Key is only available during initial creation and cannot be retrieved afterwards via this API, except for Legacy Keys which are being deprecated.

    .PARAMETER User
        Filter the results by user_email

    .PARAMETER Name
        Filter the results by the name of the API Key

    .PARAMETER Type
        Filter the results by the API Key Type

    .PARAMETER State
        Filter the results by the state of the API Key

    .PARAMETER Limit
        Use this parameter to limit the quantity of results returned from the Audit Log. The default and maximum number of results is 101.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .EXAMPLE
        Get-B1APIKeys -User "user@domain.corp" -Name "somename" -Type "interactive" -State Enabled

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Authentication
    #>
    param(
        $User,
        $Name,
        [ValidateSet("Interactive", "Legacy", "Service")]
        $Type,
        [ValidateSet("Enabled", "Disabled")]
        $State,
        $Limit = 101,
        $Offset = 0
    )

    $QueryFilters = @()
    if ($Limit) {
        $QueryFilters += "_limit=$Limit"
    }
    if ($Offset) {
        $QueryFilters += "_offset=$Offset"
    }

    $ParamFilters = @()
    if ($User) {
      $ParamFilters += "user_email:=`"$User`""
    }
    if ($Name) {
        $ParamFilters += "name:=`"$Name`""
    }
    if ($Type) {
        $ParamFilters += "type:=`"$Type`""
    }
    if ($State) {
        $ParamFilters += "state:=`"$State`""
    }

     if ($ParamFilters) {
        $ParamFilter = Combine-Filters($ParamFilters)
        $QueryFilters += "_filter=$ParamFilter"
    }

    $CombinedFilter += Combine-Filters2($QueryFilters)

    $CombinedFilter

    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/v2/api_keys$CombinedFilter" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }

}