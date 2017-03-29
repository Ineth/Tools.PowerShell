. (join-path $PSScriptroot './Load-Credentials.ignore.ps1')

function Write-DataRow($object) {
    if(($object.LineNo % 6 -ne 0)) {
        $object | Format-Table -HideTableHeaders
    } else {
        $object | Format-Table
    }
}

function Get-MgmtPointInfo($lineNo) {
    $result = Invoke-WebRequest "http://localhost:9092/api/controllers/LL1NTEST01/mgmtpoints/187" | 
    ConvertFrom-Json  |
    select -ExpandProperty data |
    select *
    
    $result | Add-Member -Type NoteProperty -Name LineNo -Value $lineNo
    $result | Add-Member -Type NoteProperty -Name LogDT -Value (Get-Date -Format $dateTimeFormat)
    #$results += $result | select LineNo, LogDT, id, onOffMode, operationMode

    return $result | select LineNo, LogDT, id, onOffMode , operationMode
}

function Get-MgmtPointOperationData($lineNo) {
    $mgtPtOperationResult = Invoke-MySql -ConnectionString $ConnectionString -Query "SELECT * FROM itabcadm.mgmtpt_operating where MGMTPT_PK = 187"
    
    $mgtPtOperationResult | Add-Member -Type NoteProperty -Name LineNo -Value $lineNo
    $mgtPtOperationResult | Add-Member -Type NoteProperty -Name LogDT -Value (Get-Date -Format $dateTimeFormat)
    
    Write-DataRow $mgtPtOperationResult
    #$mgtPtOperationResults += $mgtPtOperationResult
    
    return $mgtPtOperationResult | select LineNo, LogDT, SENDSTATUS, CHANGEON_OFF, ONOFF, CHANGEOPMODE, OPERATIONMODE
}

function Get-MgmtPointStatusData($lineNo) {    
    $mgtPtStatusResult = Invoke-MySql -ConnectionString $ConnectionString -Query "SELECT * FROM itabcadm.mgmtpt_status where MGMTPT_PK = 187"
    
    $mgtPtStatusResult | Add-Member -Type NoteProperty -Name LineNo -Value $lineNo
    $mgtPtStatusResult | Add-Member -Type NoteProperty -Name LogDT -Value (Get-Date -Format $dateTimeFormat)
    $mgtPtStatusResults += $mgtPtStatusResult

    return $mgtPtStatusResult | select LineNo3, LogDT, RECEIVEDT, REPORTDT, ON_OFF, OPERATION_MODE 
}

$loops = 200
$results = @()
$mgtPtOperationResults = @()
$mgtPtStatusResults = @()
$dataRows = @()
$dataRowObjects = @()
$dateTimeFormat = 'HH:mm:ss.fff'

#for($i = 0; $i -lt $loops; $i++) {
$i = 0
while($true) {
    $i++
    $dataRowObjects = @()

    $dataRowObjects += Get-MgmtPointInfo -lineNo $i    
    $dataRowObjects += Get-MgmtPointOperationData -lineNo $i
    $dataRowObjects += Get-MgmtPointStatusData -lineNo $i

    Start-Sleep -Milliseconds 200
    if(($i % 15) -eq 0) {
        #Write-Progress -Activity "Gathering api data for $loops loops" -PercentComplete (($i / $loops) * 100)
    }

    $dataRows += Join-Objects -Objects $dataRowObjects
}

#$results | Out-GridView
#$mgtPtOperationResults | Out-GridView
#$mgtPtStatusResults | Out-GridView
$dataRows | Out-GridView

$dataRows | Export-Csv  -Path $("mgmtPoint-monitoring $(Get-Date -Format 'HH-mm-ss') ($($i) records).csv") -NoTypeInformation -Force


#$newObject = @{}
#$test = $mgtPtOperationResult | select ON_OFF, OPERATION_Mode 
#$test.PSObject.Properties |
#foreach {
#    Write-Host $_.Name $_.Value
#    $newObject.Add($_.Name,$_.value)
#}
#
#New-Object -TypeName PSCustomObject -Property $newObject | Export-Csv -Path 'myData.csv' -NoTypeInformation -Force
#
#$myObjects = @()
#$myObjects += $mgtPtOperationResult | select ON_OFF, OPERATION_Mode
#$myObjects += $result | select onoffMode, operationMode
#Merge-Objects -objects $myObjects