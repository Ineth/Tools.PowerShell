function Merge-Objects([PSObject[]] $Objects, [switch] $returnHashTable) {
    $objProperties = [ordered]@{}
    foreach ($obj in $objects) {
        foreach($prop in $obj.PSObject.Properties | Where-Object { $_.MemberType -eq 'NoteProperty'}) {
            $keyName = $prop.Name
            if(!$objProperties.Contains($prop.Name)){               
                $objProperties[$prop.Name] = $prop.Value
            } else {
                $objProperties.Add($keyName, $prop.Value)
            }           
        } 
    }
    if($returnHashTable) {
        return $objProperties
    }        
    New-Object -TypeName PSCustomObject -Property $objProperties

} 