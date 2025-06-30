function New-B1SecurityPolicyRule {
    <#
    .SYNOPSIS
        This function is used to create new Security Policy Rules to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

    .DESCRIPTION
        This function is used to create new Security Policy Rules to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

    .PARAMETER Action
        The security policy rule action to use for this list item

    .PARAMETER Log
        The security policy rule log action to use for this list item. Defaults to Log.

    .PARAMETER Object
        The security policy rule name (Either Custom List, Named Feed, Application Filter or Category Filter depending on Type selected)

        When using Custom List, the auto-complete works based on the Key, not the Name. This can be found using Get-B1CustomList

    .PARAMETER Type
        The type of security policy rule to apply (Custom List / Named Feed (Threat Insight) / Application Filter / Category Filter)

    .PARAMETER Redirect
        The name of the redirect to apply. If 'Default' is specified, the default redirect configuration will be used.

    .EXAMPLE

    .EXAMPLE

    .FUNCTIONALITY
        Infoblox Threat Defense
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param(
        [ValidateSet('Allow','Block','Redirect','AllowWithLocalResolution')]
        $Action,
        [ValidateSet('Log','NoLog')]
        $Log = 'Log',
        [ValidateSet('Custom','Feed','Application','Category')]
        $Type,
        $Object,
        $Redirect
    )
    Switch($Action) {
        "Allow" {
            Switch($Log) {
                'Log' {
                    $ActionName = "action_log"
                }
                'NoLog' {
                    $ActionName = "action_allow"
                }
            }
        }
        "Block" {
            Switch($Log) {
                'Log' {
                    $ActionName = "action_block"
                }
                'NoLog' {
                    $ActionName = "action_block_nolog"
                }
            }
        }
        "Redirect" {
            Switch($Log) {
                'Log' {
                    $ActionName = "action_redirect"
                }
                'NoLog' {
                    $ActionName = "action_redirect_nolog"
                }
            }
        }
        "AllowWithLocalResolution" {
            $ActionName = "action_allow_with_local_resolution"
        }
    }

    Switch($Type) {
        "Custom" {
            $TypeName = "custom_list"
        }
        "Feed" {
            $TypeName = "named_feed"
        }
        "Application" {
            $TypeName = "application_filter"
        }
        "Category" {
            $TypeName = "category_filter"
        }
    }

    if ($Redirect) {
        if ($Redirect -ne 'Default') {
            $RedirectName = $Redirect
        }
    }

    $Obj = [PSCustomObject]@{
        action = $ActionName
        data = $Object
        type = $TypeName
        redirect_name = $RedirectName
    }

    return $Obj
}