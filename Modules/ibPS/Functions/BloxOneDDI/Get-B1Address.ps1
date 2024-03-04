function Get-B1Address {
    <#
    .SYNOPSIS
        Queries a list of address objects from the BloxOneDDI IPAM

    .DESCRIPTION
        This function is used to query a list of address objects from the BloxOneDDI IPAM

    .PARAMETER Address
        Use this parameter to filter by IP Address

    .PARAMETER State
        Use this parameter to filter by State

    .PARAMETER Reserved
        Use this parameter to filter the list of addresses to those which have a usage of Reserved

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: https://ibps.readthedocs.io/en/latest/#custom-filters

    .PARAMETER id
        Return results based on the address id

    .EXAMPLE
        Get-B1Address -Address "10.0.0.1" -Reserved -Fixed
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param(
      [Parameter(ParameterSetName="noID")]
      [String]$Address,
      [Parameter(ParameterSetName="noID")]
      [String]$State,
      [Switch]$Reserved,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      $CustomFilters,
      [Parameter(ParameterSetName="ID")]
      [String]$id
    )

    process {
      if ($CustomFilters) {
        $Filter = "_filter="+(Combine-Filters $CustomFilters)
      } else {
        [System.Collections.ArrayList]$Filters = @()
        if ($Address) {
            $Filters.Add("address==`"$Address`"") | Out-Null
        }
        if ($State) {
            $Filters.Add("state==`"$State`"") | Out-Null
        }
        if ($id) {
            $Filters.Add("id==`"$id`"") | Out-Null
        }
        if ($Filters) {
            $Filter = "_filter="+(Combine-Filters $Filters)
        }
      }
      [System.Collections.ArrayList]$QueryFilters = @()
      if ($State) {
          $QueryFilters.Add("address_state=$State") | Out-Null
      }
      if ($Filter) {
        $QueryFilters.Add($Filter) | Out-Null
      }
      $QueryFilters.Add("_limit=$Limit") | Out-Null
      $QueryFilters.Add("_offset=$Offset") | Out-Null
      if ($Fields) {
        $Fields += "id"
        $QueryFilters.Add("_fields=$($Fields -join ",")") | Out-Null
      }
      if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
      }
      $QueryString = ConvertTo-QueryString $QueryFilters

      if ($QueryString) {
          $Results = Query-CSP -Uri "ipam/address$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
      } else {
          $Results = Query-CSP -Uri "ipam/address" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
      }
  
      if ($Results -and $Reserved) {
          if ($Reserved) {
              $Results = $Results | Where-Object {$_.usage -contains "IPAM RESERVED"}
          }
      }
      return $Results
    }
}