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
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        ## This example shows removing several address block objects based on tag

        PS> Get-B1Object -product 'Universal DDI' -App Ipamsvc -Endpoint /ipam/address_block -tfilter '("TagName"=="TagValue")' | Remove-B1Object -Force

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Core
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
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
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters

        if ($PSCmdlet.ShouldProcess("$($id)")){
            Write-Host "Removing Object: $($_ref)/$($id)" -ForegroundColor Gray
            Invoke-CSP -Method DELETE -Uri "$($_ref)/$($id)"
        }
    }
}