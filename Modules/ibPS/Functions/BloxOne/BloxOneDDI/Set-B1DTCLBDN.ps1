function Set-B1DTCLBDN {
    <#
    .SYNOPSIS
        Updates a LBDN object within BloxOne DTC

    .DESCRIPTION
        This function is used to updates a LBDN object within BloxOne DTC

    .PARAMETER Name
        The name of the DTC LBDN object to update

    .PARAMETER NewName
        Use -NewName to update the name of the DTC LBDN object

    .PARAMETER Description
        The new description for the DTC LBDN object

    .PARAMETER DNSView
        The new DNS View to assign to the DTC LBDN object

    .PARAMETER Policy
        The new Load Balancing Policy to assign to the DTC LBDN object

    .PARAMETER Precedence
        The new LBDN Precedence value

    .PARAMETER TTL
        The TTL to use for the DTC LBDN. This will override inheritance.

    .PARAMETER State
        Whether or not the new LBDN is enabled or disabled.

    .PARAMETER Tags
        Any tags you want to apply to the DTC LBDN

    .PARAMETER Object
        The DTC LBDN Object(s) to update. Accepts pipeline input.

    .EXAMPLE
       PS> Set-B1DTCLBDN -Name 'exchange.company.corp' -Description 'Exchange Servers LBDN' -DNSView 'Corporate' -Policy Exchange-Policy -Precedence 10 -TTL 10

        id                  : dtc/lbdn/17fgt5ge-g5v5-5yhh-cvbg-dfcwef9f4h8
        name                : exchange.company.corp.
        view                : dns/view/cs8f4833-4c44-4c4v-fgvd-jfggdfsta90
        dtc_policy          : @{policy_id=dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7; name=Exchange-Policy}
        precedence          : 10
        comment             : Exchange Servers LBDN
        disabled            : False
        ttl                 : 10
        tags                :
        inheritance_sources :

    .EXAMPLE
       PS> Get-B1DTCLBDN -Name 'exchange.company.corp' | Set-B1DTCLBDN -Description 'NEW LBDN' -DNSView 'Corporate' -Policy Exchange-Policy -Precedence 100 -TTL 60 -State Disabled

        id                  : dtc/lbdn/17fgt5ge-g5v5-5yhh-cvbg-dfcwef9f4h8
        name                : exchange.company.corp.
        view                : dns/view/cs8f4833-4c44-4c4v-fgvd-jfggdfsta90
        dtc_policy          : @{policy_id=dtc/policy/vduvr743-vcfr-jh9g-vcr3-fdbsv7bcd7; name=Exchange-Policy}
        precedence          : 100
        comment             : NEW LBDN
        disabled            : True
        ttl                 : 60
        tags                :
        inheritance_sources :

    .FUNCTIONALITY
        BloxOneDDI

    .FUNCTIONALITY
        DNS
    #>
    [Parameter(ParameterSetName="Default",Mandatory=$true)]
    param(
      [Parameter(ParameterSetName='Default',Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [String]$DNSView,
      [String]$Policy,
      [Int]$Precedence,
      [Int]$TTL,
      [ValidateSet("Enabled","Disabled")]
      [String]$State,
      [System.Object]$Tags,
      [Parameter(
          ValueFromPipeline = $true,
          ParameterSetName="With ID",
          Mandatory=$true
      )]
      [System.Object]$Object
    )

    process {
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/lbdn") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/lbdn' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCLBDN -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC LBDN: $($Name)"
                return $null
            }
        }

        $NewObj = $Object | Select-Object * -ExcludeProperty id,metadata

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($Precedence) {
            $NewObj.precedence = $Precedence
        }
        if ($DNSView) {
            $ViewID = (Get-B1DNSView -Name $DNSView -Strict).id
            if (!($ViewID)) {
                Write-Error "DNS View not found: $($DNSView)"
                return $null
            }
            $NewObj.view = $ViewID
        } else {
            $NewObj = $NewObj | Select-Object * -ExcludeProperty view
        }
        if ($Policy) {
            $DTCPolicy = Get-B1DTCPolicy -Name $Policy -Strict
            if (!($DTCPolicy)) {
                Write-Error "DTC Policy not found: $($Policy)"
                return $null
            }
            $NewObj.dtc_policy = @{ "policy_id" = $DTCPolicy.id }
        } else {
            $NewObj = $NewObj | Select-Object * -ExcludeProperty dtc_policy
        }
        if ($TTL) {
            $NewObj.ttl = $TTL
            $NewObj.inheritance_sources = @{
                "ttl" = @{
                    "action" = "override"
                }
            }
        }
        if ($State) {
            $NewObj.disabled = $(if ($State -eq 'Enabled') { $false } else { $true })
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }

        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress

        $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
        if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
            $Results | Select-Object -ExpandProperty result
        } else {
            $Results
        }
    }
}