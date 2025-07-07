function Remove-B1CustomList {
    <#
    .SYNOPSIS
        Removes a Custom List from Infoblox Threat Defense

    .DESCRIPTION
        This function is used to remove named lists from Infoblox Threat Defense. These are referred to and displayed as Custom Lists within the CSP.

    .PARAMETER Name
        The name of the Custom List to remove.

        Whilst this is here, the API does not currently support filtering by name. (01/04/24)

        For now, you should instead use pipeline to remove objects as shown in the examples.

    .PARAMETER Object
        The Custom List Object. This accepts pipeline input from Get-B1CustomList

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Get-B1CustomList | Where-Object {$_.name -eq "My Custom List"} | Remove-B1CustomList

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
        DefaultParameterSetName="Default",
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Name,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Pipeline",
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($Object) {
            if ($Object.type -ne "custom_list") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'custom_list' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1CustomList -Name $($Name) -Strict
            if (!($Object)) {
                Write-Error "Unable to find Custom List: $($Name)"
                return $null
            }
        }
        if($PSCmdlet.ShouldProcess("$($Object.name) ($($Object.id))")){
            $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/named_lists/$($Object.id)"

            if (!(Get-B1CustomList -id $Object.id -EA SilentlyContinue -WA SilentlyContinue)) {
                Write-Host "Successfully removed Custom List: $($Object.name)" -ForegroundColor Green
            } else {
                Write-Error "Failed to remove Custom List: $($Object.name)"
            }
        }
    }
}