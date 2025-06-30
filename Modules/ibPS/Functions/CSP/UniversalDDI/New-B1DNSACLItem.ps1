function New-B1DNSACLItem {
    <#
    .SYNOPSIS
        This function is used to create new ACL Items to append or remove to/from an existing or a New DNS ACL, using Set-B1DNSACL / New-B1DNSACL.

    .DESCRIPTION
        This function is used to create new ACL Items to append or remove to/from an existing or a New DNS ACL, using Set-B1DNSACL / New-B1DNSACL.

    .PARAMETER Access
        The permission to apply to this ACL Item (Allow/Deny)

    .PARAMETER ACL
        The Named ACL to associate with this ACL Item. This selects the ACL Element to 'acl'

    .PARAMETER Address
        The IPv4/IPv6 address or network (in CIDR format) to associate with this ACL Item. This selects the ACL Element to 'ip'

    .PARAMETER TSIG_KEY
        The IPv4/IPv6 address or network (in CIDR format) to associate with this ACL Item. This selects the ACL Element to 'tsig_key'

    .EXAMPLE
        New-B1DNSACLItem -Access Allow -ACL 'My ACL'

        access   : allow
        acl      : dns/acl/1c4e5768-f4r4-dgsd-bewf-grdrggwt4se
        address  :
        element  : acl
        tsig_key :

    .EXAMPLE
        $NewACLs = @()
        $NewACLs += New-B1DNSACLItem -Access Deny -ACL 'My ACL'
        $NewACLs += New-B1DNSACLItem -Access Allow -Address '10.0.0.0/16'

        $NewACLs | ft

        access acl                                          address     element tsig_key
        ------ ---                                          -------     ------- --------
        allow                                               10.0.0.0/16 ip
        deny   dns/acl/1c4e5768-f4r4-dgsd-bewf-grdrggwt4se              acl


    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        DNS
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param(
        [Parameter(ParameterSetName='IP',Mandatory=$true)]
        [Parameter(ParameterSetName='TSIG',Mandatory=$true)]
        [ValidateSet('Allow','Deny')]
        $Access,
        [Parameter(ParameterSetName='IP')]
        $Address,
        [Parameter(ParameterSetName='NamedACL')]
        $ACL,
        [Parameter(ParameterSetName='TSIG')]
        $TSIG_KEY
    )
    if ($Address) {
        $PSBoundParameters.address = $Address
        $PSBoundParameters.element = 'ip'
    }

    if ($ACL) {
        $NewACL = Get-B1DNSACL -Name $ACL -Strict
        if ($NewACL) {
            $PSBoundParameters.ACL = $NewACL.id
            $PSBoundParameters.element = 'acl'
        } else {
            Write-Error "Unable to find ACL with name: $($ACL)"
            return $null
        }
    }

    if ($TSIG_KEY) {
        $NewTSIG = 'Not Implemented'
        return $NewTSIG
    }

    $PSBP = @{}
    foreach ($Parameter in $PSBoundParameters.GetEnumerator()) {
        $PSBP[$($Parameter.Key)] = "$($Parameter.Value.ToLower())"

    }
    [DNSACLListItem]::New($PSBP)
}