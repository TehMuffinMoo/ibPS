function ConvertTo-RNAME {
    <#
    .SYNOPSIS
        Uses the BloxOne API to convert an email address to RNAME format

    .DESCRIPTION
        This function uses the BloxOne API to convert an email address to RNAME format

    .PARAMETER Email
        The email address to convert into RNAME format

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Low.

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
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param(
      [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
      [string[]]$Email,
      [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        $Results = @()
        foreach ($iEmail in $Email) {
            if($PSCmdlet.ShouldProcess("Convert $($iEmail) to RNAME","Convert $($iEmail) to RNAME",$MyInvocation.MyCommand)){
                $Result = Invoke-CSP -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dns/convert_rname/$($iEmail)" -Method GET
                $Results += [PSCustomObject]@{
                    "Email" = $iEmail
                    "RNAME" = $Result.rname
                }
                $ShouldProcess = $true
            }
        }

        if ($ShouldProcess) {
            if ($Results) {
                return $Results
            } else {
                Write-Host "Error. Unable to convert email address to RNAME." -ForegroundColor Red
                break
            }
        }
    }
}