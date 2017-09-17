function Start-Timer {
    param(
      [Parameter(Mandatory=$true)]
      [int] $timeout, 
              
      [ValidateSet('sec','min','hour')]        
      [string]$unit = 'sec'
    )
    
    $existing = Get-EventSubscriber -SourceIdentifier TimerElapsed -ErrorAction SilentlyContinue
    if($existing){
      Write-Host "A timer is already running" -ForegroundColor Red
      return $null
    }
    
    switch($unit){
      'sec' { $timeout *= 1000 }
      'min' { $timeout *= 60000 }
      'hour' { $timeout *= 3600000 }
    }    

    $timer = New-Object -TypeName timers.timer
    $timer.Interval = $timeout
    $timer.Enabled = $true
    
    $timerElapsedAction = {
      Unregister-Event -SourceIdentifier TimerElapsed
      Remove-Job -Name TimerElapsed 
      
      for ($i = 1; $i -lt 5; $i += 1) 
      {        
        [console]::beep(2000,500)
        [console]::beep(5000,500)
      }      
    }
    
    $null = Register-ObjectEvent -InputObject $timer -EventName Elapsed -SourceIdentifier TimerElapsed -Action $timerElapsedAction
    
    $timer.Start() 
    Write-Host "Timer started" -ForegroundColor Green
}