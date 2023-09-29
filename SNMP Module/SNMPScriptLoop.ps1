#Loop to set up SNMPv3 for Orion on switches
#Change the $switches .txt with the IP addresses needed

$user = "cbu-abrahamt"
$pass = ConvertTo-SecureString -String "AlexAbraham64.!" -AsPlainText -Force
$switches = Get-Content .\Docs-Outputs\SNMPLooptext.txt
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pass

foreach ($switch in $switches) {
	try {
		Write-Host "Initiating " $switch
		$uplink = Read-Host "Enter interface port to tag as Uplink"

		$Session = New-SSHSession -ComputerName $switch -Credential $credentials -AcceptKey:$true 

		$stream = $session.Session.CreateShellStream("dumb", 0, 0, 0, 0, 1000)
		start-sleep 2
		$stream.Write("`n")
		$stream.Write("config`n")
		start-sleep 2
		$stream.Write("console inactivity-timer 5`n")
		start-sleep 2
		$stream.Write("snmpv3 enable`n")
		start-sleep 3
		$stream.Write("Agn8th9`n")
		start-sleep 2
		$stream.Write("Agn8th9`n")
		start-sleep 2
		$stream.Write("n`n")
		start-sleep 2
		$stream.Write("n`n")
		start-sleep 2
		$stream.Write("snmpv3 user NetworkAdmin auth md5 woll0ng8ng priv woll0ng8ng`n")
		start-sleep 2
		$stream.Write("snmpv3 group managerpriv user NetworkAdmin sec-model ver3`n")
		start-sleep 2
		$stream.Write("snmpv3 user OrionAccount auth md5 Ori0nP@ssw0rd priv Ori0nP@ssw0rd`n")
		start-sleep 2
		$stream.Write("snmpv3 group operatorauth user OrionAccount sec-model ver3`n")
		start-sleep 2
		$stream.Write("no snmpv3 user initial`n")
		start-sleep 2
		#$stream.Write("no snmp-server community "St33lscap3"`n")
		#start-sleep 2
		#$stream.Write("no snmp-server community "st33lscap3"`n")
		#start-sleep 2
		$stream.Write("int $uplink `n")
		start-sleep 2
		$stream.Write("name Uplink`n")
		start-sleep 5
		$stream.Write("wr mem`n")
		start-sleep 2
		$stream.Write("exit`n")
		start-sleep 2

		Remove-SSHSession -Index 0 | Out-Null

		Write-Output "$switch settings configured. Moving on..."

	} catch {
		
		Write-Output "$switch unaccessible"
		Continue
	}
}

