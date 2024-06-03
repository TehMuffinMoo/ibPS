function New-B1SecurityPolicyRule {
    <#
    .SYNOPSIS
        This function is used to create new Security Policy Rules to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

    .DESCRIPTION
        This function is used to create new Security Policy Rules to append or remove to/from an existing or a New Security Policy, using Set-B1SecurityPolicy / New-B1SecurityPolicy.

    .PARAMETER Action
        The security policy rule action to use for this list item
        
    .PARAMETER Object
        The security policy rule name (Either Custom List, Named Feed, Application Filter or Category Filter depending on Type selected)

    .PARAMETER Type
        The type of security policy rule to apply (Custom List / Named Feed (Threat Insight) / Application Filter / Category Filter)

    .PARAMETER Redirect
        The name of the redirect to apply

    .EXAMPLE

    .EXAMPLE
    
    .FUNCTIONALITY
        BloxOne Threat Defense
    #>
    param(
        [ValidateSet('Allow','Block','Log','Redirect','AllowWithLocalResolution')]
        $Action,
        [ValidateSet('Custom','Feed','Application','Category')]
        $Type,
        $Object,
        $Redirect
    )
    
    Switch($Action) {
        "Allow" {
            $ActionName = "action_$($Action.ToLower())"
        }
        "Block" {
            $ActionName = "action_$($Action.ToLower())"
        }
        "Log" {
            $ActionName = "action_$($Action.ToLower())"
        }
        "Redirect" {
            $ActionName = "action_$($Action.ToLower())"
        }
        "AllowWithLocalResolution" {
            $ActionName = "action_allow_with_local_resolution"
        }
    }

    $Obj = [PSCustomObject]@{
        action = $ActionName
    }
}