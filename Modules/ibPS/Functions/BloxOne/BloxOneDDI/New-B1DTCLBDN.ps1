function New-B1DTCLBDN {
    <#
    .SYNOPSIS
        Creates a new LBDN object within Universal DDI DTC

    .DESCRIPTION
        This function is used to create a new LBDN object within Universal DDI DTC

    .PARAMETER Name
        The name of the DTC LBDN object to create

    .PARAMETER Description
        The description for the new LBDN object

    .PARAMETER DNSView
        The DNS View to assign the new LBDN to

    .PARAMETER Policy
        The Load Balancing Policy to use

    .PARAMETER Precedence
        The LBDN Precedence value

    .PARAMETER TTL
        The TTL to use for the DTC LBDN. This will override inheritance.

    .PARAMETER State
        Whether or not the new LBDN is created as enabled or disabled. Defaults to enabled

    .PARAMETER Tags
        Any tags you want to apply to the DTC LBDN

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
       PS> New-B1DTCLBDN -Name 'exchange.company.corp' -Description 'Exchange Servers LBDN' -DNSView 'Corporate' -Policy Exchange-Policy -Precedence 100 -TTL 10

        id                  : dtc/lbdn/17fgt5ge-g5v5-5yhh-cvbg-dfcwef9f4h8
        name                : exchange.company.corp.
        view                : dns/view/cs8f4833-4c44-4c4v-fgvd-jfggdfsta90
        dtc_policy          : @{policy_id=dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7; name=Exchange-Policy}
        precedence          : 100
        comment             : Exchange Servers LBDN
        disabled            : False
        ttl                 : 10
        tags                :
        inheritance_sources :

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(Mandatory=$true)]
      [String]$Name,
      [String]$Description,
      [Parameter(Mandatory=$true)]
      [String]$DNSView,
      [String]$Policy,
      [Int]$Precedence,
      [Int]$TTL,
      [ValidateSet("Enabled","Disabled")]
      [String]$State = 'Enabled',
      [System.Object]$Tags,
      [Switch]$Force
    )
    $ConfirmPreference = Confirm-ShouldProcess $PSBoundParameters
    $ViewID = (Get-B1DNSView -Name $DNSView -Strict).id
    if (!($ViewID)) {
        Write-Error "DNS View not found: $($DNSView)"
        return $null
    }

    if ($Policy) {
        $DTCPolicy = Get-B1DTCPolicy -Name $Policy -Strict
        if (!($DTCPolicy)) {
            Write-Error "DTC Policy not found: $($Policy)"
            return $null
        }
    }

    $splat = @{
        "name" = $Name
        "comment" = $Description
        "view" = $ViewID
        "disabled" = $(if ($State -eq 'Enabled') { $false } else { $true })
        "precedence" = $Precedence
        "dtc_policy" = $(if ($Policy) { @{ "policy_id" = $DTCPolicy.id } } else { @{} })
        "tags" = $Tags
    }
    if ($TTL) {
        $splat += @{
            "ttl" = $TTL
            "inheritance_sources" = @{
                "ttl" = @{
                    "action" = "override"
                }
            }
        }
    }

    $JSON = $splat | ConvertTo-Json -Depth 5 -Compress
    if($PSCmdlet.ShouldProcess("Create new DTC LBDN:`n$(JSONPretty($JSON))","Create new DTC LBDN: $($Name)",$MyInvocation.MyCommand)){
        $Results = Invoke-CSP -Method POST -Uri "$(Get-B1CSPUrl)/api/ddi/v1/dtc/lbdn" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}