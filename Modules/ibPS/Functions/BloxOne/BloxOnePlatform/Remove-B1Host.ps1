function Remove-B1Host {
    <#
    .SYNOPSIS
        Removes an existing NIOS-X Host

    .DESCRIPTION
        This function is used to remove an existing NIOS-X Host

    .PARAMETER Name
        The name of the NIOS-X Host to remove

    .PARAMETER Object
        The NIOS-X Host Object(s) to remove. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will always prompt for confirmation unless -Confirm:$false or -Force is specified, or $ConfirmPreference is set to None.

    .EXAMPLE
        PS> Remove-B1Host -Name "ddihost1.mydomain.corp"

    .FUNCTIONALITY
        Universal DDI

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
              Write-Error "Unable to find NIOS-X Host: $($Name)"
              return $null
          }
          $HostID = $Object.id
      }

      if($PSCmdlet.ShouldProcess("$($Object.display_name) ($($HostID))")){
        Invoke-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/infra/v1/hosts/$($HostID)" | Out-Null
        $HID = Get-B1Host -id $($Object.id)
        if ($HID) {
          Write-Host "Error. Failed to delete NIOS-X Host: $($HID.display_name)" -ForegroundColor Red
        } else {
          Write-Host "Successfully deleted NIOS-X Host: $($Object.display_name)" -ForegroundColor Green
        }
      }
    }
}