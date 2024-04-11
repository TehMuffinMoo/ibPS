function Remove-B1Object {
    <#
    .SYNOPSIS
        Generic Wrapper for removing existing objects from the CSP (Cloud Services Portal)

    .DESCRIPTION
        This is a Generic Wrapper for removing existing objects from the CSP (Cloud Services Portal). It is recommended this is used via Pipeline

    .PARAMETER _ref
        The base URL of the object to remove

    .PARAMETER id
        The id of the object to remove

    .PARAMETER Force
        This is used to suppress the confirmation prompt if run non-interactively

    .EXAMPLE
        ## This example shows removing several address block objects based on tag

        PS> Get-B1Object -product 'BloxOne DDI' -App Ipamsvc -Endpoint /ipam/address_block -tfilter '("TagName"=="TagValue")' | Remove-B1Object -Force

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Core
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'High')]
    param(
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            Mandatory=$true
          )]
          [String]$_ref,
        [Parameter(
          ValueFromPipelineByPropertyName = $true,
          Mandatory=$true
        )]
        [String]$id,
        [Switch]$Force
    )

    process {
        if ($Force -and -not $Confirm) {
            $ConfirmPreference = 'None'
        }

        if ($PSCmdlet.ShouldProcess("$($id)")){
            Write-Host "Removing Object: $($_ref)/$($id)" -ForegroundColor Gray
            Invoke-CSP -Method DELETE -Uri "$($_ref)/$($id)"
        }
    }
}