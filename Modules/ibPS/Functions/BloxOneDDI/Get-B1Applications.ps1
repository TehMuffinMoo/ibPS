function Get-B1Applications {
    <#
    .SYNOPSIS
        Retrieves a list of supported BloxOneDDI Applications

    .DESCRIPTION
        This function is used query a list of supported BloxOneDDI Applications/Services

    .Example
        Get-B1Applications
    
    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Service
    #>
    $Results = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/infra/v1/applications" | select -ExpandProperty results | select -ExpandProperty applications -ErrorAction SilentlyContinue
    
    if ($Results) {
      return $Results
    } else {
      Write-Host "Error. No BloxOneDDI Applications found." -ForegroundColor Red
    }
}