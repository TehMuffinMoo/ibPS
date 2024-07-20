function Remove-B1Host {
    <#
    .SYNOPSIS
        Removes an existing BloxOneDDI Host

    .DESCRIPTION
        This function is used to remove an existing BloxOneDDI Host

    .PARAMETER Name
        The name of the BloxOneDDI host to remove

    .PARAMETER Object
        The BloxOneDDI Host Object(s) to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Host -Name "bloxoneddihost1.mydomain.corp"

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Host
    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default",Mandatory=$true)]
      [String]$Name,
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
          if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/host") {
              $Object = Get-B1Host -id $($Object.id) -Detailed
              if (-not $Object) {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/host' objects as input"
                return $null
              }
              $HostID = $Object.id
          } else {
            $HostID = $SplitID[2]
          }
      } else {
          $Object = Get-B1Host -Name $Name -Strict -Detailed
          if (!($Object)) {
              Write-Error "Unable to find BloxOne Host: $($Name)"
              return $null
          }
          $HostID = $Object.id
      }

      if($PSCmdlet.ShouldProcess("$($Object.display_name) ($($HostID))")){
        Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/infra/v1/hosts/$($HostID)" | Out-Null
        $HID = Get-B1Host -id $($Object.id)
        if ($HID) {
          Write-Host "Error. Failed to delete BloxOneDDI Host: $($HID.display_name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully deleted BloxOneDDI Host: $($Object.display_name)" -ForegroundColor Green
        }
      }
    }
}