$WalkRequest = @{
    UserName	= 'OrionAccount'
    Target	= '172.23.34.47'
    OID		= Read-Host "Enter OID"
    AuthType	= 'MD5'
    AuthSecret	= 'Ori0nP@ssw0rd'
    PrivType	= 'DES'
    PrivSecret	= 'Ori0nP@ssw0rd'
}

Invoke-SNMPv3Get @WalkRequest | Format-Table -AutoSize