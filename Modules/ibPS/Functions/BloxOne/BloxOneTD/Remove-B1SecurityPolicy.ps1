function Remove-B1SecurityPolicy {
    <#
    .SYNOPSIS
        Removes a BloxOne Threat Defense Security Policy

    .DESCRIPTION
        This function is used to remove a BloxOne Threat Defense Security Policy

    .PARAMETER id
        The id of the BloxOne Threat Defense Security Policy. Accepts pipeline input

    .PARAMETER Name
        The name of the BloxOne Threat Defense Security Policy to delete.

    .EXAMPLE
        PS> Remove-B1SecurityPolicy -Name "Remote Users"

    .EXAMPLE
        PS> Get-B1SecurityPolicy -Name "Remote Users" | Remove-B1SecurityPolicy
   
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
      [parameter(ParameterSetName="Default")]
      [String]$Name,
      [Parameter(
        ValueFromPipelineByPropertyName = $true,
        ParameterSetName="With ID",
        Mandatory=$true
      )]
      [String]$id
    )

    process {
      if ($Name) {
        $SecurityPolicy = Get-B1SecurityPolicy -Name $Name
      } elseif ($id) {
        $SecurityPolicy = Get-B1SecurityPolicy -id $id
      } else {
        Write-Error "Neither -Name or -id were specified."
      }

      if ($SecurityPolicy) {
        Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/security_policies/$($SecurityPolicy.id)"
        if ($Name) {
            $SecurityPolicyCheck = Get-B1SecurityPolicy -Name $Name -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        } elseif ($id) {
            $SecurityPolicyCheck = Get-B1SecurityPolicy -id $id -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 6> $null
        }
        if ($SecurityPolicyCheck) {
            Write-Error "Failed to delete security policy: $($SecurityPolicy.name)"
        } else {
            Write-Host "Successfully deleted security policy: $($SecurityPolicy.name)" -ForegroundColor Green
        }
      } else {
        Write-Error "Unable to find security policy: $id$Name"
      }
    }
}