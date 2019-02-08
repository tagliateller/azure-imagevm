Step 1: Install DHCP Server Role
PowerShell Command:

Install-WindowsFeature -Name 'DHCP' –IncludeManagementTools
Step 2: Add DHCP Scope
PowerShell Command:

Add-DhcpServerV4Scope -Name "DHCP Scope" -StartRange 192.168.1.150 -EndRange 192.168.1.200 -SubnetMask 255.255.255.0
Step 3: Add DNS Server, Router Gateway Options in DHCP
PowerShell Command:

Set-DhcpServerV4OptionValue -DnsServer 192.168.1.10 -Router 192.168.1.1
Step 4: Set Up Lease Duration
PowerShell Command:

Set-DhcpServerv4Scope -ScopeId 192.168.1.10 -LeaseDuration 1.00:00:00
Step 5: Restart DHCP Service
PowerShell Command:

Restart-service dhcpserver
