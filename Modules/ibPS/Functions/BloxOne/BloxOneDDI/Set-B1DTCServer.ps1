function Set-B1DTCServer {
    <#
    .SYNOPSIS
        Updates a server object within BloxOne DTC

    .DESCRIPTION
        This function is used to update a server object within BloxOne DTC

    .PARAMETER Name
        The name of the DTC server object to update

    .PARAMETER NewName
        Use -NewName to update the name of the DTC Server object

    .PARAMETER Description
        The new description for the DTC server

    .PARAMETER FQDN
        The new FQDN for the DTC Server. The -FQDN and -IP option are mutually exclusive.

    .PARAMETER IP
        The new IP for the DTC Server. The -IP and -FQDN option are mutually exclusive.

    .PARAMETER AutoCreateResponses
        If enabled, DTC response will contain an auto-created A (IPv4), AAAA (IPv6), CNAME(FQDN) record with endpoint defined using -IP or -FQDN.

    .PARAMETER SynthesizedCNAME
        The Synthesized CNAME record to update on the DTC Server. This cannot be used in conjunction with -AutoCreateResponses

    .PARAMETER SynthesizedA
        The Synthesized A record(s) to update on the DTC Server.

    .PARAMETER State
        Whether or not the new server is created as enabled or disabled. Defaults to enabled

    .PARAMETER Tags
        Any tags you want to apply to the DTC Server.

    .PARAMETER Object
        The DTC Server Object(s) to update. Accepts pipeline input.

    .EXAMPLE
       PS> Set-B1DTCServer -Name 'Exchange Server A' -Description 'New Exchange Node' -FQDN 'exchange-3.company.corp'

        id                           : dtc/server/fsfsef8f3-3532-643h-jhjr-sdgfrgrg51349
        name                         : Exchange Server A
        comment                      : New Exchange Node
        tags                         :
        disabled                     : False
        address                      :
        records                      : {@{type=CNAME; rdata=; dns_rdata=exchange-3.company.corp}}
        fqdn                         : exchange-3.company.corp.
        endpoint_type                : fqdn
        auto_create_response_records : False
        metadata                     :

    .EXAMPLE
       PS> Get-B1DTCServer -Name 'Exchange Server B' | Set-B1DTCServer -State Disabled

        id                           : dtc/server/fg5hh56-3tf2-g54r-jbh6r-xsdvsrgzdv45
        name                         : Exchange Server B
        comment                      : New Exchange Node
        tags                         :
        disabled                     : True
        address                      :
        records                      : {@{type=CNAME; rdata=; dns_rdata=exchange-2.company.corp}}
        fqdn                         : exchange-2.company.corp.
        endpoint_type                : fqdn
        auto_create_response_records : False
        metadata

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
      [String]$FQDN,
      [IPAddress]$IP,
      [ValidateSet("Enabled","Disabled")]
      [String]$AutoCreateResponses,
      [IPAddress[]]$SynthesizedA,
      [String]$SynthesizedCNAME,
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
            if (("$($SplitID[0])/$($SplitID[1])") -ne "dtc/server") {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dtc/server' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DTCServer -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find DTC Server: $($Name)"
                return $null
            }
        }
        if ($FQDN -and $IP) {
            Write-Error "-FQDN and -IP are mutually exclusive parameters, you can only use one."
            return $null
        }
        if ($SynthesizedA -and $SynthesizedCNAME) {
            Write-Error 'You cannot specify both A and CNAME records for synthesized responses.'
            return $null
        }

        $NewObj = $Object | Select-Object * -ExcludeProperty id,metadata
        $NewObj.records = @()
        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($FQDN) {
            $NewObj.fqdn = $FQDN
        } else {
            $NewObj = $NewObj | Select-Object * -ExcludeProperty fqdn
        }
        if ($IP) {
            $NewObj.address = $IP
        } else {
            $NewObj = $NewObj | Select-Object * -ExcludeProperty address
        }
        if ($AutoCreateResponses) {
            $NewObj.auto_create_response_records = $(if ($AutoCreateResponses -eq 'Enabled') { $true } else { $false })
        }
        if ($State) {
            $NewObj.disabled = $(if ($State -eq 'Enabled') { $false } else { $true })
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($SynthesizedA) {
            foreach ($SynthesizedARecord in $SynthesizedA) {
                $NewObj.records += @{
                    "type" = "A"
                    "rdata" = @{
                        "address" = $SynthesizedARecord.IPAddressToString
                    }
                }
            }
        }
        if ($SynthesizedCNAME) {
            if ($AutoCreateResponses) {
                Write-Error 'You cannot specify both -AutoCreateResponses and -SynthesizedCNAME parameters as they are mutually exclusive.'
                break
            }
            $NewObj.records += @{
                "type" = "CNAME"
                "rdata" = @{
                    "cname" = $SynthesizedCNAME
                }
            }
        }
        if ($NewObj.records.Count -eq 0) {
            $NewObj = $NewObj | Select-Object * -ExcludeProperty records
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