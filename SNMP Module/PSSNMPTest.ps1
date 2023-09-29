$WalkRequest = @{
    UserName	= 'OrionAccount'
    Target	= '172.23.34.47'
    OID		= Read-Host "Enter OID"
    AuthType	= 'MD5'
    AuthSecret	= 'Ori0nP@ssw0rd'
    PrivType	= 'DES'
    PrivSecret	= 'Ori0nP@ssw0rd'
}

Invoke-SNMPv3Walk @WalkRequest | Format-Table -AutoSize
#Invoke-SNMPv3Walk @WalkRequest | Select-String -Pattern "00 10 49"	#Works great to sarch for output