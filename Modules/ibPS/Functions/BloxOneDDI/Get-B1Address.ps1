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
      [Parameter(ParameterSetName="ID")]
      [String]$id
    )

    process {
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
    
      [System.Collections.ArrayList]$Filters2 = @()
      if ($State) {
          $Filters2.Add("address_state=$State") | Out-Null
      }
      if ($Filter) {
        $Filters2.Add($Filter) | Out-Null
      }
      $Filters2.Add("_limit=$Limit") | Out-Null
      $Filters2.Add("_offset=$Offset") | Out-Null
      if ($tfilter) {
        $Filters2.Add("_tfilter=$tfilter") | Out-Null
      }
      $Filter2 = Combine-Filters2 $Filters2

      if ($Filter2) {
          $Results = Query-CSP -Uri "ipam/address$Filter2" -Method GET | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue
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