# Set VM Name, Switch Name, and Installation Media Path.
$VMName = 'LinuxVM'
$Switch = 'InternalNATSwitch'
$InstallMedia = 'C:\Users\azureuser\Downloads\CentOS-7-x86_64-Minimal-1810.iso'

# Create New Virtual Machine
New-VM -Name $VMName -MemoryStartupBytes 2147483648 -Generation 1 -NewVHDPath "D:\Virtual Machines\$VMName\$VMName.vhdx" -NewVHDSizeBytes 53687091200 -Path "D:\Virtual Machines\$VMName" -SwitchName $Switch

# Add DVD Drive to Virtual Machine
Add-VMScsiController -VMName $VMName
Add-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path $InstallMedia

# Mount Installation Media
$DVDDrive = Get-VMDvdDrive -VMName $VMName

# Configure Virtual Machine to Boot from DVD
Set-VMFirmware -VMName $VMName -FirstBootDevice $DVDDrive