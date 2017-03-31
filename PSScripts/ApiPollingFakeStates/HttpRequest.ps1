. (join-path $PSScriptroot './Load-Credentials.ignore.ps1')


$results = @()
$mgtPtOperationResults = @()
$mgtPtStatusResults = @()
$dataRows = @()
$dataRowObjects = @()
$dateTimeFormat = 'HH:mm:ss.fff'
$mySqlDateFormat = "%e/%c/%y %T"

# Load subfunctions

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
    $results += $result | select LineNo, LogDT, id, onOffMode, operationMode

    return $result | select LineNo, LogDT, id, onOffMode , isOnOffFakeState, operationMode, isOperationModeFakeState
}

function Get-MgmtPointOperationData($lineNo) {
    $mgtPtOperationResult = Invoke-MySql -ConnectionString $ConnectionString -Query "SELECT *, DATE_FORMAT(UPDATE_DT,'$mySqlDateFormat') AS UPDATE_DT_F FROM itabcadm.mgmtpt_operating where MGMTPT_PK = 187"
    
    $mgtPtOperationResult | Add-Member -Type NoteProperty -Name LineNo -Value $lineNo
    $mgtPtOperationResult | Add-Member -Type NoteProperty -Name LogDT -Value (Get-Date -Format $dateTimeFormat)
    
    Write-DataRow $mgtPtOperationResult
    $mgtPtOperationResults += $mgtPtOperationResult
    
    return $mgtPtOperationResult | select LineNo, LogDT, UPDATE_DT, SEND_STATUS, CHANGE_ON_OFF, ON_OFF, CHANGE_OP_MODE, OPERATION_MODE
}

function Get-MgmtPointStatusData($lineNo) {    
    $mgtPtStatusResult = Invoke-MySql -ConnectionString $ConnectionString -Query "SELECT *, DATE_FORMAT(RECEIVE_DT,'$mySqlDateFormat') AS RECEIVE_DT_F, DATE_FORMAT(REPORT_DT,'$mySqlDateFormat') As REPORT_DT_F FROM itabcadm.mgmtpt_status where MGMTPT_PK = 187"
    
    $mgtPtStatusResult | Add-Member -Type NoteProperty -Name LineNo -Value $lineNo
    $mgtPtStatusResult | Add-Member -Type NoteProperty -Name LogDT -Value (Get-Date -Format $dateTimeFormat)
    $mgtPtStatusResults += $mgtPtStatusResult

    return $mgtPtStatusResult | select LineNo, LogDT, RECEIVE_DT_F, REPORT_DT_F, ON_OFF, OPERATION_MODE 
}

function Get-MgmtPointErrorData($lineNo) {
    $mgtPointErrorResult = Invoke-MySql -ConnectionString $ConnectionString -Query "SELECT *, DATE_FORMAT(RECEIVE_DT,'$mySqlDateFormat') As RECEIVE_DT_F, DATE_FORMAT(REPORT_DT,'$mySqlDateFormat') As REPORT_DT_F FROM itabcadm.mgmtpt_error where MGMTPT_PK = 187"
    
    $mgtPointErrorResult | Add-Member -Type NoteProperty -Name LineNo -Value $lineNo
    $mgtPointErrorResult | Add-Member -Type NoteProperty -Name LogDT -Value (Get-Date -Format $dateTimeFormat)

    return $mgtPointErrorResult | select LineNo, LogDT, RECEIVE_DT_F, REPORT_DT_F, ERROR_OCCURENCE_DT, ERROR_TYPE
}

# Start logging

Write-host $("Started at: $(Get-Date -Format $dateTimeFormat)") -ForegroundColor Green
try {
    $lineNo = 0
    while($true) {
        $lineNo++
        $dataRowObjects = @()

        $dataRowObjects += Get-MgmtPointInfo -lineNo $lineNo    
        $dataRowObjects += Get-MgmtPointOperationData -lineNo $lineNo
        $dataRowObjects += Get-MgmtPointStatusData -lineNo $lineNo
        $dataRowObjects += Get-MgmtPointErrorData -lineNo $lineNo
        $dataRows += Join-Objects -Objects $dataRowObjects

        Start-Sleep -Milliseconds 100
    }
} finally {
    write-Host 'Exporting data...'
    $dataRows | Export-Csv  -Path $("mgmtPoint-monitoring $(Get-Date -Format 'HH-mm-ss') ($($i) records).csv") -NoTypeInformation -Force
}

# show seperate data output as gridview

$results | Out-GridView
$mgtPtOperationResults | Out-GridView
$mgtPtStatusResults | Out-GridView
$dataRows | Out-GridView