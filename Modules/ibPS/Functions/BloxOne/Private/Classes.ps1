class TSIGKey {
    # Class properties
    [string]   $algorithm
    [string]   $comment
    [string]   $key
    [string]   $name
    [string]   $protocol_name
    [string]   $secret
}

class DNSACLListItem {
    # Class properties
    [string]   $access
    [string]   $acl
    [string]   $address
    [string]   $element
    [TSIGKey]  $tsig_key

    # Init method
    DNSACLListItem($Obj) { $this.Init($Obj) }
    [void] Init([System.Object]$Obj) {
        $this = $Obj
    }

    # Shared initializer method
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }

    [string] ToString() {
        return @("@{$($this.access), $($this.element), $($this.address)}")
    }
}

class DNSACL {
    # Class properties
    [string]           $comment
    [string]           $compartment_id
    [string]           $id
    [DNSACLListItem[]] $list
    [string]           $name
    [System.Object]    $tags

    # Default constructor
    DNSACL($DNSACLs) { $this.Init($DNSACLs) }

    # Init method
    [void] Init([System.Object]$Properties) {
        foreach ($Property in $Properties.PSObject.Properties.Name) {
            $this.$Property = $Properties.$Property
        }
    }

    # [string] AddListItem($DNSACLListItem) {
    #     #foreach ($DNSACLItem in $DNSACLListItem) {
    #         $this.list += $DNSACLListItem
    #     #}
    #     return $this
    # }
}

class DNSACLArray {
    # Class properties
    [DNSACL[]] $DNSACLs

    # Default constructor

    # Init method
    DNSACLArray($DNSACLs) { $this.Init($DNSACLs) }
    [void] Init([System.Object]$DNSACLs) {
        $this.DNSACLs = $DNSACLs
    }
}