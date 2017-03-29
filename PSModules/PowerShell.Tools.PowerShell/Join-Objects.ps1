function Join-Objects([PSObject[]] $Objects, [switch] $returnHashTable) {
    $objProperties = [ordered]@{}
    foreach ($obj in $objects) {
        foreach($prop in $obj.PSObject.Properties | Where-Object { $_.MemberType -eq 'NoteProperty'}) {
            $keyName = $prop.Name
            if($objProperties.Contains($prop.Name)){
                $suffix = 1
                $newName = $prop.Name+$suffix
                while($objProperties.Contains($newName)){
                 $suffix++
                 $newName = $prop.Name+$suffix
                }
                $keyName = $newName
            }
           
            $objProperties.Add($keyName, $prop.Value)
        } 
    }
    if($returnHashTable) {
        return $objProperties
    }        
    New-Object -TypeName PSCustomObject -Property $objProperties

} 