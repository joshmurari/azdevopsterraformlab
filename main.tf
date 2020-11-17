terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf_rg_blobstore"
    storage_account_name = "tfdevopslabstorage1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

variable "imagebuild" {
  description = "Latest Image Build Number"
}

resource "azurerm_resource_group" "tf_test_rg" {
  name     = "tfmainrg"
  location = "eastus"
}

resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test_rg.location
  resource_group_name = azurerm_resource_group.tf_test_rg.name

  ip_address_type = "public"
  dns_name_label  = "joshmurariweatherapp"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "joshmurari/weatherapi:${var.imagebuild}"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

