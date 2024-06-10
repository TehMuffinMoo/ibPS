function Get-B1SecurityPolicyRules {
    <#
    .SYNOPSIS
        Use this cmdlet to retrieve a list of security policy rules

    .DESCRIPTION
        Use this cmdlet to retrieve information on of security policy rules

    .PARAMETER PolicyID
        Filter results by policy_id

    .PARAMETER ListID
        Filter results by list_id

    .PARAMETER CategoryFilterID
        Filter results by category_filter_id

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 100.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

    .PARAMETER Object
        Optionally pass in a security policy object via pipeline to list rules for.

    .EXAMPLE
        PS> PS> Get-B1SecurityPolicy -Name 'Default Global Policy' | Get-B1SecurityPolicyRules | ft -AutoSize

        action       data                                                                list_id policy_id policy_name           redirect_name rule_tags            type
        ------       ----                                                                ------- --------- -----------           ------------- ---------            ----
        action_allow Default Allow                                                        553567     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
        action_block Default Block                                                        756742     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
        action_block CrowdStrike and Cyber threat coalition and Fortinet and Palo Alto 1  423566     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
        action_allow Default-whitelist                                                    423567     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
        action_block CrowdStrike and Cyber threat coalition and Fortinet 1                522345     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
        action_block CrowdStrike and Cyber threat coalition 1                             253356     56924 Default Global Policy               @{tag_scope=; tags=} custom_list
        ...
    
    .EXAMPLE
        PS> Get-B1SecurityPolicyRules | Select -First 10 | ft -AutoSize

        action                    data                                                                list_id policy_id policy_name           redirect_name rule_tags            type
        ------                    ----                                                                ------- --------- -----------           ------------- ---------            ----
        action_block              antimalware-ip                                                            0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
        action_block              ext-antimalware-ip                                                        0    123456 corporate-policy                                         @{tag_scope=; tags=} named_feed
        action_block              Threat Insight - Data Exfiltration                                        0    453532 iot-policy                                               @{tag_scope=; tags=} custom_list
        action_log                Threat Insight - Notional Data Exfiltration                               0    453532 iot-policy                                               @{tag_scope=; tags=} custom_list
        action_block              Threat Insight - DNS Messenger                                            0    453532 iot-policy                                               @{tag_scope=; tags=} custom_list
        ...
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [parameter(ParameterSetName="Default")]
        [Int]$PolicyID,
        [Int]$ListID,
        [Int]$CategoryFilterID,
        [Int]$Limit = 1000,
        [Int]$Offset,
        [String[]]$Fields,
        $CustomFilters,
        [Parameter(
          ValueFromPipeline = $true,
          ParameterSetName="Pipeline",
          Mandatory=$true
        )]
        [System.Object]$Object
    )

    process {
        if ('onprem_resolve' -notin $Object.PSObject.Properties.Name) {
            Write-Error "Unsupported pipeline object. This function only supports Security Policy objects as input. (Get-B1SecurityPolicy)"
            return $null
        } else {
            $PolicyID = $Object.id
        }
    
        [System.Collections.ArrayList]$Filters = @()
        [System.Collections.ArrayList]$QueryFilters = @()
        if ($CustomFilters) {
            $Filters.Add($CustomFilters) | Out-Null
        }
        if ($PolicyID) {
            $Filters.Add("policy_id==$PolicyID") | Out-Null
        }
        if ($ListID) {
            $Filters.Add("list_id==$ListID") | Out-Null
        }
        if ($CategoryFilterID) {
            $Filters.Add("category_filter_id==$CategoryFilterID") | Out-Null
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
            $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
        }
        if ($QueryFilters) {
            $QueryString = ConvertTo-QueryString $QueryFilters
        }
        Write-DebugMsg -Filters $QueryFilters
        if ($QueryString) {
          $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/security_policy_rules$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        } else {
          $Results = Invoke-CSP -Uri "$(Get-B1CspUrl)/api/atcfw/v1/security_policy_rules" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
        }
      
        if ($Results) {
          return $Results
        }
    }
}