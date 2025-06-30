function New-B1InternalDomainList {
    <#
    .SYNOPSIS
        Creates a new Internal Domain list

    .DESCRIPTION
        This function is used to create a new Internal Domain list

    .PARAMETER Name
        The name of the Internal Domain list to create

    .PARAMETER Description
        The description of the Internal Domain list to create

    .PARAMETER Domains
        The list of domains to add to the new Internal Domain list

    .PARAMETER Tags
        A list of tags to add to the new Internal Domain list

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> New-B1InternalDomainList -Name 'My List' -Description 'A list of domains' -Domains 'mydomain.corp','ext.domain.corp','partner.corp' -Tags @{'Owner'='Me'}

        Internal Domain List My List created successfully.

        created_time     : 4/8/2024 10:49:21AM
        description      : A list of domains
        id               : 123456
        internal_domains : {mydomain.corp, ext.domain.corp, partner.corp}
        is_default       : False
        name             : My List
        tags             : @{Owner=Me}
        updated_time     : 4/8/2024 10:49:21AM


    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [System.Object]$Domains,
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $Splat = @{
        "name" = $Name
        "description" = $Description
    }
    if ($Domains) {
        $Splat | Add-Member -MemberType NoteProperty -Name "internal_domains" -Value $Domains
    }
    if ($Tags) {
        $Splat | Add-Member -MemberType NoteProperty -Name "tags" -Value $Tags
    }

    $JSON = $Splat | ConvertTo-Json -Depth 4

    if($PSCmdlet.ShouldProcess("Create new Internal Domain List:`n$($JSON)","Create new Internal Domain List: $($Name)",$MyInvocation.MyCommand)){
        $Result = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/internal_domain_lists" -Data $JSON | Select-Object -ExpandProperty results -EA SilentlyContinue -WA SilentlyContinue
        if ($Result.name -eq $Name) {
            Write-Host "Internal Domain List $Name created successfully." -ForegroundColor Green
            return $Result
        } else {
            Write-Host "Failed to create Internal Domain List $Name." -ForegroundColor Red
            break
        }
    }

}