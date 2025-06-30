function Set-B1DNSACL {
    <#
    .SYNOPSIS
        Updates a DNS ACL object

    .DESCRIPTION
        This function is used to update a DNS ACL object within BloxOne

    .PARAMETER Name
        The name of the DNS ACL to update.

    .PARAMETER NewName
        Use -NewName to update the name of the DNS ACL

    .PARAMETER Description
        The new description for the DNS ACL object

    .PARAMETER Items
        Enter a list of [DNSACLListItem] objects. These can be created by using New-B1DNSACLItem.

        This will overwrite the current list of ACLs. If you only want to add or remove ACLs to/from the list, you should use the corresponding -AddItems or -RemoveItems parameters.

    .PARAMETER AddItems
        Enter a list of [DNSACLListItem] objects. These can be created by using New-B1DNSACLItem.

        Duplicate items will be silently skipped, only new items are appended to the ACL list.

    .PARAMETER RemoveItems
        Enter a list of [DNSACLListItem] objects. These can be created by using New-B1DNSACLItem.

        These items will be removed from the ACL List, if the item does not exist it will be silently skipped.

    .PARAMETER Tags
        The list of tags to apply to the DNS ACL. This will overwrite the current list of tags.

    .PARAMETER Object
        The DNS ACL object to update. Accepts pipeline input from Get-B1DNSACLItem.

    .PARAMETER Force
        Perform the operation without prompting for confirmation. By default, this function will not prompt for confirmation unless $ConfirmPreference is set to Medium.

    .EXAMPLE
        Set-B1DNSACL -Name 'My ACL' -NewName 'My New ACL' -Tags @{'Tag1' = 'Val1'}

        comment        : Hello World
        compartment_id :
        id             : dns/acl/2fwefef3r-sfef-44fg-bfg4-bgvdgrthfdd
        list           : {@{access=; acl=dns/acl/6fewfw3e8-ef4e-sfw3-9sdf-2drghdg4ed2; address=; element=acl; tsig_key=}, @{access=allow; acl=; address=::; element=ip; tsig_key=}}
        name           : My New ACL
        tags           : @{Tag1=Val1}

    .EXAMPLE
        $ItemsToRemove = @()
        $ItemsToRemove += New-B1DNSACLItem -Address 10.24.0.0/16

        Get-B1DNSACL -Name 'My ACL' | Set-B1DNSACL -RemoveItems $ItemsToRemove

        comment        :
        compartment_id :
        id             : dns/acl/2fwefef3r-sfef-44fg-bfg4-bgvdgrthfdd
        list           : {@{access=; acl=dns/acl/6fewfw3e8-ef4e-sfw3-9sdf-2drghdg4ed2; address=; element=acl; tsig_key=}, @{access=allow; acl=; address=10.0.0.0/16;
                        element=ip; tsig_key=}}
        name           : My ACL
        tags           :

    .EXAMPLE
        $ACLsToAdd = @()
        $ACLsToAdd += New-B1DNSACLItem -Access allow -Address 10.24.0.0/16

        Get-B1DNSACL 'My ACL' | Set-B1DNSACL -AddItems $ACLsToAdd

        10.24.0.0/16 already exists in the list of ACLs, but with a different action. Updating the action to: deny

        comment        :
        compartment_id :
        id             : dns/acl/2fwefef3r-sfef-44fg-bfg4-bgvdgrthfdd
        list           : {@{access=; acl=dns/acl/6fewfw3e8-ef4e-sfw3-9sdf-2drghdg4ed2; address=; element=acl; tsig_key=}, @{access=deny; acl=; address=10.24.0.0/16; element=ip; tsig_key=}, @{access=allow; acl=; address=10.0.0.0/16;
                        element=ip; tsig_key=}}
        name           : My ACL
        tags           :

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding(
        DefaultParameterSetName = 'Default',
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param(
      [Parameter(ParameterSetName='Default',Mandatory=$true)]
      [String]$Name,
      [String]$NewName,
      [String]$Description,
      [System.Object]$Items,
      [System.Object]$AddItems,
      [System.Object]$RemoveItems,
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
        if ($Object) {
            $SplitID = $Object.id.split('/')
            if (("$($SplitID[0])/$($SplitID[1])") -ne 'dns/acl') {
                Write-Error "Error. Unsupported pipeline object. This function only supports 'dns/acl' objects as input"
                return $null
            }
        } else {
            $Object = Get-B1DNSACL -Name $Name -Strict
            if (!($Object)) {
                Write-Error "Unable to find DNS ACL: $($Name)"
                return $null
            }
        }

        if (($Items -and $AddItems) -or ($Items -and $RemoveItems)) {
            if ($AddItems) {
                Write-Error '-Items and -AddItems are mutually exclusive parameters. See documentation for help.'
                return $null
            }
            if ($RemoveItems) {
                Write-Error '-Items and -RemoveItems are mutually exclusive parameters. See documentation for help.'
                return $null
            }
        }

        $NewObj = $Object | Select-Object * -ExcludeProperty id

        if ($NewName) {
            $NewObj.name = $NewName
        }
        if ($Description) {
            $NewObj.comment = $Description
        }
        if ($Tags) {
            $NewObj.tags = $Tags
        }
        if ($Items) {
            $NewObj.list = $Items
        }
        if ($AddItems) {
            $ObjList = $NewObj.list
            foreach ($i in $AddItems) {
                ## If IPv6/IPv6 Item
                if ($i.address) {
                    ## Check if Item already exists in list
                    if ($i.address -in $ObjList.GetEnumerator().address) {
                        ## Check if the existing item has the correct ACL action
                        if ($i.access -ne $(($NewObj.list | Where-Object {$_.address -eq $($i.address)})).access) {
                            ## Update the ACL action
                            Write-Colour "$($i.address) already exists in the Access Control List rules for: $($NewObj.name), but with a different action. Updating the action to: ",$($i.access) -Colour 'Cyan','Yellow'
                            ($NewObj.list | Where-Object {$_.address -eq $($i.address)}).access = $i.access
                        } else {
                            Write-Host "$($i.address) already exists in the Access Control List rules for: $($NewObj.name), with action: $($i.access)" -ForegroundColor Cyan
                        }
                    } else {
                        $NewObj.list += $i
                    }
                }
                if ($i.acl) {
                    ## Check if Item already exists in list
                    if ($i.acl -in $ObjList.GetEnumerator().acl) {
                        Write-Host "$($i.acl) already exists in the Access Control List rules for: $($NewObj.name)." -ForegroundColor Cyan
                    } else {
                        $NewObj.list += $i
                    }
                }
                if ($i.tsig_key) {
                    ## Not implemented
                }
            }
        }
        if ($RemoveItems) {
            $ObjList = $NewObj.list
            foreach ($i in $RemoveItems) {
                ## If IPv6/IPv6 Item
                if ($i.address) {
                    ## Check if Item already exists in list & remove it
                    if ($i.address -in $ObjList.GetEnumerator().address) {
                        $NewObj.list = $NewObj.list | Where-Object {$_.address -ne $($i.address)}
                    }
                }
                if ($i.acl) {
                    ## Check if Item already exists in list & remove it
                    if ($i.acl -in $ObjList.GetEnumerator().acl) {
                        $NewObj.list = $NewObj.list | Where-Object {$_.acl -ne $($i.acl)}
                    }
                }
                if ($i.tsig_key) {
                    ## Not implemented
                }
            }
        }
        $JSON = $NewObj | ConvertTo-Json -Depth 5 -Compress

        if($PSCmdlet.ShouldProcess("Update DNS Access Control List:`n$(JSONPretty($JSON))","Update DNS Access Control List: $($Object.name) ($($Object.id))",$MyInvocation.MyCommand)){
            $Results = Invoke-CSP -Method PATCH -Uri "$(Get-B1CSPUrl)/api/ddi/v1/$($Object.id)" -Data $JSON
            if ($Results | Select-Object -ExpandProperty result -EA SilentlyContinue -WA SilentlyContinue) {
                $Results | Select-Object -ExpandProperty result
            } else {
                $Results
            }
        }
    }
}