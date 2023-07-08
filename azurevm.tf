terraform {
 required_providers {
  azurerm = {
   source = "hashicorp/azurerm"
   version = ">=3.48.0"
  }
 }
}
provider "azurerm" {
 features {}
}
resource "azurerm_resource_group" "rg" {
 location = "eastus"
 name  = "azure-rg"
}
module "vnet" {
 source       = "Azure/vnet/azurerm"
 version      = "4.1.0"
 vnet_location   = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 subnet_names    = ["subnet1"]
 subnet_prefixes  = ["10.0.1.0/24"]
 use_for_each    = true
 depends_on = [
  azurerm_resource_group.rg
 ]
}
module "linuxservers" {
 source       = "Azure/compute/azurerm"
 version      = "5.3.0"
 resource_group_name = azurerm_resource_group.rg.name
 location      = azurerm_resource_group.rg.location
 vm_os_simple    = "UbuntuServer"
 remote_port    = 22
 vm_size      = "Standard_B1s"
 vm_os_publisher  = "Canonical"
 vm_os_offer    = "0001-com-ubuntu-server-focal"
 vm_os_sku     = "20_04-lts-gen2"
 vm_os_version   = "latest"
 vnet_subnet_id = module.vnet.vnet_subnets[0]
 depends_on = [
  azurerm_resource_group.rg,
  module.vnet
 ]
}
output "vm_public_ip" {
 value = module.linuxservers.public_ip_address
}