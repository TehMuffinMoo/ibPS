﻿function Get-B1DiagnosticTask {
    <#
    .SYNOPSIS
        Query a list of BloxOneDDI Diagnostic Tasks

    .DESCRIPTION
        This function is used to query a list of BloxOneDDI Diagnostic Tasks

    .PARAMETER id
        The id of the diagnostic task to filter by

    .PARAMETER download
        This switch indicates if to download the results returned

    .Example
        Get-B1DiagnosticTask -id diagnostic/task/abcde634-2113-ddef-4d05-d35ffs1sa4 -download
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Tasks
    #>
  param(
    [Parameter(Mandatory=$true)]
    [String]$id,
    [Switch]$download
  )

  if ($download) {
    $URI = "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task/$($id)/download"
    $Result = Query-CSP -Method GET -Uri $URI
  } else {
    $URI = "https://csp.infoblox.com/atlas-onprem-diagnostic-service/v1/task/$($id)"
    $Result = Query-CSP -Method GET -Uri $URI | Select -ExpandProperty result -ErrorAction SilentlyContinue
  }


  if ($Result) {
    return $Result
  }
}