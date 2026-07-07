function Set-B1IPAMHost {
    <#
    .SYNOPSIS
        Updates an existing IPAM Host Object in Universal DDI IPAM

    .DESCRIPTION
        This function is used to update an existing IPAM Host Object in Universal DDI IPAM. This only accepts pipeline input.

    .PARAMETER Tags
        Any tags you want to apply to the DHCP Range. This will overwrite existing tags.

    .PARAMETER Object
        The Range Object to update. Accepts pipeline input

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        PS> $MyHost = Get-B1IPAMHost "my-host"
        PS> $MyHost.addresses = @(
                @{
                    address = "10.0.0.1"
                    space = (Get-B1Space -Name 'my-space' -Strict).id
                    mac_addr = "aa:bb:cc:dd:ee:ff"
                    enable_dhcp = $true
                }
            )
        PS> $MyHost | Set-B1IPAMHost

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        IPAM

    .FUNCTIONALITY
        DHCP
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(
        ValueFromPipeline = $true,
        Mandatory=$true
      )]
      [System.Object]$Object,
      [Switch]$Force
    )

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "ipam/host") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'ipam/host' objects as input"
                return $null
            }
        }
        $NewObj = $Object | Select-Object * -ExcludeProperty id

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress
        if($PSCmdlet.ShouldProcess("Update IPAM Host:`n$(JSONPretty($JSON))","Update IPAM Host: $($Object.name) ($($Object.comment))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}