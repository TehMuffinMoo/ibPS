﻿function Remove-B1Location {
    <#
    .SYNOPSIS
        Removes a Location from the Infoblox Portal

    .DESCRIPTION
        This function is used to remove a Location from the Infoblox Portal

    .PARAMETER Name
        Filter the results by the name of the Location

    .PARAMETER Object
        The Location Object. Accepts pipeline input from Get-B1Location

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Location -Name "Madrid"

            Successfully deleted Location: Madrid

    .EXAMPLE
        PS> Get-B1Location -Name "Madrid" | Remove-B1Location

        Successfully deleted Location: Madrid

    .FUNCTIONALITY
        Universal DDI
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'High'
    )]
    param(
        [Parameter(Mandatory=$true,ParameterSetName="Default")]
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
        if (!($Object)) {
            $Object = Get-B1Location -Name $Name -Strict
        }
        if ($Object) {
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/location") {
              Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/location' objects as input"
              return $null
          }
          if ($Object.count -eq 1) {
            $ObjectID = ($Object.id -Split ('/'))[2]
            if($PSCmdlet.ShouldProcess("$($Object.name) ($($ObjectID))")){
                $null = Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/infra/v1/locations/$($ObjectID)"
                if (Get-B1Location -id $($Object.id)) {
                    Write-Error "Error. Failed to delete Location: $($Object.name)"
                } else {
                    Write-Host "Successfully deleted Location: $($Object.name)" -ForegroundColor Green
                }
            }
          } else {
            Write-Error "More than one result returned. To remove multiple objects, pipe Get-B1Location into Remove-B1Location instead"
          }
        } else {
            Write-Error "Location not found"
        }
    }
}