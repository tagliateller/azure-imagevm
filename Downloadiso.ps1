<Path>powershell -NoLogo -Command "Invoke-WebRequest -Uri 'https://some.remote.private.location/myfile.ps1' -OutFile 'c:\Windows\Temp\myfile.ps1' -UseBasicParsing -Credential (New-Object PSCredential('user123', (ConvertTo-SecureString -AsPlainText -Force -String 'password123')))"</Path>