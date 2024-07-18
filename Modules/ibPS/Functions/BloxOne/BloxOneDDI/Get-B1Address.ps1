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

    .PARAMETER Compartment
        Filter the results by Compartment Name

    .PARAMETER Limit
        Use this parameter to limit the quantity of results. The default number of results is 1000.

    .PARAMETER Offset
        Use this parameter to offset the results by the value entered for the purpose of pagination

    .PARAMETER tfilter
        Use this parameter to filter the results returned by tag.

    .PARAMETER Fields
        Specify a list of fields to return. The default is to return all fields.

    .PARAMETER OrderBy
        Optionally return the list ordered by a particular value. If sorting is allowed on non-flat hierarchical resources, the service should implement a qualified naming scheme such as dot-qualification to reference data down the hierarchy. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER OrderByTag
        Optionally return the list ordered by a particular tag value. Using 'asc' or 'desc' as a suffix will change the ordering, with ascending as default.

    .PARAMETER CustomFilters
        Accepts either an Object, ArrayList or String containing one or more custom filters.
        See here for usage: See here for usage: https://ibps.readthedocs.io/en/latest/#-customfilters

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
      [Parameter(ParameterSetName="With Address")]
      [String]$Address,
      [Parameter(ParameterSetName="With Address")]
      [String]$State,
      [Parameter(ParameterSetName="With Address")]
      [String]$Space,
      [Switch]$Reserved,
      [String]$Compartment,
      [Int]$Limit = 1000,
      [Int]$Offset = 0,
      [String]$tfilter,
      [String[]]$Fields,
      [String]$OrderBy,
      [String]$OrderByTag,
      $CustomFilters,
      [Parameter(ParameterSetName="With ID")]
      [String]$id
    )

    process {
      [System.Collections.ArrayList]$Filters = @()
      [System.Collections.ArrayList]$QueryFilters = @()
      if ($CustomFilters) {
        $Filters.Add($CustomFilters) | Out-Null
      }
      if ($Address) {
        $Filters.Add("address==`"$Address`"") | Out-Null
      }
      if ($State) {
        $Filters.Add("state==`"$State`"") | Out-Null
      }
      if ($Space) {
        $SpaceUUID = (Get-B1Space -Name $Space -Strict).id
        $Filters.Add("space==`"$SpaceUUID`"") | Out-Null
    }
      if ($id) {
        $Filters.Add("id==`"$id`"") | Out-Null
      }
      if ($Compartment) {
        $CompartmentID = (Get-B1Compartment -Name $Compartment -Strict).id
        if ($CompartmentID) {
            $Filters.Add("compartment_id==`"$CompartmentID`"") | Out-Null
        } else {
            Write-Error "Unable to find compartment with name: $($Compartment)"
            return $null
        }
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
      if ($tfilter) {
        $QueryFilters.Add("_tfilter=$tfilter") | Out-Null
      }
      if ($OrderBy) {
        $QueryFilters.Add("_order_by=$OrderBy") | Out-Null
      }
      if ($OrderByTag) {
        $QueryFilters.Add("_torder_by=$OrderByTag") | Out-Null
      }
      $QueryString = ConvertTo-QueryString $QueryFilters
      Write-DebugMsg -Filters $QueryFilters
      if ($QueryString) {
          $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/address$QueryString" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
      } else {
          $Results = Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/ipam/address" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
      }

      if ($Results -and $Reserved) {
          if ($Reserved) {
              $Results = $Results | Where-Object {$_.usage -contains "IPAM RESERVED"}
          }
      }
      return $Results
    }
}