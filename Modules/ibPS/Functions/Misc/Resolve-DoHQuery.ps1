﻿function Resolve-DoHQuery {
    <#
    .SYNOPSIS
        Used to query a DNS over HTTPS Server to verify connectivity and responses

    .DESCRIPTION
        This function is used to query a DNS over HTTPS Server to verify connectivity and responses. This has no dependency on the client, so will work regardless of if DoH is configured on the Network Adapter(s).

    .PARAMETER DoHServer
        Optionally specify a DNS over HTTPS Server for this specific query.

        This field is mandatory, unless the DoH Server has been pre-configured using: Set-ibPSConfiguration -DoHServer 'fqdn.infoblox.com' -Persist

    .PARAMETER Query
        Specify the DNS Query to send to the selected DoH Server

    .PARAMETER Type
        Optionally specify the DNS request type

    .PARAMETER Section
        Optionally specify one or more sections to return (Answer/Authority/Additional)

    .PARAMETER SourceIP
        Specify the Source IP to spoof using EDNS OPT 65523. This only works when using Infoblox Threat Defense.

    .PARAMETER SourceMAC
        Specify the Source MAC Address to spoof using EDNS OPT 65524. This only works when using Infoblox Threat Defense.

    .PARAMETER SourceView
        Specify the Source DNS View Name to spoof using EDNS OPT 65526. This only works when using Infoblox Threat Defense.

    .PARAMETER OutDig
        Use the -OutDig parameter to output the response in a format similar to dig

    .PARAMETER Object
        The Object parameter is used when passing a security policy as pipeline. This will use the 'doh_fqdn' defined as part of the Security Policy. If DoH is not configured the function will error. See Example #5

    .EXAMPLE
        PS> Resolve-DoHQuery -Query google.com -Type TXT -DoHServer cloudflare-dns.com

        QNAME         : google.com
        QTYPE         : TXT
        QCLASS        : IN
        AnswerRRs     : {@{RDATA=docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600; LENGTH=46; TXT_LENGTH=45}, @{RDATA=v=spf1 include:_spf.google.com ~all; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600; LENGTH=36; TXT_LENGTH=35},
                        @{RDATA=google-site-verification=TV9-DBe4R80X4v0M4U_bd_J9cpOJM0nikft0jAgjmsQ; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600; LENGTH=69; TXT_LENGTH=68}, @{RDATA=globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8=; RNAME=google.com; RTYPE=TXT; RCLASS=IN; TTL=3600;
                        LENGTH=65; TXT_LENGTH=64}…}
        AuthorityRRs  : {}
        AdditionalRRs : {}
        Headers       : {[AnswerRRs, 11], [AdditionalRRs, 0], [Questions, 1], [TransactionID, 0]…}

    .EXAMPLE
        PS> Resolve-DoHQuery -Query google.com -Type TXT | Select-Object -ExpandProperty AnswerRRs | ft -AutoSize

        RDATA                                                                RNAME      RTYPE RCLASS  TTL LENGTH TXT_LENGTH
        -----                                                                -----      ----- ------  --- ------ ----------
        google-site-verification=TV9-DBe4R80X4v0M4U_bd_J9cpOJM0nikft0jAgjmsQ google.com TXT   IN     3600     69         68
        docusign=1b0a6754-49b1-4db5-8540-d2c12664b289                        google.com TXT   IN     3600     46         45
        facebook-domain-verification=22rm551cu4k0ab0bxsw536tlds4h95          google.com TXT   IN     3600     60         59
        globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8=     google.com TXT   IN     3600     65         64
        webexdomainverification.8YX6G=6e6922db-e3e6-4a36-904e-a805c28087fa   google.com TXT   IN     3600     67         66
        apple-domain-verification=30afIBcvSuDV2PLX                           google.com TXT   IN     3600     43         42
        v=spf1 include:_spf.google.com ~all                                  google.com TXT   IN     3600     36         35
        docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e                        google.com TXT   IN     3600     46         45
        google-site-verification=wD8N7i1JTNTkezJ49swvWW48f8_9xveREV4oB-0Hf5o google.com TXT   IN     3600     69         68
        MS=E4A68B9AB2BB9670BCE15412F62916164C0B20BB                          google.com TXT   IN     3600     44         43
        onetrust-domain-verification=de01ed21f2fa4d8781cbc3ffb89cf4ef        google.com TXT   IN     3600     62         61

    .EXAMPLE
        PS> Resolve-DoHQuery -Query bbc.co.uk -Type SOA -OutDig

        ; <<>> ibPS v1.9.6.0 <<>> bbc.co.uk
        ;; global options: +cmd
        ;; Got answer:
        ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id 25075
        ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

        ;; QUESTION SECTION:
        bbc.co.uk.                IN    SOA

        ;; ANSWER SECTION
        bbc.co.uk.         900    IN    SOA     ns.bbc.co.uk. hostmaster.bbc.co.uk. 2024052301 1800 600 864000 900

        ;; Query time: 117 msec
        ;; SERVER: 1234-a431-a12b-1234-a0b2-12345678901ab.doh.threatdefense.infoblox.com
        ;; WHEN: Fri May 24 03:19:30
        ;; MSG SIZE  rcvd: 104

    .EXAMPLE
        PS> Resolve-DoHQuery -Query bbc.co.uk -Type A | Select-Object -ExpandProperty AnswerRRs | ft -AutoSize

        RDATA          RNAME     RTYPE RCLASS TTL LENGTH
        -----          -----     ----- ------ --- ------
        151.101.192.81 bbc.co.uk A     IN     163      4
        151.101.0.81   bbc.co.uk A     IN     163      4
        151.101.64.81  bbc.co.uk A     IN     163      4
        151.101.128.81 bbc.co.uk A     IN     163      4

    .EXAMPLE
        PS> Get-B1SecurityPolicy -Name 'My Policy' | Resolve-DoHQuery -Query 'google.com' -Type A

        QNAME         : google.com
        QTYPE         : A
        QCLASS        : IN
        AnswerRRs     : {@{RDATA=172.217.169.14; RNAME=google.com; RTYPE=A; RCLASS=IN; TTL=300; LENGTH=4}}
        AuthorityRRs  : {}
        AdditionalRRs : {}
        Headers       : {[AnswerRRs, 1], [AdditionalRRs, 0], [Questions, 1], [TransactionID, 0]…}
    #>
    [Alias("dohdig")]
    [CmdletBinding(DefaultParameterSetName="Default")]
    param(
        [Parameter(Position=1)]
        [String]$Query,
        [Parameter(Position=2)]
        [ValidateSet('A','AAAA','CNAME','PTR','MX','SOA','TXT','NS','SRV','ANY')]
        [String]$Type = 'A',
        [Parameter(ParameterSetName='Default',Position=3)]
        [String]$DoHServer = $(if ($ENV:IBPSDoH) { $ENV:IBPSDoH }),
        [ValidateSet('Answer','Authority','Additional')]
        [String[]]$Section,
        [String]$SourceIP,
        [String]$SourceMAC,
        [String]$SourceView,
        [Switch]$OutDig,
        [Parameter(
            ValueFromPipeline = $true,
            ParameterSetName="Pipeline",
            Mandatory=$true
        )]
        [System.Object]$Object
    )
    process {
        if ($MyInvocation.Line -like 'dohdig*') {
            $OutDig = $true
        }
        if ($Object) {
            if ($Object.doh_fqdn) {
                $DoHServer = $Object.doh_fqdn
                Write-Host "Querying DoH Server: $($DoHServer)" -ForegroundColor Cyan
            } else {
                Write-Error "The security Policy: $($Object.name) does not have DNS over HTTPS Configured."
                return $null
            }
        }

        if (!($DOHServer)) {
            Write-Error "Error. DNS over HTTPS Server is not set. Specify the -DoHServer parameter or use Set-ibPSConfiguration to set the DoH Server to use."
            return $null
        }

        function Decode-QNAME {
            param(
                $RDATA
            )
            $RDATALen = $RDATA.Length
            $TotalLen = $RDATALen
            $SubstringStart = 0
            $RDATAContent = @()
            while ($TotalLen -gt 0) {
                $RDATASegmentLength = [uint32]"0x$($RDATA.substring($SubstringStart,2))"
                if ($RDATASegmentLength -ne 0) {
                    $RDATASegment = $RDATA.substring($SubstringStart+2,$RDATASegmentLength*2)
                    $RDATAContent += $RDATASegment
                    $TotalLen = $TotalLen - (2+$RDATASegmentLength)
                    $SubstringStart = $SubstringStart + (2+$RDATASegmentLength*2)
                } else {
                    $RDATARemaining = $RDATA.substring($SubstringStart+2,($($RDATALen)-$($SubstringStart+2)))
                    break
                }
            }
            return @{
                "rdata" = $RDATAContent
                "remaining" = $RDATARemaining
            }
        }

        function ConvertBinary-ToDecimal {
            param(
                [String]$Bin
            )
            $BinSplit = $Bin -Split '(.)' -ne ''
            [array]::Reverse($BinSplit)
            $BinaryResults = 0
            $BinCount = 0
            $BinSplit | ForEach-Object {
                $BinaryResults += [Int]$_ * [Math]::Pow(2,$BinCount)
                $BinCount++
            }
            return $BinaryResults
        }

        function Decompress-DNS {
            param(
                $Hex
            )
            $i = 0
            $HexSplit = $Hex -split '(..)' -ne ''
            $Found = @()
            $HexSplit | ForEach-Object {
                $i++
                if ($_ -match 'C0') {
                    $Match = "$($Matches[0])$($HexSplit[$i])"
                    if (($Match.Length) -eq 4) {
                        $Found += "$($Matches[0])$($HexSplit[$i])"
                    }
                }
            }
            $UniqueMatches = $Found | Select-Object -Unique
            $UniqueMatches | ForEach-Object {
                $ReplaceString = ""
                $Offset = (ConvertBinary-ToDecimal (ConvertHex-ToBinary $($_)).substring(2,14))*2
                (Decode-QNAME $Hex.substring($Offset,($Hex.Length-$Offset))).rdata | ForEach-Object {
                    $ReplaceString += "$('{0:X2}' -f $(($_.Length)/2))$($_)"
                }
                $ReplaceString += '00'
                $Hex = $Hex.Replace($_,$ReplaceString)
            }
            return $Hex
        }

        function ConvertHex-ToBinary {
            param(
                $String
            )
            $Table = @{
                "0" = "0000"
                "1" = "0001"
                "2" = "0010"
                "3" = "0011"
                "4" = "0100"
                "5" = "0101"
                "6" = "0110"
                "7" = "0111"
                "8" = "1000"
                "9" = "1001"
                "A" = "1010"
                "B" = "1011"
                "C" = "1100"
                "D" = "1101"
                "E" = "1110"
                "F" = "1111"
            }
            ($String -split '(.)' -ne '' | ForEach-Object {$Table[$_]}) -join ''
        }

        $Result = [PSCustomObject]@{
            "RCODE" = ""
            "QNAME" = ""
            "QTYPE" = ""
            "QCLASS" = ""
            "AnswerRRs" = @()
            "AuthorityRRs" = @()
            "AdditionalRRs" = @()
            "Headers" = @{}
        }

        ## Query/Response Types
        $QTYPEList = @{
            'A' = 1        ## Address Record
            'NS' = 2       ## Name Server Record
            'MD' = 3       ## Mail Destination
            'MF' = 4       ## Mail Forwarder
            'CNAME' = 5    ## Canonical Name Record
            'SOA' = 6      ## Start of Authority Record
            'MB' = 7       ## Expirimetal/Obsolete - Mailing Lists
            'MG' = 8       ## Expirimetal/Obsolete - Mailing Lists
            'MR' = 9       ## Expirimetal/Obsolete - Mailing Lists
            'NULL' = 10    ## Obsolete (RFC1035)
            'WKS' = 11     ## Well Known Service - Obsolete (RFC1123)
            'PTR' = 12     ## Pointer Record
            'HINFO' = 13   ## Host Information Record
            'MINFO' = 14   ## Expirimetal/Obsolete - Mailing Lists
            'MX' = 15      ## Mail Exchange Record
            'TXT' = 16     ## Text Record
            'RP' = 17      ## Responsible Person Record
            'AAAA' = 28    ## IPv6 Address Record
            'SRV' = 33     ## Service Locator Record
            'OPT' = 41     ## This is a pseudo-record type needed to support EDNS.
            'SVCB' = 64    ## Service Locator Record
            'ANY' = 255    ## Any/Wildcard Record from Cache
            'URI' = 256    ## Uniform Resource Identifier
        }

        ## Query/Response Class
        $QCLASSList = @{
            1 = 'IN'
            2 = 'CS'
            3 = 'CH'
            4 = 'HS'
        }

        ## DNS Opcodes
        $OpcodeList = @{
            0 = 'Query'
            1 = 'IQuery'
            2 = 'Status'
            3 = 'Unassigned'
            4 = 'Notify'
            5 = 'Update'
            6 = 'DNS Stateful Operation'
        }

        ## DNS Response Codes
        $RCodeList = @{
            0 = 'NOERROR'
            1 = 'FORMAT ERROR'
            2 = 'SERVFAIL'
            3 = 'NXDOMAIN'
            4 = 'NOT IMPLEMENTED'
            5 = 'REFUSED'
            6 = 'YXDOMAIN'
            7 = 'YXRRSET'
            8 = 'NXRRSET'
            9 = 'NOTAUTH'
            10 = 'NOTZONE'
            11 = 'DSOTYPENI'
            12 = 'Unassigned'
            13 = 'Unassigned'
            14 = 'Unassigned'
            15 = 'Unassigned'
            16 = 'BADVERS/BADSIG'
            17 = 'BADKEY'
            18 = 'BADTIME'
            19 = 'BADMODE'
            20 = 'BADNAME'
            21 = 'BADALG'
            22 = 'BADTRUNC'
            23 = 'BADCOOKIE'
        }

        $SplitQuery = $Query.Split('.')
        $JoinedQuery = ""

        foreach ($SplitItem in $SplitQuery) {
            $JoinedQuery += "$('{0:X2}' -f ([uint32]$SplitItem.Length))$($SplitItem | ConvertTo-HexString)"
        }
        $JoinedQuery += '00'

        $TransactionID = Get-Random -Maximum 65535
        $TransactionIDHex = "{0:X4}" -f [Uint32]$TransactionID -split '(..)' -ne '' -join ' '
        $AdditionalRecordsCount = 0
        $AdditionalRecordHex = ''
        if ($SourceIP) {
            $AdditionalRecordsCount++
            $SourceIPHex = ("{0:X8}" -f [Uint32]([IPAddress]$SourceIP).address) -split '(..)' -ne ''
            [Array]::Reverse($SourceIPHex)
            $SourceIPHex = $SourceIPHex -join ''
            $SourceIPHexLength = "{0:X4}" -f [Uint32]$($SourceIPHex.length / 2)
            $EDNSOptHex = "{0:X4}" -f [Uint32]'65523'
            $AdditionalRecordHex += "$EDNSOptHex $SourceIPHexLength $SourceIPHex" -replace ' ',''
        }
        if ($SourceMAC) {
            $AdditionalRecordsCount++
            $SourceMACHex = ($SourceMAC -replace ':','')
            $SourceMACHexLength = "{0:X4}" -f [Uint32]$($SourceMACHex.length / 2)
            $EDNSOptHex = "{0:X4}" -f [Uint32]'65524'
            $AdditionalRecordHex += "$EDNSOptHex $SourceMACHexLength $SourceMACHex" -replace ' ',''
        }
        if ($SourceView) {
            $AdditionalRecordsCount++
            $SourceViewHex = ($SourceView | ConvertTo-HexString) -replace ' ',''
            $SourceViewHexLength = "{0:X4}" -f [Uint32]$($SourceViewHex.length / 2)
            $EDNSOptHex = "{0:X4}" -f [Uint32]'65526'
            $AdditionalRecordHex += "$EDNSOptHex $SourceViewHexLength $SourceViewHex" -replace ' ',''
        }
        $AdditionalRecordsCountHex =  "{0:X4}" -f [Uint32]$AdditionalRecordsCount
        $HeaderHex = "$TransactionIDHex 01 00 00 01 00 00 00 00 $AdditionalRecordsCountHex"
        $QNAMEHex = $JoinedQuery
        $QTYPEHex = '{0:X4}' -f ([uint32]$QTYPEList[$Type])
        $QCLASSHex = '{0:X4}' -f ([uint32]1)
        $OPTDataLengthHex =  "{0:X4}" -f [Uint32]$($AdditionalRecordHex.length / 2)
        $OPTHex = "00 00 29 10 00 00 00 00 00 $OPTDataLengthHex $AdditionalRecordHex"
        $Hex = "$HeaderHex $QNAMEHex $QTYPEHex $QCLASSHex $OPTHex" -replace ' ',''

        $Bytes = New-Object -TypeName byte[] -ArgumentList ($Hex.Length / 2)
        for ($i = 0; $i -lt $hex.Length; $i += 2) {
            $Bytes[$i / 2] = [System.Convert]::ToByte($hex.Substring($i, 2), 16)
        }

        $Base64 = [System.Convert]::ToBase64String($Bytes)
        $Base64Encoded = ConvertTo-Base64Url -FromBase64 $($Base64)

        $StartDateTime = Get-Date
        $Response = Invoke-WebRequest -Method GET -Uri "https://$($DOHServer)/dns-query?dns=$($Base64Encoded)" -Headers @{'content-type' = 'application/dns-message'}
        $EndDateTime = Get-Date

        if ($Response) {
            ## Decode Header
            $ResponseHeaderHex = ($Response.Content|ForEach-Object ToString X2) -join ''
            $Result.Headers.TransactionID = $([uint32]"0x$($ResponseHeaderHex.substring(0,4))")
            $ResponseHeaderHex = Decompress-DNS $ResponseHeaderHex
            $Flags = $($ResponseHeaderHex.substring(4,4)) -Split '(.)' -ne ''
            $FlagsBin = ""
            $Flags | ForEach-Object {
                $FlagsBin += [Convert]::ToString($_,2).PadLeft(4,'0')
            }
            $Result.Headers.Flags = @{
                "raw" = "0x$($ResponseHeaderHex.substring(4,4))"
                "Type" = $(if ($FlagsBin.substring(0,1) -eq '1') { "Response" } else { "Query" })
                "Opcode" = ($OpcodeList[[int][uint32]"0x$($($FlagsBin.substring(1,4)))"])
                "Authoritative" = $(if ($FlagsBin.substring(5,1) -eq 1) { $true } else { $false })
                "Truncated" = $(if ($FlagsBin.substring(6,1) -eq 1) { $true } else { $false })
                "Recursion Desired" = $(if ($FlagsBin.substring(7,1) -eq 1) { $true } else { $false })
                "Recursion Available" = $(if ($FlagsBin.substring(8,1) -eq 1) { $true } else { $false })
                "Reserved" =  $($FlagsBin.substring(9,1))
                "Authenticated" = $(if ($FlagsBin.substring(10,1) -eq 1) { $true } else { $false })
                "Non-Authenticated Data" = $(if ($FlagsBin.substring(11,1) -eq 1) { 'Acceptable' } else { 'Unacceptable' })
                "Reply Code" = $RCodeList[([Int]$(ConvertBinary-ToDecimal $($FlagsBin.substring(12,4))))]
            }

            $Result.RCODE = $Result.Headers.Flags.'Reply Code'
            $Result.Headers.Questions = $([uint32]"0x$($ResponseHeaderHex.substring(8,4))")
            $Result.Headers.AnswerRRs = $([uint32]"0x$($ResponseHeaderHex.substring(12,4))")
            $Result.Headers.AuthorityRRs = $([uint32]"0x$($ResponseHeaderHex.substring(16,4))")
            $Result.Headers.AdditionalRRs = $([uint32]"0x$($ResponseHeaderHex.substring(20,4))")

            ## Decode QNAME
            $RDATA = $ResponseHeaderHex.substring(24,$ResponseHeaderHex.length-24)
            $QNAMEDecoded = Decode-QNAME $RDATA
            $Result.QNAME = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')

            ## Decode QTYPE
            $Result.QTYPE = ($QTYPEList.GetEnumerator().Where{$_.value -eq [uint32]"0x$($QNAMEDecoded.remaining.substring(0,4))"}).key

            ## Decode QCLASS
            $Result.QCLASS = $QCLASSList[[int]$([uint32]$QNAMEDecoded.remaining.substring(4,4))]

            ## Strip QTYPE/QCLASS
            $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.substring(8,$QNAMEDecoded.remaining.length-8)
            $TotalLen = $QNAMEDecoded.remaining.length
            while (($TotalLen -gt 0) -and (!($AdditionalRRs))) {
                $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining
                $RTYPE = ($QTYPEList.GetEnumerator().Where{$_.value -eq [uint32]"0x$($QNAMEDecoded.remaining.substring(0,4))"}).key
                $Ans = [PSCustomObject]@{
                    "RDATA" = ""
                    "RNAME" = $(if ($RTYPE -notin @('TXT','NS')) { ($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.' })
                    "RTYPE" = ($QTYPEList.GetEnumerator().Where{$_.value -eq [uint32]"0x$($QNAMEDecoded.remaining.substring(0,4))"}).key
                    "RCLASS" = $QCLASSList[[int]$([uint32]$QNAMEDecoded.remaining.substring(4,4))]
                    "TTL" = $([uint32]"0x$($QNAMEDecoded.remaining.substring(8,8))")
                    "LENGTH" = $([uint32]"0x$($QNAMEDecoded.remaining.substring(16,4))")
                }
                $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.substring(20,$QNAMEDecoded.remaining.length-20)
                ## Decode Answer
                Switch($Ans.RTYPE) {
                    'A' {
                        $IPSplit = ($($QNAMEDecoded.remaining.substring(0,8)) -split '(..)' -ne '')
                        $IP = @()
                        foreach ($i in $IPSplit) {
                            $IP += [uint32]"0x$i"
                        }
                        $Ans.RDATA = $IP -join '.'
                        $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.substring(8,($QNAMEDecoded.remaining.length-8))
                    }
                    'AAAA' {
                        $IPSplit = ($($QNAMEDecoded.remaining.substring(0,32)) -split '(....)' -ne '')
                        $IP = @()
                        foreach ($i in $IPSplit) {
                            ## Work out parsing to IPv6 Short format
                            # $i = $(if ($i -match '^(0+)(\w+)') {$i.Replace('0','')} else {$i})
                            $IP += $i.toLower()
                        }
                        $Ans.RDATA = ($IP -join ':')
                        $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.substring(32,($QNAMEDecoded.remaining.length-32))
                    }
                    'SOA' {
                        $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining
                        ## Decode The Primary Name Server
                        $NewRDATA = [PSCustomObject]@{
                            "NS" = ($QNAMEDecoded.rdata | ForEach-Object {($_ -Split '(..)' -ne '' | ForEach-Object {[char][byte]"0x$_"}) -join ''}) -join '.'
                            "ADMIN" = ""
                            "SERIAL" = 0
                            "REFRESH" = 0
                            "RETRY" = 0
                            "EXPIRE" = 0
                            "TTL" = 0
                        }
                        $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining
                        $NewRDATA.ADMIN += $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
                        $NewRDATA.SERIAL = $([uint32]"0x$($QNAMEDecoded.remaining.substring(0,8))")
                        $NewRDATA.REFRESH = $([uint32]"0x$($QNAMEDecoded.remaining.substring(8,8))")
                        $NewRDATA.RETRY = $([uint32]"0x$($QNAMEDecoded.remaining.substring(16,8))")
                        $NewRDATA.EXPIRE = $([uint32]"0x$($QNAMEDecoded.remaining.substring(24,8))")
                        $NewRDATA.TTL = $([uint32]"0x$($QNAMEDecoded.remaining.substring(32,8))")
                        $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.substring(40,($QNAMEDecoded.remaining.length-40))
                        $Ans.RDATA = $NewRDATA
                    }
                    'CNAME' {
                        $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining
                        $Ans.RDATA = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
                    }
                    'MX' {
                        $NewRDATA = [PSCustomObject]@{
                            "MX" = ""
                            "Preference" = $([uint32]"0x$($QNAMEDecoded.remaining.substring(0,4))")
                        }
                        $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining.substring(4,($QNAMEDecoded.remaining.length-4))
                        $NewRDATA.MX = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
                        $Ans.RDATA = $NewRDATA
                    }
                    'TXT' {
                        $Ans.RNAME = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
                        $Ans | Add-Member -MemberType NoteProperty -Name "TXT_LENGTH" -Value $([uint32]"0x$($QNAMEDecoded.remaining.substring(0,2))")
                        $Ans.RDATA = ($QNAMEDecoded.remaining.substring(2,$Ans.TXT_LENGTH*2) | ConvertFrom-HexString) -join ''
                        $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.substring(($Ans.TXT_LENGTH*2)+2,$QNAMEDecoded.remaining.length-(($Ans.TXT_LENGTH*2)+2))
                    }
                    'NS' {
                        $Ans.RNAME = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
                        $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining
                        $Ans.RDATA = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
                    }
                    'SRV' {
                        $RNAMEDecoded = ($QNAMEDecoded.rdata | ConvertFrom-HexString)
                        $Ans.RNAME = $RNAMEDecoded[2..($RNAMEDecoded.Count)] -join '.'
                        $Ans | Add-Member -MemberType NoteProperty -Name "SERVICE" -Value $RNAMEDecoded[0]
                        $Ans | Add-Member -MemberType NoteProperty -Name "PROTOCOL" -Value $RNAMEDecoded[1]
                        $NewRDATA = [PSCustomObject]@{
                            "Priority" = $([uint32]"0x$($QNAMEDecoded.remaining.substring(0,4))")
                            "Weight" = $([uint32]"0x$($QNAMEDecoded.remaining.substring(4,4))")
                            "Port" = $([uint32]"0x$($QNAMEDecoded.remaining.substring(8,4))")
                            "Target" = ""
                        }
                        $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining.substring(12,$QNAMEDecoded.remaining.length-12)
                        $NewRDATA.Target = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
                        $Ans.RDATA = $NewRDATA
                    }
                    default {
                        Write-Error "$($Ans.RTYPE) is not yet implemented"
                        $Result | Add-Member -MemberType NoteProperty -Name 'hex' -Value $($QNAMEDecoded.remaining)
                        return $Result
                    }
                }
                if ($Result.AnswerRRs.Count -lt ($Result.Headers.AnswerRRs)) {
                    $Result.AnswerRRs += $Ans
                } elseif ($Result.AuthorityRRs.Count -lt ($Result.Headers.AuthorityRRs)) {
                    $Result.AuthorityRRs += $Ans
                } else {
                    $Result.AdditionalRRs += $Ans
                }
                if (($Result.AnswerRRs.Count -lt ($Result.Headers.AnswerRRs)) -or ($Result.AuthorityRRs.Count -lt ($Result.Headers.AuthorityRRs))) {
                    $AdditionalRRs = $false
                } elseif ($Result.Headers.AdditionalRRs -gt 0) {
                    $AdditionalRRs = $true
                }
                $TotalLen = $QNAMEDecoded.remaining.length
            }

            if ($AdditionalRRs) {
                $AdditionalRR = @{
                    "Name" = $QNAMEDecoded.remaining.substring(0,2)
                    "Type" = ($QTYPEList.GetEnumerator().Where{$_.value -eq [uint32]"0x$($QNAMEDecoded.remaining.substring(2,4))"}).key
                    "UDP Payload Size" = [Uint32]"0x$($QNAMEDecoded.remaining.substring(6,4))"
                    "Extended RCODE" = $QNAMEDecoded.remaining.substring(10,2)
                    "EDNS0 Version" = [Uint32]"0x$($QNAMEDecoded.remaining.substring(12,2))"
                    "Z" = $QNAMEDecoded.remaining.substring(14,4)
                    "Data Length" = $QNAMEDecoded.remaining.substring(18,4)
                }
                $Result.AdditionalRRs += $AdditionalRR
            }
            if ($Section) {
                if ($Section -contains 'Answer') {
                    $Result.AnswerRRs
                }
                if ($Section -contains 'Authority') {
                    $Result.AuthorityRRs
                }
                if ($Section -contains 'Additional') {
                    $Result.AdditionalRRs
                }
            } elseif ($OutDig) {
                Write-Output ""
                Write-Output "; <<>> ibPS v$(Get-ibPSVersion) <<>> $($Result.QNAME)"
                Write-Output ";; global options: +cmd"
                Write-Output ";; Got answer:"
                Write-Output ";; ->>HEADER<<- opcode: $($Result.Headers.Flags.Opcode.ToUpper()), status: $($Result.RCODE), id $($Result.Headers.TransactionID)"
                $Flags = @()
                if ($Result.Headers.Flags.'Type' -eq 'Response') { $Flags += 'qr' }
                if ($Result.Headers.Flags.'Recursion Desired') { $Flags += 'rd' }
                if ($Result.Headers.Flags.'Recursion Available') { $Flags += 'ra' }
                if ($Result.Headers.Flags.'Authoritative') { $Flags += 'aa' }
                if ($Result.Headers.Flags.'Authenticated') { $Flags += 'ad' }
                Write-Output ";; flags: $($Flags -join ' '); QUERY: $($Result.Headers.Questions), ANSWER: $($Result.Headers.AnswerRRs), AUTHORITY: $($Result.Headers.AuthorityRRs), ADDITIONAL: $($Result.Headers.AdditionalRRs)"
                if (($Result.Headers.Flags.'Recursion Desired') -and (!($Result.Headers.Flags.'Recursion Available'))) {
                    Write-Output ";; WARNING: recursion requested but not available"
                }
                if ($($Result.Headers.Questions) -gt 0) {
                    Write-Output ""
                    Write-Output ";; QUESTION SECTION:"
                    Write-Output "$($Result.QNAME).  $($Result.QCLASS.PadLeft(16+($Answer.TTL),' '))  $(if ($Result.QTYPE) {$Result.QTYPE.PadLeft(5,' ')})"
                }
                if ($($Result.Headers.AnswerRRs) -gt 0) {
                    Write-Output ""
                    Write-Output ";; ANSWER SECTION"
                    foreach ($Answer in $Result.AnswerRRs) {
                        Switch($Answer.RTYPE) {
                            'SOA' {
                                Write-Output "$($Answer.RNAME).  $(([String]$Answer.TTL).PadLeft(10,' '))  $($Answer.RCLASS.PadLeft(4,' '))  $($Answer.RTYPE.PadLeft(5,' '))     $($Answer.RDATA.NS.PadLeft(5,' ')). $($Answer.RDATA.ADMIN). $($Answer.RDATA.SERIAL) $($Answer.RDATA.REFRESH) $($Answer.RDATA.RETRY) $($Answer.RDATA.EXPIRE) $($Answer.RDATA.TTL)"
                            }
                            'MX' {
                                Write-Output "$($Answer.RNAME).  $(([String]$Answer.TTL).PadLeft(10,' '))  $($Answer.RCLASS.PadLeft(4,' '))  $($Answer.RTYPE.PadLeft(5,' '))     $(([String]$Answer.RDATA.Preference).PadLeft(5,' ')) $($Answer.RDATA.MX)."
                            }
                            'TXT' {
                                Write-Output "$($Answer.RNAME).  $(([String]$Answer.TTL).PadLeft(10,' '))  $($Answer.RCLASS.PadLeft(4,' '))  $($Answer.RTYPE.PadLeft(5,' '))     `"$($Answer.RDATA)`""
                            }
                            'SRV' {
                                Write-Output "$($Answer.SERVICE)  $($Answer.PROTOCOL).$($Answer.RNAME).  $(([String]$Answer.TTL).PadLeft(10,' '))  $($Answer.RCLASS.PadLeft(4,' '))$($Answer.RTYPE.PadLeft(7,' '))     $($Answer.RDATA.Target.PadLeft(5,' ')). $([String]$Answer.RDATA.Priority) $($Answer.RDATA.Weight) $($Answer.RDATA.Port)"
                            }
                            default {
                                Write-Output "$($Answer.RNAME).  $(([String]$Answer.TTL).PadLeft(10,' '))  $($Answer.RCLASS.PadLeft(4,' '))  $($Answer.RTYPE.PadLeft(5,' '))     $($Answer.RDATA)"
                            }
                        }
                    }
                }
                if ($($Result.Headers.AuthorityRRs) -gt 0) {
                    Write-Output ""
                    Write-Output ";; AUTHORITY SECTION"
                    foreach ($Answer in $Result.AuthorityRRs) {
                        Switch($Answer.RTYPE) {
                            'SOA' {
                                Write-Output "$($Answer.RNAME).  $(([String]$Answer.TTL).PadLeft(10,' '))  $($Answer.RCLASS.PadLeft(4,' '))  $($Answer.RTYPE.PadLeft(5,' '))     $($Answer.RDATA.NS.PadLeft(5,' ')). $($Answer.RDATA.ADMIN). $($Answer.RDATA.SERIAL) $($Answer.RDATA.REFRESH) $($Answer.RDATA.RETRY) $($Answer.RDATA.EXPIRE) $($Answer.RDATA.TTL)"
                            }
                            default {
                                Write-Output "$($Answer.RNAME).        $($Answer.TTL)        $($Answer.RCLASS)        $($Answer.RTYPE)        $($Answer.RDATA)"
                            }
                        }
                    }
                }
                Write-Output ""
                Write-Output ";; Query time: $(($EndDateTime - $StartDateTime).Milliseconds) msec"
                Write-Output ";; SERVER: $($DoHServer)"
                Write-Output ";; WHEN: $(($StartDateTime.ToString("ddd MMM dd hh:mm:ss")))"
                Write-Output ";; MSG SIZE  rcvd: $($Response.RawContentLength)"
            } else {
                return $Result
            }
        } else {
            Write-Error "Error connecting to DoH Server: $($DoHServer)"
        }
    }
}
