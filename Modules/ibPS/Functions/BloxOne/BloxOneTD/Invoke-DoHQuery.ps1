function Invoke-DoHQuery {
    <#
    .SYNOPSIS
        Used to query a DNS over HTTPS Server to verify connectivity and responses

    .DESCRIPTION
        This function is used to query a DNS over HTTPS Server to verify connectivity and responses

    .PARAMETER DoHServer
        Optionally specify a DNS over HTTPS Server for this specific query.
        
        This field is mandatory, unless the DoH Server has been pre-configured using: Set-ibPSConfiguration -DoHServer 'fqdn.infoblox.com' -Persist

    .PARAMETER Query
        Specify the DNS Query to send to the selected DoH Server

    .PARAMETER Type
        Optionally specify the DNS request type

    .EXAMPLE
        PS> Invoke-DoHQuery -Query google.com      
                                                                                                                        
        QNAME      QTYPE QCLASS Answers
        -----      ----- ------ -------
        google.com       IN     {@{RDATA=System.Collections.Hashtable; RNAME=google.com; RTYPE=SOA; RCLASS=IN; TTL=60; LENGTH=58}}

    .EXAMPLE
        PS> Invoke-DoHQuery -Query bbc.co.uk -Type A | Select-Object -ExpandProperty Answers | ft -AutoSize
                                                                                                                            
        RDATA          RNAME     RTYPE RCLASS TTL LENGTH
        -----          -----     ----- ------ --- ------
        151.101.128.81 bbc.co.uk A     IN     296      4
        151.101.192.81 bbc.co.uk A     IN     296      4
        151.101.0.81   bbc.co.uk A     IN     296      4
        151.101.64.81  bbc.co.uk A     IN     296      4
    #>
    param(
        [String]$Query,
        [ValidateSet('A','CNAME','PTR','MX','SOA','TXT')]
        [String]$Type,
        [String]$DoHServer = $(if ($ENV:IBPSDoH) { $ENV:IBPSDoH })
    )

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

    $Result = [PSCustomObject]@{
        "QNAME" = ""
        "QTYPE" = ""
        "QCLASS" = ""
        "Answers" = @()
        "Headers" = @{}
    }

    $QTYPEList = @{
        'A' = 1
        'NS' = 2
        'MD' = 3
        'MF' = 4
        'CNAME' = 5
        'SOA' = 6
        'MB' = 7
        'MG' = 8
        'MR' = 9
        'NULL' = 10
        'WKS' = 11
        'PTR' = 12
        'HINFO' = 13
        'MINFO' = 14
        'MX' = 15
        'TXT' = 16
    }

    $QCLASSList = @{
        1 = 'IN'
        2 = 'CS'
        3 = 'CH'
        4 = 'HS'
    }

    $SplitQuery = $Query.Split('.')
    $JoinedQuery = ""

    foreach ($SplitItem in $SplitQuery) {
        $JoinedQuery += "$('{0:X2}' -f ([uint32]$SplitItem.Length))$(($SplitItem | Format-Hex).HexBytes)"
    }
    $JoinedQuery += '00'

    $HeaderHex = '00 00 01 00 00 01 00 00 00 00 00 00'
    $QNAMEHex = $JoinedQuery
    $QTYPEHex = '{0:X4}' -f ([uint32]$QTYPEList[$Type])
    $QCLASSHex = '{0:X4}' -f ([uint32]1)

    $Hex = "$HeaderHex $QNAMEHex $QTYPEHex $QCLASSHex" -replace ' ',''

    $Bytes = New-Object -TypeName byte[] -ArgumentList ($Hex.Length / 2)

    for ($i = 0; $i -lt $hex.Length; $i += 2) {
        $Bytes[$i / 2] = [System.Convert]::ToByte($hex.Substring($i, 2), 16)
    }
    $Base64 = [System.Convert]::ToBase64String($Bytes)
    $Base64Encoded = ConvertTo-Base64Url -FromBase64 $($Base64)

    $Response = Invoke-WebRequest -Method GET -Uri "https://$($DOHServer)/dns-query?dns=$($Base64Encoded)" -Headers @{'content-type' = 'application/dns-message'}

    ## Decode Header
    $ResponseHeaderHex = ($Response.Content|ForEach-Object ToString X2) -join ''
    $Result.Headers.TransactionID = $([uint32]"0x$($ResponseHeaderHex.substring(0,4))")
    $Result.Headers.Flags = "0x$($ResponseHeaderHex.substring(4,4))"
    $Result.Headers.Questions = $([uint32]"0x$($ResponseHeaderHex.substring(8,4))")
    $Result.Headers.AnswerRRs = $([uint32]"0x$($ResponseHeaderHex.substring(12,4))")
    $Result.Headers.AuthorityRRs = $([uint32]"0x$($ResponseHeaderHex.substring(16,4))")
    $Result.Headers.AdditionalRRs = $([uint32]"0x$($ResponseHeaderHex.substring(20,4))")

    ## Decode QNAME
    $RDATA = $ResponseHeaderHex.substring(24,$ResponseHeaderHex.length-24)
    $QNAMEDecoded = Decode-QNAME $RDATA
    $Result.QNAME = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
    $QNAMEEncoded = "$(($Result.QNAME -split '\.' | Foreach {("$('{0:X2}' -f $_.length) $(($_ | ConvertTo-HexString))").Replace(' ','')}) -join '')00"

    ## Decode QTYPE
    $Result.QTYPE = ($QTYPEList.GetEnumerator().Where{$_.value -eq [uint32]"0x$($QNAMEDecoded.remaining.substring(0,4))"}).key

    ## Decode QCLASS
    $Result.QCLASS = $QCLASSList[[int]$([uint32]$QNAMEDecoded.remaining.substring(4,4))]

    ## Strip QTYPE/QCLASS
    $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.substring(8,$QNAMEDecoded.remaining.length-8)
    if ($QNAMEDecoded.remaining.StartsWith('C00C00')) {
        $QNAMEDecoded.remaining = $QNAMEDecoded.remaining.Replace('C00C',$QNAMEEncoded)
    }
    $TotalLen = $QNAMEDecoded.remaining.length
    while ($TotalLen -gt 0) {
        #return $QNAMEDecoded
        $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining
        $RTYPE = ($QTYPEList.GetEnumerator().Where{$_.value -eq [uint32]"0x$($QNAMEDecoded.remaining.substring(0,4))"}).key
        $Ans = [PSCustomObject]@{
            "RDATA" = ""
            "RNAME" = $(if ($Result.QTYPE -ne 'TXT') { ($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.' })
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
            'SOA' {
                $QNAMEDecoded = Decode-QNAME $QNAMEDecoded.remaining
                ## Decode The Primary Name Server
                $NewRDATA = [PSCustomObject]@{
                    "NS" = $(($QNAMEDecoded.rdata | ConvertFrom-HexString) -join '.')
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
            default {
                $QNAMEDecoded.remaining.substring(20,($QNAMEDecoded.remaining.length-20))
                Write-Error "$($Ans.RTYPE) is not yet implemented"
                return $null
            }
        }
        $Result.Answers += $Ans
        $TotalLen = $QNAMEDecoded.remaining.length
    }

    return $Result   
}
