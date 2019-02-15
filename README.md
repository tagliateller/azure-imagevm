# azure-imagevm

## Upload Image

az group create \
    --name myResourceGroup \
    --location eastus
	
az storage account create \
    --resource-group myResourceGroup \
    --location eastus \
    --name mystorageaccount \
    --kind Storage \
    --sku Standard_LRS
	
az storage account keys list \
    --resource-group myResourceGroup \
    --account-name mystorageaccount
	
	
info:    Executing command storage account keys list
+ Getting storage account keys
data:    Name  Key                                                                                       Permissions
data:    ----  ----------------------------------------------------------------------------------------  -----------
data:    key1  d4XAvZzlGAgWdvhlWfkZ9q4k9bYZkXkuPCJ15NTsQOeDeowCDAdB80r9zA/tUINApdSGQ94H9zkszYyxpe8erw==  Full
data:    key2  Ww0T7g4UyYLaBnLYcxIOTVziGAAHvU+wpwuPvK4ZG0CDFwu/mAxS/YYvAQGHocq1w7/3HcalbnfxtFdqoXOw8g==  Full
info:    storage account keys list command OK

key1 beachten !!!

az storage container create \
    --account-name mystorageaccount \
    --name mydisks
	
az storage blob upload --account-name mystorageaccount \
    --account-key key1 \
    --container-name mydisks \
    --type page \
    --file /path/to/disk/mydisk.vhd \
    --name myDisk.vhd
	
Create a managed disk

az disk create \
    --resource-group myResourceGroup \
    --name myManagedDisk \
  --source https://mystorageaccount.blob.core.windows.net/mydisks/myDisk.vhd
  
Create the VM

az vm create \
    --resource-group myResourceGroup \
    --location eastus \
    --name myNewVM \
    --os-type linux \
    --attach-os-disk myManagedDisk
	
## PowerShell

Test Version:
$PSVersionTable.PSVersion

Install-Module -Name Az -AllowClobber
-> Y muss eingegeben werden: 1x für NuGet und einmal für das Untrust ...

So ermittelt man die Credentials

Enable-AzContextAutosave

# Connect to Azure with a browser sign in token

PS C:\Users\azureuser> Connect-AzAccount -ServicePrincipal -Credential $pscredential -TenantId XYZ

--> AzureRmContext muss in c:\Users\azureuser\.Azure\AzureRmContext.json

PS C:\Users\azureuser>

$location = "East US"
$resourceGroup = "OsImagesRG"

New-AzResourceGroup -Name $resourceGroup -Location $location

$storageAccountName = "storageosimages"
  
New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Location $location -SkuName Standard_LRS -Kind StorageV2 
	
$storageAccountName = "storageosimages"
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroup -Name $storageAccountName).Value[0]

az storage container create \
    --account-name mystorageaccount \
    --name mydisks
	
az storage container create \
    --account-name mystorageaccount \
    --name mydisks
	
$ctx = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
$storageContainerName = "rhel7image"
New-AzStorageContainer -Name $storageContainerName -Context $ctx

auch als Beispiel: https://docs.microsoft.com/de-de/azure/storage/blobs/storage-quickstart-blobs-powershell

az storage blob upload --account-name mystorageaccount \
    --account-key key1 \
    --container-name mydisks \
    --type page \
    --file /path/to/disk/mydisk.vhd \
    --name myDisk.vhd

	# upload a file
set-AzStorageblobcontent -File "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\rhel7.vhd" -Container $storageContainerName -Blob "rhel7.vhd" -Context $ctx -BlobType Page

## Test in der Cloud Shell

az group create --name TestLinuxImageRG --location EastUS

az disk create --resource-group TestLinuxImageRG --name rhelmanageddisk --source https://storageosimages.blob.core.windows.net/rhel7image/rhel7.vhd
  
az vm create --resource-group TestLinuxImageRG --location eastus --name TestRHELVM --os-type linux --attach-os-disk rhelmanageddisk
