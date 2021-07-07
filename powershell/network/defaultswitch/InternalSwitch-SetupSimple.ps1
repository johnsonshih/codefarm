# Create VM switch
New-VMSwitch -Name "Default Switch" -SwitchType Internal
$netAdapter = Get-NetAdapter -Name '*Default Switch*'
if (-Not (($netAdapter | measure).Count -eq 1)) {
    throw "Only one network adapter for 'Default Switch' expected"
}

# Get IP address octet
$ifIndex = $netAdapter.ifIndex
$ipAddressDesc = Get-NetIPAddress -AddressFamily IPv4  -InterfaceIndex $ifIndex
if (-Not (($ipAddressDesc | measure).Count -eq 1)) {
    throw "Only one IP address descriptor for interface $ifIndex expected"
}
$octets = ($ipAddressDesc.IPAddress -split "\.")
if (-Not ($octets.length -eq 4)) {
    throw "Could not parse IP address octet for IP '$($ipAddressDesc.IPAddress)'"
}

# Set gateway IP address
$octets[3] = "1"
$gatewayIp = ($octets -join ".")
New-NetIPAddress -IPAddress $gatewayIp -PrefixLength 24 -InterfaceIndex $ifIndex

# Create NAT object
$octets[3] = "0"
$natIp = ($octets -join ".")
New-NetNat -Name "Default Switch" -InternalIPInterfaceAddressPrefix "$natIp/24"

# Install DHCP server
Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools
netsh dhcp add securitygroups
Restart-Service dhcpserver

# Configure DHCP server
$octets[3] = "100"
$startIp = ($octets -join ".")
$octets[3] = "200"
$endIp = ($octets -join ".")
Add-DhcpServerV4Scope -Name "AzureIoTEdgeScope" -StartRange $startIp -EndRange $endIp -SubnetMask 255.255.255.0 -State Active
#$octets[3] = "10"
#$dnsIp = ($octets -join ".")
#Set-DhcpServerV4OptionValue -ScopeID $natIp -DnsServer $dnsIp -Router $gatewayIp
Set-DhcpServerV4OptionValue -ScopeID $natIp -Router $gatewayIp
Restart-service dhcpserver