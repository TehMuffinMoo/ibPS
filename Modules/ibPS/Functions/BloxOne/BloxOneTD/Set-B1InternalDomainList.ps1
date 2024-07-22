function Set-B1InternalDomainList {
    <#
    .SYNOPSIS
        Updates an existing Internal Domain list

    .DESCRIPTION
        This function is used to update an existing Internal Domain list

    .PARAMETER Name
        The name of the Internal Domain list to update. The name can be updated by changing the value of name when using pipeline input

    .PARAMETER Description
        The new description for the Internal Domain list

    .PARAMETER Domains
        The list of domains to update the Internal Domain list with. This will overwrite the current list, so the existing list should be obtained and subtracted/appended prior to submission.

    .PARAMETER Tags
        A list of tags to update the Internal Domain list with. This will overwrite existing tags.

    .PARAMETER Object
        The Internal Domain List object to update. Expects pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        $List = Get-B1InternalDomainList -Name 'My List'
        $List.internal_domains += 'new.corp.local'
        $List | Set-B1InternalDomainList

        Internal Domain List  updated successfully.

        created_time     : 1/1/0001 12:00:00AM
        description      : A list of domains
        id               : 793538
        internal_domains : {new.corp.local, ext.domain.corp, mydomain.corp, partner.corp}
        is_default       : False
        name             : My List
        tags             : @{Owner=Me}
        updated_time     : 1/1/0001 12:00:00AM


    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true,ParameterSetName="None")]
      [String]$Name,
      [Parameter(ParameterSetName="None")]
      [String]$Description,
      [Parameter(ParameterSetName="None")]
      [System.Object]$Domains,
      [Parameter(ParameterSetName="None")]
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
        if (!($Object)) {
            $Object = Get-B1InternalDomainList -Name $Name -Strict
            if (!($Object)) {
              Write-Error "Unable to find Internal Domain list with name: $($Name)"
              return $null
            } else {
                if ($Domains) {
                    $Object.internal_domains = $Domains
                }
                if ($Description) {
                    $Object.description = $Description
                }
                if ($Tags) {
                    $Object.tags = $Tags
                }
            }
          } else {
            if (!($Object.id -and $($Object.name) -and $($Object.internal_domains))) {
              Write-Error 'Invalid input object. This cmdlet only accepts input from Get-B1InternalDomainList'
              return $null
            }
          }

        $Splat = $Object | Select-Object -Exclude created_time,updated_time,id,is_default

        $JSON = $Splat | ConvertTo-Json -Depth 4
        if($PSCmdlet.ShouldProcess("Update Internal Domain List:`n$(JSONPretty($JSON))","Update Internal Domain List: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Result = Invoke-CSP -Method PUT -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/internal_domain_lists/$($Object.id)" -Data $JSON | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
            if ($Result.id -eq $($Object.id)) {
                Write-Host "Internal Domain List $Name updated successfully." -ForegroundColor Green
                return $Result
            } else {
                Write-Host "Failed to update Internal Domain List $Name." -ForegroundColor Red
                break
            }
        }
    }
}