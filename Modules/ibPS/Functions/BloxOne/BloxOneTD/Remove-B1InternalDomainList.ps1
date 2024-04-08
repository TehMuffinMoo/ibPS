function Remove-B1InternalDomainList {
    <#
    .SYNOPSIS
        Removes an existing Internal Domain list

    .DESCRIPTION
        This function is used to remove an existing Internal Domain list

    .PARAMETER Name
        The name of the Internal Domain list to remove

    .PARAMETER Object
        The Internal Domain List object to remove. Expects pipeline input

    .EXAMPLE
        PS> Get-B1InternalDomainList -Name 'My List' | Remove-B1InternalDomainList

        Successfully deleted Internal Domain list: My List / 123456
    
    .FUNCTIONALITY
        BloxOneDDI
    
    .FUNCTIONALITY
        Threat Defense
    #>
    param(
      [Parameter(Mandatory=$true,ParameterSetName="Default")]
      [String]$Name,
      [Parameter(
        ValueFromPipeline = $true,
        ParameterSetName="Pipeline",
        Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {

      if (!($Object)) {
        $id = (Get-B1InternalDomainList -Name $Name -Strict).id
        if (!($id)) {
          Write-Error "Unable to find Internal Domain list with name: $($Name)"
          return $null
        }
      } else {
        if (!($Object.id -and $($Object.name))) {
          Write-Error 'Invalid input object. This cmdlet only accepts input from Get-B1InternalDomainList'
          return $null
        } else {
          $id = $Object.id
          $Name = $Object.name
        }
      }

      $JSON = @{
        "ids" = @(
          $id
        )
      } | ConvertTo-Json -Depth 2
      $Result = Query-CSP -Method DELETE -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/internal_domain_lists" -Data $JSON
      if ((Get-B1InternalDomainList -Name $Name -Strict).id) {
        Write-Error "Failed to delete Internal Domain list: $($Name) / $($id)"
        break
      } else {
        Write-Host "Successfully deleted Internal Domain list: $($Name) / $($id)" -ForegroundColor Green
      }
    }
}