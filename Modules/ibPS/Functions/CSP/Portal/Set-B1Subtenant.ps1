function Set-B1Subtenant {
    <#
    .SYNOPSIS
        Updates an existing Infoblox Portal Subtenant

    .DESCRIPTION
        This function is used to update an existing Infoblox Portal Subtenant, such as changing its state or updating its details.
        This only accepts pipeline input

    .PARAMETER Name
        The new name of the Infoblox Portal Subtenant

    .PARAMETER Administrator
        The administrative user for the Infoblox Portal Subtenant

    .PARAMETER Description
        The description for the Infoblox Portal Subtenant

    .PARAMETER State
        The state of the Infoblox Portal Subtenant. Valid values are "active" or "disabled"

    .PARAMETER Object
        The Infoblox Portal Subtenant Object. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> Set-B1Subtenant -Name "Dev" -Administrator "Admin User" -Description "Dev Subtenant" -State "disabled"

    .EXAMPLE
        PS> Get-B1Subtenant -Name "Dev" | Set-B1Subtenant -Administrator "Admin User" -Description "Dev Subtenant" -State "active"

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
        $Name,
        $Administrator,
        $Description,
        [ValidateSet("active", "disabled")]
        $State,
        [Parameter(
          ValueFromPipeline = $true,
          ParameterSetName="Object",
          Mandatory=$true
        )]
        [System.Object]$Object,
        [Switch]$Force
    )

    process {
        $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "identity/accounts") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'identity/accounts' objects as input"
                return $null
            }
        } else {
            Write-Error "Error. This function only supports pipeline input. Please provide a valid Infoblox Portal Subtenant object from Get-B1Subtenant"
            return $null
        }
        $NewObj = $Object | Select-Object name,description,admin_user,state
        $NewObj.admin_user = $NewObj.admin_user | Select-Object email,name

        $APIKeyIdSplit = $Object.id -split "identity/accounts/"
        if ($Name) {
            $NewObj.name = $Name
        }
        if ($Administrator) {
            $AdministratorDetails = Get-B1User -Name $Administrator -Strict
            if ($AdministratorDetails -ne $null -and $AdministratorDetails.count -eq 1) {
                $NewObj.admin_user = @{
                    email = $AdministratorDetails.email
                    name = $AdministratorDetails.name
                }
            } else {
                Write-Error "Error. Unable to find user: $($Administrator). Please ensure this is a valid user in the Infoblox Portal and try again."
                return $null
            }
        }
        if ($Description) {
            $NewObj.description = $Description
        }
        if ($State) {
            $NewObj.state = $State
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        if($PSCmdlet.ShouldProcess("Update Infoblox Portal Subtenant`n$(JSONPretty($JSON))","Update Infoblox Portal Subtenant: $($NewObj.name) ($($APIKeyIdSplit[1]))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/v2/sandbox/accounts/$($APIKeyIdSplit[1])" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}