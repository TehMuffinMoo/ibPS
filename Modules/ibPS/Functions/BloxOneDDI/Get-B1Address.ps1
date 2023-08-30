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

    .Example
        Get-B1Address -Address "10.0.0.1" -Reserved -Fixed
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        IPAM
    #>
    param(
      [Parameter(ParameterSetName="noID")]
      [String]$Address,
      [Parameter(ParameterSetName="noID")]
      [String]$State,
      [Switch]$Reserved,
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
    
      if ($State) {
          [System.Collections.ArrayList]$Filters2 = @()
          if ($Filter) {
              $Filters2.Add($Filter) | Out-Null
          }
          $Filters2.Add("address_state=$State") | Out-Null
          $Filter2 = Combine-Filters2 $Filters2
      } 
      if ($Filter2) {
          $Results = Query-CSP -Uri "ipam/address$Filter2" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
      } elseif ($Filter) {
          $Filter2 = Combine-Filters2 $Filter
          $Results = Query-CSP -Uri "ipam/address$Filter2" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue    
      } else {
          $Results = Query-CSP -Uri "ipam/address" -Method GET | select -ExpandProperty results -ErrorAction SilentlyContinue
      }
  
      if ($Results -and $Reserved) {
          if ($Reserved) {
              $Results = $Results | where {$_.usage -contains "IPAM RESERVED"}
          }
      }
      return $Results
    }
}