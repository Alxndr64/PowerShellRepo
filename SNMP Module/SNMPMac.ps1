$Request = @{
    UserName    = 'OrionAccount'
    Target      = '152.153.119.1'
    AuthType    = 'MD5'
    AuthSecret  = 'Ori0nP@ssw0rd'
    PrivType    = 'DES'
    PrivSecret  = 'Ori0nP@ssw0rd'
}

# LLDP-MIB OIDs for Aruba switches
$lldpRemPortDesc	=	'1.0.8802.1.1.2.1.4.1.1.8.0'	# LLDP remote port description
$lldpRemSysName		=	'1.0.8802.1.1.2.1.4.1.1.9.0'	# LLDP remote system name
$lldpRemChassisId	=	'1.0.8802.1.1.2.1.4.1.1.5.0'	# LLDP remote chassis ID
$lldpRemSysDesc		=	'1.0.8802.1.1.2.1.4.1.1.10.0'	# LLDP remote system description
$ifAlias		=	'1.3.6.1.2.1.31.1.1.1.18'	# Interface Alias
$ifID			=	'1.0.8802.1.1.2.1.3.7.1.4'	#Interface ID

$ifIP			=	'1.0.8802.1.1.2.1.4.2.1.3.0'	#Interface IP if any

# Perform an SNMP walk to retrieve LLDP information
$lldpInfo = Invoke-SNMPv3Walk -OID $lldpRemPortDesc @Request

# Get the dynamic suffixes for specific ports from the remote port walk
$remotePortSuffixes = $lldpInfo | Select-Object -ExpandProperty OID

#To be used for all remote data
$portNumbers = $remotePortSuffixes | ForEach-Object {
    $_ -replace '1.0.8802.1.1.2.1.4.1.1.8.0.'
}

#Array having only port numbers to be used with PortName and LocalPort
$portValues = $portNumbers | ForEach-Object {
    $_.Split('.')[0]
}

$index = 0
while ($index -lt $lldpInfo.Count) {

	$Interface = $index + 1  # Adjust the interface number based on the loop index

	$PortName = Invoke-SNMPv3Get -OID "$ifAlias.$($portValues[$index])" @Request
	$LocalPort = Invoke-SNMPv3Get -OID "$ifID.$($portValues[$index])" @Request
	$RemotePort = Invoke-SNMPv3Get -OID "$lldpRemPortDesc.$($portNumbers[$index])" @Request
	$SystemName = Invoke-SNMPv3Get -OID "$lldpRemSysName.$($portNumbers[$index])" @Request
	#$SystemChassis = Invoke-SNMPv3Get -OID "$lldpRemChassisId.$($portNumbers[$index])" @Request
	$SystemDesc = Invoke-SNMPv3Get -OID "$lldpRemSysDesc.$($portNumbers[$index])" @Request

	$SystemIP = Invoke-SNMPv3Walk -OID "$ifIP.$($portNumbers[$index]).1.4" @Request

	Write-Host "PortName: $($PortName.Value)"
	Write-Host "LocalPort: $($LocalPort.Value)"
	Write-Host "RemotePort: $($RemotePort.Value)"
	Write-Host "SystemName: $($SystemName.Value)"
	#Write-Host "SystemChassis: $($SystemChassis.Value)"
	Write-Host "SystemDesc: $($SystemDesc.Value)"


	# Extracting IP addresses from OID variable
	if ($SystemIP.OID -ne $null -and $SystemIP.OID -ne '') {
		$oidSegments = $SystemIP.OID -split '\.'
	
		$ipSegments = $oidSegments | Where-Object { $_ -match '^\d+$' }

		if ($ipSegments.Count -ge 4) {
        		$extractedIP = ($ipSegments[-4..-1] -join '.')
			Write-Host "Extracted IP Address: $extractedIP"
		} else {
			Write-Host "Not enough numeric segments resembling an IP address found."
		}
	} else {
   		Write-Host "No IP found."
	}

	Write-Host ""

	$index++                
}