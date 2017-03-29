. (join-path $PSScriptroot './Load-Credentials.ignore.ps1')

function Write-DataRow($object) {
    if(($object.LineNo % 6 -ne 0)) {
        $object | Format-Table -HideTableHeaders
    } else {
        $object | Format-Table
    }
}

$loops = 200
$results = @()
$mgtPtOperationResults = @()
$mgtPtStatusResults = @()
#for($i = 0; $i -lt $loops; $i++) {
$i = 0
while($true) {
    $i++
    $CurrentDateTime = Get-Date -Format g

    $result = Invoke-WebRequest "http://localhost:9092/api/controllers/LL1NTEST01/mgmtpoints/187" | 
    ConvertFrom-Json  |
    select -ExpandProperty data |
    select *
    
    $result | Add-Member -Type NoteProperty -Name LogDT -Value $CurrentDateTime
    $result | Add-Member -Type NoteProperty -Name LineNo -Value $i
    $results += $result | select LineNo, LogDT, id, onOffMode, operationMode, roomTemp, setpoint, inMaintenanceMode, inEquipmentError, inCommunicationError

    
    $mgtPtOperationResult = Invoke-MySql -ConnectionString $ConnectionString -Query "SELECT * FROM itabcadm.mgmtpt_operating where MGMTPT_PK = 187"
    
    $mgtPtOperationResult | Add-Member -Type NoteProperty -Name LogDT -Value $CurrentDateTime
    $mgtPtOperationResult | Add-Member -Type NoteProperty -Name LineNo -Value $i
    Write-DataRow $mgtPtOperationResult
    $mgtPtOperationResults += $mgtPtOperationResult

    $mgtPtStatusResult = Invoke-MySql -ConnectionString $ConnectionString -Query "SELECT * FROM itabcadm.mgmtpt_status where MGMTPT_PK = 187"
    
    $mgtPtStatusResult | Add-Member -Type NoteProperty -Name LogDT -Value $CurrentDateTime
    $mgtPtStatusResult | Add-Member -Type NoteProperty -Name LineNo -Value $i
    $mgtPtStatusResults += $mgtPtStatusResult

    Start-Sleep -Milliseconds 300
    if(($i % 15) -eq 0) {
        #Write-Progress -Activity "Gathering api data for $loops loops" -PercentComplete (($i / $loops) * 100)
    }
}

$results | Out-GridView
$mgtPtOperationResults | Out-GridView
$mgtPtStatusResults | Out-GridView






