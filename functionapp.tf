data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_storage_account" "sa" {
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group_name
}

data "azurerm_app_service_plan" "existing-plan" {
  count               = var.existing_app_service_plan_name != "" ? 1 : 0
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.existing_app_service_plan_name
}

locals {
  fn_app_settings = {
    for i in var.function_app_settings:
        i.name => i.value
  }
}

resource "azurerm_app_service_plan" "service-plan" {
  count                        = var.existing_app_service_plan_name == "" ? 1 : 0
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = var.location
  name                         = var.new_app_service_plan_name != "" ? var.new_app_service_plan_name : "${var.app_name}-plan"

  kind                         = var.linux_host ? "Linux" : "FunctionApp"

  ## When creating a Linux App Service Plan, the reserved field must be set to true, and when creating a Windows/app App Service Plan the reserved field must be set to false.
  reserved                     = var.linux_host ? true : false

  maximum_elastic_worker_count = var.app_service_plan_maximum_elastic_worker_count == "" ? 0 : var.app_service_plan_maximum_elastic_worker_count

  # Consumption Plan Skus name is "Y1" and Tier is "Dynamic".
  # SKU names available for Dedicated App Service (D1,F1,B1,B2,B3S1,S2,S3,P1,P2,P3,P1V2,P2V2,P3V3,I1,I2,I3), Tiers are (Basic, Standard, Premium, PremiumV2)
  # SKU Names available for Elastic Premium (EP1,EP2,EP3), Tier is "ElasticPremium"

  sku {
    size     = var.consumption_app_service_plan ? "Y1"      : var.app_service_plan_sku_size
    capacity = var.number_of_workers
    tier     = var.consumption_app_service_plan ? "Dynamic" : var.app_service_plan_sku_tier
  }

}

resource "azurerm_function_app" "function_app" {
  depends_on                 = [
    azurerm_app_service_plan.service-plan
  ]
  app_service_plan_id        = var.existing_app_service_plan_name != "" ? data.azurerm_app_service_plan.existing-plan[0].id : azurerm_app_service_plan.service-plan[0].id
  location                   = var.location
  name                       = var.function_app_name == "" ? "${var.app_name}-${var.environment}" : var.function_app_name
  resource_group_name        = data.azurerm_resource_group.rg.name
  os_type                    = var.linux_host ? "Linux" : null
  storage_account_name       = var.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.sa.primary_access_key
  app_settings               = local.fn_app_settings
  client_affinity_enabled    = var.function_client_affinity_enabled == "" ? false : var.function_client_affinity_enabled
  daily_memory_time_quota    = var.function_daily_memory_quota
  client_cert_mode           = var.function_client_cert_mode
  https_only                 = var.function_https_only
  tags                       = var.tags

  site_config {
    always_on                = var.function_site_config_alwaysOn == "" ? false : var.function_site_config_alwaysOn
    cors {
      allowed_origins        = var.function_site_config_cors_allowed_origins  # List
      support_credentials    = var.function_site_config_cors_support_credentials == "" ? false : var.function_site_config_cors_support_credentials
    }
    ftps_state               = var.function_site_config_ftps_state == "" ? null : var.function_site_config_ftps_state
    health_check_path        = var.function_site_config_health_check_path
    http2_enabled            = var.function_site_config_http2_enabled == "" ? false : var.function_site_config_http2_enabled

    dynamic "ip_restriction" {
      for_each = var.function_site_config_ip_restrictions
      content {
        name                      = ip_restriction.value.name
        ip_address                = ip_restriction.value.ip_address != "" && ip_restriction.value.virtual_network_subnet_id == "" ? ip_restriction.value.ip_address : null
        priority                  = ip_restriction.value.priority
        virtual_network_subnet_id = ip_restriction.value.ip_address == "" && ip_restriction.value.virtual_network_subnet_id != "" ? ip_restriction.value.ip_address : null
        action                    = ip_restriction.value.action
      }
    }

    min_tls_version           = var.function_site_config_min_tls_version
    pre_warmed_instance_count = var.function_site_config_pre_warmed_instance_count
    use_32_bit_worker_process = var.function_site_config_use_32_bit_worker_process == "" ? false : var.function_site_config_use_32_bit_worker_process
    websockets_enabled        = var.function_site_config_websockets_enabled == "" ? false :  var.function_site_config_websockets_enabled

  }


}

