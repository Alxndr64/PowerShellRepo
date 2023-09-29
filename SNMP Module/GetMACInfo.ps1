# Script to get MAC entries from a switch. Converts decimal MAC address obtained from hpSecAuthAddress into Hex values

Import-Module -Name SNMPv3

$Request = @{
	UserName	=	'OrionAccount'
	Target		=	'172.23.34.47'				#Read-Host "Enter IP"
	AuthType	=	'MD5'
	AuthSecret	=	'Ori0nP@ssw0rd'
	PrivType	=	'DES'
	PrivSecret	=	'Ori0nP@ssw0rd'
}

# MAC OID for Aruba switches
$MACOID		=	'1.3.6.1.4.1.11.2.14.2.10.5.1.3.1'

# Perform an SNMP walk to retrieve LLDP information
$MACAddresses = Invoke-SNMPv3Walk -OID $MACOID @Request

# Create an array to store custom objects
$macEntries = @()

# Extract OID's
$extractOID = $MACAddresses | Select-Object -ExpandProperty OID

$decimalMAC = $extractOID | ForEach-Object {
	$_ -replace '1.3.6.1.4.1.11.2.14.2.10.5.1.3.1.'
}

foreach ($MACPort in $decimalMAC) {
    # Split the MACPort into two variables
    $port, $decMAC = $MACPort -split '\.', 2

    # Convert decimal MAC to hexadecimal
    $hexMAC = ($decMAC -split '\.' | ForEach-Object {
    [Convert]::ToString($_, 16)
    }) -join '.'

	# Create a custom object for the entry
	$macEntry = [PSCustomObject]@{
		Port	=	$port
		DecMAC	=	$decMAC
		HexMAC	=	$hexMAC
	}

	# Add the custom object to the array
	$macEntries += $macEntry
}

# Output the array of custom objects
$macEntries



