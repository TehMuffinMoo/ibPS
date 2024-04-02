function Remove-B1NetworkList {
    <#
    .SYNOPSIS
        Removes a network list from BloxOne Threat Defense

    .DESCRIPTION
        This function is used to remove a network list from BloxOne Threat Defense

    .PARAMETER Name
        The name of the network list to remove

    .PARAMETER id
        The id of the network list to remove

    .EXAMPLE
        PS> Remove-B1NetworkList -Name "My Network List"

    .EXAMPLE
        PS> Get-B1NetworkList -Name "My Network List" | Remove-B1NetworkList
   
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
        $NetworkList = Get-B1NetworkList -Name $Name -Strict
      } elseif ($id) {
        $NetworkList = Get-B1NetworkList -id $id
      } else {
        Write-Error "Neither -Name or -id were specified in the request."
      }

      if ($NetworkList) {
        Query-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/network_lists/$($NetworkList.id)"
        if ($Name) {
            $NetworkListCheck = Get-B1NetworkList -Name $Name -Strict
        } elseif ($id) {
            $NetworkListCheck = Get-B1NetworkList -id $id -ErrorAction SilentlyContinue -WarningAction SilentlyContinue 6> $null
        }
        if ($NetworkListCheck) {
            Write-Error "Failed to delete network list: $($NetworkList.name)"
        } else {
            Write-Host "Successfully deleted network list: $($NetworkList.name)" -ForegroundColor Green
        }
      } else {
        Write-Error "Unable to find network list: $id$Name"
      }
    }
}