This powershell script create a virtual switch named '**Default Switch**', virtual switch type '**internal**' on the local virtual machine host, and deploy an Internet Protocol (IP) version 4 Dynamic Host Configuration Protocol (DHCP) server that automatically assigns IP addresses and DHCP options to IPv4 DHCP clients on the virtual switch.  **Authorization might be required to deploy a DHCP server in a corporate network environment.  Be sure to check if the virtual switch configuration complies to the polices of your corporate network**.

The DHCP server setup is based on the instructions from the document [Deploy DHCP Using Windows PowerShell](https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps). with the following parameter:
- Retrive the ipv4 address of the virtual network switch adapter is xxx.xxx.xxx.yyy
- Setting gateway address (xxx.xxx.xxx.1)
- Create a Network Address Translation (NAT) object (xxx.xxx.xxx.0/24) that translates an internal network address to an external network address
- Install DHCP service feature (if it's not installed)
- Add the DHCP default local security groups
- Configure a DHCP server, ip range (xxx.xxx.xxx.100 - xxx.xxx.xxx.200, subnet mask 255.255.255.0)
- Set DHCP server Ipv4 default gateway option (xxx.xxx.xxx.1) at the scope (xxx.xxx.xxx.0)