#Made to simplify copying AD groups between existing users. Gets groups from AD,
#exports them to a .txt file, eliminates useless formatting on the group, then
#opens the file to allow for immediate Ctrl + C

$user = Read-Host "Enter tv name"
$csv = "C:\Users\tvtofa\OneDrive - BlueScope\Desktop\UserADGroups.txt"

Get-ADUser -Identity $user -Properties memberof | Select-Object -ExpandProperty memberof | Out-file -FilePath $csv

$content = Get-Content -Path $csv
$newcontent = $content -replace 'CN=|,OU=.*', ''
Write-Host $newcontent
$newcontent | Set-Content -Path $csv

# Open the CSV file using the default associated program
Start-Process $csv