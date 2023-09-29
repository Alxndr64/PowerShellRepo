<#
Script to cover an array of requests needed from a specific switch.
Ideally, all options will be given, and this should be organized in a way
that makes it easier to add functions.
#>

<#
WORKFLOW
Display nice stuff for user
Give options
#>

#Functions

function Get-LLDPInformation {
    param (
        [string]$SwitchIP
    )

    # Your logic for LLDP information retrieval goes here
    Write-Host "Getting LLDP information from switch with IP: $SwitchIP"

    $WalkRequest = @{
        UserName	= 'OrionAccount'
        Target	= $SwitchIP
        OID		= Read-Host "Enter OID"
        AuthType	= 'MD5'
        AuthSecret	= 'Ori0nP@ssw0rd'
        PrivType	= 'DES'
        PrivSecret	= 'Ori0nP@ssw0rd'
    }

    Invoke-SNMPv3Walk @WalkRequest | Format-Table -AutoSize

}

function Get-VLANInformation {
    param (
        [string]$SwitchIP
    )

    # Your logic for VLAN information retrieval goes here
    Write-Host "Getting VLAN information from switch with IP: $SwitchIP"
}

function Search-MACAddress {
    param (
        [string]$SwitchIP,
        [string]$MACAddress
    )

    # Your logic for MAC address search goes here
    Write-Host "Searching for MAC address $MACAddress on switch with IP: $SwitchIP"
}

# Main script
Write-Host "Welcome to ATSNMP's script!"

Write-Host "Press 1 to get LLDP information from a switch;"
Write-Host "Press 2 to see VLAN information on a switch;"
Write-Host "Press 3 to search for a MAC address on a switch."

$menuChoice = Read-Host -Prompt "What would you like to do?"

$switchIP = Read-Host -Prompt "Enter the IP of the switch: "

switch ($menuChoice) {
    1 { Get-LLDPInformation -SwitchIP $switchIP }
    2 { Get-VLANInformation -SwitchIP $switchIP }
    3 {
        $macAddress = Read-Host -Prompt "Enter the MAC address to search for: "
        Search-MACAddress -SwitchIP $switchIP -MACAddress $macAddress
    }
    default { Write-Host "Invalid choice. Exiting." }
}
