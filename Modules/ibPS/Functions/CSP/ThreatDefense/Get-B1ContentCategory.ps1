﻿function Get-B1ContentCategory {
    <#
    .SYNOPSIS
        Retrieves a list of content categories from Infoblox Threat Defense

    .DESCRIPTION
        This function is used to retrieve a list of content categories from Infoblox Threat Defense

    .EXAMPLE
        PS> Get-B1ContentCategory

        category_code category_name                        functional_group
        ------------- -------------                        ----------------
                10001 Abortion                             Adult
                10002 Abortion Pro Choice                  Adult
                10003 Abortion Pro Life                    Adult
                10004 Child Inappropriate                  Adult
                10005 Gambling                             Adult
                10006 Gay, Lesbian or Bisexual             Adult
                10007 Lingerie, Suggestive & Pinup         Adult
                10008 Nudity                               Adult
                10009 Pornography                          Adult
                10010 Profanity                            Adult
                10011 R-Rated                              Adult
                10012 Sex & Erotic                         Adult
                10013 Sex Education                        Adult
                10014 Tobacco                              Adult
                10015 Military                             Aggressive
                10016 Violence                             Aggressive
                10017 Weapons                              Aggressive
                10018 Aggressive - Other                   Aggressive
                10019 Fine Art                             Arts
                10020 Arts - Other                         Arts
                10021 Auto Parts                           Automotive
                10022 Auto Repair                          Automotive
                10023 Buying/Selling Cars                  Automotive
                ...

    .FUNCTIONALITY
        Universal DDI

    .FUNCTIONALITY
        Threat Defense
    #>
    [CmdletBinding()]
    param(
    )

    $Results = Invoke-CSP -Method GET -Uri "$(Get-B1CSPUrl)/api/atcfw/v1/content_categories" | Select-Object -ExpandProperty results -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

    if ($Results) {
        return $Results
    }
}