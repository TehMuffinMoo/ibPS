function Set-B1Service {
    <#
    .SYNOPSIS
        Updates an existing NIOS-X Service

    .DESCRIPTION
        This function is used to update an existing NIOS-X Service

    .PARAMETER Name
        The name of the NIOS-X Service to update.

    .PARAMETER NewName
        Use -NewName to update the name of the NIOS-X Service

    .PARAMETER Description
        The description of the NIOS-X Service

    .PARAMETER Server
        The name of the NIOS-X Host to assign the service to

    .PARAMETER Tags
        A list of tags to apply to this Service. This will overwrite existing tags.

    .PARAMETER Object
        The service object to update. Accepts pipeline input from Get-B1Service

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to High.

    .EXAMPLE
        PS> Set-B1Service -Name "DNS_MyServer" -Description "This is my new description" -Tags @{"tag1"="value1";"tag2"="value2"}

    .EXAMPLE
        PS> Get-B1Service -Name "DNS_MyServer" | Set-B1Service -NewName "DNS_MyServer"

    .FUNCTIONALITY
        NIOS-X

    #>
    [CmdletBinding(
      SupportsShouldProcess,
      ConfirmImpact = 'High'
    )]
    param(
      [Parameter(ParameterSetName="Default")]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [String]$Server,
      [System.Object]$Tags,
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
          $SplitID = $Object.id.split('/')
          if (("$($SplitID[0])/$($SplitID[1])") -ne "infra/service") {
              $Object = Get-B1Service -id $($Object.id)
              if (-not $Object) {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'infra/service' objects as input"
                return $null
              }
              $SplitID = $Object.id.split('/')
              $ServiceID = $SplitID[2]
          } else {
            $ServiceID = $SplitID[2]
          }
      } else {
          $Object = Get-B1Service -Name $Name -Strict
          if (!($Object)) {
              Write-Error "Unable to find Service: $($Name)"
              return $null
          }
          $SplitID = $Object.id.split('/')
          $ServiceID = $SplitID[2]
      }

      $NewObj = $Object | Select-Object * -ExcludeProperty id,created_at,composite_state,current_version

      if ($NewName) {
        $NewObj.name = $NewName
      }
      if ($Description) {
        if ($NewObj.description) {
            $NewObj.description = $Description
        } else {
            $NewObj | Add-Member -MemberType NoteProperty -Name "description" -Value $Description
        }
      }
      if ($Server) {
        $B1HostInfo = Get-B1Host -Name $Server -Detailed
        if ($B1HostInfo) {
            if ($B1HostInfo.count -gt 1) {
                Write-Host "Too many hosts returned. Please check the -name parameter, or use -Strict for strict parameter checking." -ForegroundColor Red
                $B1HostInfo | Format-Table -AutoSize
            } else {
              $NewObj.pool_id = $($B1HostInfo.pool.pool_id)
            }
        } else {
            Write-Error "Unable to find NIOS-X Host: $($Server)"
            return $null
        }
      }
      if ($Tags) {
        if ($NewObj.tags) {
            $NewObj.tags = $Tags
        } else {
            $NewObj | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
        }
      }

      $JSON = $NewObj | ConvertTo-Json -Depth 10 -Compress
      if($PSCmdlet.ShouldProcess("Update NIOS-X Service`n$(JSONPretty($JSON))","Update NIOS-X Service: $($Object.name) ($($NewObj.id))",$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/infra/v1/services/$ServiceID" -Data $JSON | Select-Object -ExpandProperty result -ErrorAction SilentlyContinue
        if ($Results.id -and $($Results.id.split('/')[2]) -eq $($ServiceID)) {
          return $Results
        } else {
          Write-Error "Failed to update NIOS-X Service: $($Object.name)."
          return $Results
        }
      }
    }
}