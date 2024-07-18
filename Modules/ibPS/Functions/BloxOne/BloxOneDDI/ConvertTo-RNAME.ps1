function ConvertTo-RNAME {
    <#
    .SYNOPSIS
        Uses the BloxOne API to convert an email address to RNAME format

    .DESCRIPTION
        This function uses the BloxOne API to convert an email address to RNAME format

    .PARAMETER Email
        The email address to convert into RNAME format

    .EXAMPLE
        PS> ConvertTo-RNAME -Email 'admin.user@company.corp'

        Email                   RNAME
        -----                   -----
        admin.user@company.corp admin\.user.company.corp

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Logs
    #>
    [CmdletBinding()]
    param(
      [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
      [string[]]$Email
    )

    process {
        $Results = @()
        foreach ($iEmail in $Email) {
            $Result = Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/convert_rname/$($iEmail)" -Method GET
            $Results += [PSCustomObject]@{
                "Email" = $iEmail
                "RNAME" = $Result.rname
            }
        }

        if ($Results) {
            return $Results
        } else {
            Write-Host "Error. Unable to convert email address to RNAME." -ForegroundColor Red
            break
        }
    }
}