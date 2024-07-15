function Get-B1GlobalNTPConfig {
    <#
    .SYNOPSIS
        Retrieves the BloxOneDDI Global NTP Configuration

    .DESCRIPTION
        This function is used to retrieve the BloxOneDDI Global NTP Configuration

    .EXAMPLE
        PS> Get-B1GlobalNTPConfig

    .OUTPUTS
        Global NTP Object

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        NTP
    #>
    $Result = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/ntp/v1/account/config"
    if ($Result) {
      $Result | Select-Object -ExpandProperty account_config
    } else {
      Write-Host "Error. No Global NTP Configuration defined." -ForegroundColor Red
    }
}