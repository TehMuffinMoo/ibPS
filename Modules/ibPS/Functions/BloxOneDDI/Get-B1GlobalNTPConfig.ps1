function Get-B1GlobalNTPConfig {
    <#
    .SYNOPSIS
        Retrieves the BloxOneDDI Global NTP Configuration

    .DESCRIPTION
        This function is used to retrieve the BloxOneDDI Global NTP Configuration

    .Example
        Get-B1NTPGlobalConfig
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        NTP
    #>
    $Result = Query-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ntp/v1/account/config"
    if ($Result) {
      $Result | Select-Object -ExpandProperty account_config
    } else {
      Write-Host "Error. No Global NTP Configuration defined." -ForegroundColor Red
    }
}