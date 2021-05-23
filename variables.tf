variable "resource_group_name" {
  type = string
  description = "The name of the resource group in which to create the Function App."
}

variable "environment" {
  type = string
  description = "Environment for which the resource is being created e.g dev, uat, prod"
}

variable"app_name" {
  type = string
  default = ""
}

variable "storage_account_name" {
  type = string
  description = " Required - The backend storage account name which will be used by this Function App (such as the dashboard, logs)."
}

variable "storage_account_resource_group_name" {
  type = string
  description = "Name of the resource group where storage account is present"
}

variable "existing_app_service_plan_name" {
  type = string
  description = "Name of the existing plan"
}

variable "location" {
  type = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created"
}

variable "new_app_service_plan_name" {
  type = string
  description = "New app service plan name, if you do not want to use an existing app service plan"
  default = ""
}

variable "linux_host" {
  type = bool
  description = "If linux host needs to be used, set to true"
}

variable "function_app_name" {
  type = string
  description = "(Required) Specifies the name of the Function App. Changing this forces a new resource to be created"
}

variable "consumption_app_service_plan" {
  type = bool
  description = "If consumption plan needs to be used, when creating a new app service plan"
}

##Premium/Dedicated Plan variables
variable "app_service_plan_maximum_elastic_worker_count" {
  type = number
  description = "The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan."
  default = null
}

variable "app_service_plan_sku_size" {
  type = string
  description = "Specifies the plan's instance size"
}

variable "app_service_plan_sku_tier" {
  type = string
  description = "Specifies the plan's pricing tier"
}

variable "number_of_workers" {
  type = number
  description = "Specifies the number of workers associated with this App Service Plan."
}

variable "tags" {
  type = map(string)
  description = "Tags for the resources getting created"
  default = {}
}

## Azure function Variables
variable "function_app_settings" {
  type        = list(object({
    name  = string
    value = string
  }))
  description = "A map of key-value pairs for App Settings and custom values."
  default     = []
}

variable "function_client_affinity_enabled" {
  type        = bool
  description = " Should the Function App send session affinity cookies, which route client requests in the same session to the same instance?"
}

variable "function_https_only" {
  type        = bool
  description = "Can the Function App only be accessed via HTTPS? Defaults to false"
  default     = false
}

variable "function_client_cert_mode" {
  type        = string
  description = "The mode of the Function App's client certificates requirement for incoming requests. Possible values are Required and Optional."
}

variable "function_daily_memory_quota" {
  type        = number
  description = " The amount of memory in gigabyte-seconds that your application is allowed to consume per day. Setting this value only affects function apps under the consumption plan."
  default     = 0
}

variable "function_site_config_alwaysOn" {
  type = bool
  description = "Should the Function App be loaded at all times? Defaults to false"
  default = false
}

variable "function_site_config_cors_allowed_origins" {
  type  = list(string)
  description = " A list of origins which should be able to make cross-origin calls"
  default = []
}

variable "function_site_config_cors_support_credentials" {
  type = bool
  description = "Are credentials supported for cors ?"
}

variable "function_site_config_ftps_state" {
  type = string
  description = "State of FTP / FTPS service for this function app. Possible values include: AllAllowed, FtpsOnly and Disabled. Defaults to AllAllowed."
  default = "AllAllowed"
}

variable "function_site_config_health_check_path" {
  type = string
  description = "Path which will be checked for this function app health."
  default = null
}

variable "function_site_config_http2_enabled" {
  type = bool
  description = "Specifies whether or not the http2 protocol should be enabled"
  default = false
}

variable "function_site_config_ip_restrictions" {
  type  = list(object({
    name                      = string
    ip_address                = string
    priority                  = number
    virtual_network_subnet_id = string
    action                    = string
  }))
  description = ""
  /*
  name - (Optional) The name for this IP Restriction.
  priority - (Optional) The priority for this IP Restriction. Restrictions are enforced in priority order. By default, the priority is set to 65000 if not specified.
  action - (Optional) Does this restriction Allow or Deny access for this IP range. Defaults to Allow."
  ip_address - (Optional) The IP Address used for this IP Restriction in CIDR notation.
  virtual_network_subnet_id - (Optional) The Virtual Network Subnet ID used for this IP Restriction.
  Either IP address or subnet ID needs to be passed
  */
  default = [
    {
      name       = ""
      ip_address = ""
      priority   = null
      virtual_network_subnet_id = ""
      action     = ""
    }
  ]
}

variable "function_site_config_min_tls_version" {
  type = string
  description = "The minimum supported TLS version for the function app. Possible values are 1.0, 1.1, and 1.2"
  default = "1.2"
}

variable "function_site_config_pre_warmed_instance_count" {
  type = number
  description = "The number of pre-warmed instances for this function app. Only affects apps on the Premium plan"
  default = null
}

variable "function_site_config_use_32_bit_worker_process" {
  type = bool
  description = "Should the Function App run in 32 bit mode, rather than 64 bit mode?"
  default = false
}

variable "function_site_config_websockets_enabled" {
  type = bool
  description = "Should WebSockets be enabled?"
}







