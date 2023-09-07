data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                     = "kv-${var.NAME}"
  location                 = var.LOCATION
  resource_group_name      = var.RESOURCE_GROUP_NAME
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  access_policy {
    object_id = data.azurerm_client_config.current.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
  }
  network_acls {
    bypass         = "None"
    default_action = "Deny"
    ip_rules = module.common.internal_gateway_ips
    virtual_network_subnet_ids = module.common.buildsubnets
  }
  tags = var.TAGS
}

module "common" {
  source      = "github.com/simployer/terraform-modules-common.git"
  project     = var.PROJECT
  environment = var.ENVIRONMENT
}
