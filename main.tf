terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_test_rg" {
  name     = "tfmainrg"
  location = "eastus"
}

resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test_rg.location
  resource_group_name = azurerm_resource_group.tf_test_rg.name
  
  ip_address_type     = "public"
  dns_name_label      = "joshmurariweatherapp"
  os_type             = "Linux"
  
  container {
    name   = "weatherapi"
    image  = "joshmurari/weatherapi"
    cpu    = "1"
    memory = "1"
    
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

