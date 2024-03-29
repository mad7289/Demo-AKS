

resource "azurerm_resource_group" "aks_rg" {
  name     = "test-aks"
  location = "East US"
}

resource "azurerm_container_registry" "acr_test1" {
  name                     = "testacri"
  resource_group_name      = azurerm_resource_group.aks_rg.name
  location                 = azurerm_resource_group.aks_rg.location
  sku                      = "Basic"
  admin_enabled            = false
 
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "test-aks-clusterr"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

 
 
}



resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr_test1.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id



}


