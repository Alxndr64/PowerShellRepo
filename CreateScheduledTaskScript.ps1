$TaskName = Read-Host "Name of the task to be created"
$username = "cbu-abrahamt"
$password = "AlexAbraham64.!"

#Note: Had to go to the actual task scheduler and add "" to the script to execute due to the space in Scripts Here.
$Action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "C:\Users\cbu-abrahamt\Desktop\Scripts Here\ScheduledCopyRanchoConfigs.ps1" #Replace with script needed
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5) -RepetitionDuration (New-TimeSpan -Hours 23 -Minutes 55)
$ScheduledTask = New-ScheduledTask -Action $action -Trigger $trigger 
 
Register-ScheduledTask -TaskName $TaskName -InputObject $ScheduledTask -User $username -Password $password

#Or for daily (untested, just used as template)

<#
$TaskName = Read-Host "Name of the task to be created"
$username = "cbu-abrahamt"
$password = "AlexAbraham64.!"
 
$Action = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "C:\Users\cbu-abrahamt\Desktop\Scripts Here\ScheduledCopyRanchoConfigs.ps1"
$Trigger = New-ScheduledTaskTrigger -Daily -At 6am
$ScheduledTask = New-ScheduledTask -Action $action -Trigger $trigger 
 
Register-ScheduledTask -TaskName $TaskName -InputObject $ScheduledTask -User $username -Password $password
#>