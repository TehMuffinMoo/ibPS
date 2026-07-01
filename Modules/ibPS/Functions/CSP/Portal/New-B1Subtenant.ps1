function New-B1Subtenant {
    <#
    .SYNOPSIS
        Creates a new Infoblox Portal Subtenant

    .DESCRIPTION
        This function is used to create a new Infoblox Portal Subtenant.

    .PARAMETER Name
        The name for the new Subtenant

    .PARAMETER Administrator
        The administrative user for the new Subtenant. This supports tab-completion.

    .PARAMETER Description
        The description for the new Subtenant

    .PARAMETER State
        The state of the new Subtenant. Valid values are "active" or "disabled". Default is "active"

    .EXAMPLE
        PS> New-B1Subtenant -Name "Dev" -Administrator "Admin User" -Description "Dev Subtenant"

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Authentication
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'Medium'
    )]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name,
        [Parameter(Mandatory=$true)]
        [System.Object]$Administrator,
        [String]$Description,
        [ValidateSet("active","disabled")]
        [String]$State = "active"
    )

    process {
      $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
      $AdministratorDetails = Get-B1User -Name $Administrator -Strict

      if ($AdministratorDetails -ne $null -and $AdministratorDetails.count -eq 1) {
        $Body = @{
          name = $Name
          admin_user = @{
            email = $AdministratorDetails.email
            name = $AdministratorDetails.name
          }
          description = $Description
          state = $State
        } | ConvertTo-Json -Depth 5

        if($PSCmdlet.ShouldProcess("Created new Infoblox Portal Subtenant $($Name)","Create new Infoblox Portal Subtenant",$MyInvocation.MyCommand)){
          $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/v2/sandbox/accounts" -Data $Body | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
          if ($Results) {
            return $Results
          } else {
            Write-Error "Error. Unable to create subtenant: $($Name)."
          }
        }
      } else {
        Write-Error "Error. Unable to find user: $($Administrator). Please ensure this is a valid user in the Infoblox Portal and try again."
      }
    }
}