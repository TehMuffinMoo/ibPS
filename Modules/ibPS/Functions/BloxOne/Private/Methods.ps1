## Methods
$GetID = {
    $ID = "$($this.id)"
    return $ID
}

function Create-B1Object($Obj) {
    Add-Member -InputObject $Obj -MemberType ScriptMethod -Name 'GetID' -Value $GetID
    return $Obj
}