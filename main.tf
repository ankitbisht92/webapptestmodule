terraform {
  required_providers {
      azurerm = {
          source = "hashicorp/azurerm"
          version = ">=2.44.0"
      }
  }
}

#To get the current session details
data "azurerm_client_config" "current" {}

#Creates a data reference for the target resource group
data "azurerm_resource_group" "resource_group" {
    name = var.resource_group_name
}

/*data "azurerm_key_vault" "key_store" {
    name                = var.key_vault_name
    resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "key_store_staging" {
    count = var.create_staging_key_vault_secrects ? 1 : 0

    name                = var.key_vault_staging_name
    resource_group_name = var.resource_group_name
}*/

# -------------------------------------------------------------
# Create or get service plan
resource "azurerm_app_service_plan" "appsvcplan" {
  count = var.create_app_service_plan ? 1 : 0
  name                = var.app_service_plan_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  #tags                = var.tags

  sku {
    tier = var.app_service_plan_tier
    size = var.app_service_plan_size
  }

  depends_on = [data.azurerm_resource_group.resource_group]
}

data "azurerm_app_service_plan" "app_service_plan" {
  count = var.create_app_service_plan ? 0 : 1

  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
}


# ------------------------------------------

# Create app insights
resource "azurerm_application_insights" "appinsights" {
  count = var.create_app_insights ? 1 : 0

  name                = var.app_insights_name
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  application_type    = "web"
  #tags                = var.tags
}

# Create app service web app
resource "azurerm_app_service" "appsvc" {
  name                    = var.app_service_name /* TODO add a random part to this name */
  location                = data.azurerm_resource_group.resource_group.location
  resource_group_name     = data.azurerm_resource_group.resource_group.name
  app_service_plan_id     = var.create_app_service_plan ? azurerm_app_service_plan.appsvcplan[0].id : data.azurerm_app_service_plan.app_service_plan[0].id
  https_only              = true
  client_affinity_enabled = var.client_affinity_enabled
  #tags                    = var.tags
  
  site_config {
    dotnet_framework_version  = var.app_dotnet_version
    use_32_bit_worker_process = true
    always_on                 = true

    default_documents         = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "default.aspx"]
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_app_service_plan.appsvcplan]
}

/*
# Get the key vault with the SSL cert
data "azurerm_key_vault" "kv_sslcert" {
  name                = var.key_vault_sslcert_name
  resource_group_name = var.key_vault_sslcert_resource_group
}

# Get the cert from the key vault
data "azurerm_key_vault_certificate" "key_vault_cert" {
  name         = var.key_vault_sslcert_certificate_name
  key_vault_id = data.azurerm_key_vault.kv_sslcert.id
}

# Add custom Url
resource "azurerm_app_service_custom_hostname_binding" "appsvc_bindings" {
  count = var.create_custom_domain ? 1 : 0

  hostname            = var.websiteurl
  thumbprint          = data.azurerm_key_vault_certificate.key_vault_cert.thumbprint
  ssl_state           = "SniEnabled"
  app_service_name    = azurerm_app_service.appsvc.name
  resource_group_name = data.azurerm_resource_group.resource_group.name

  depends_on          = [azurerm_app_service.appsvc, data.azurerm_key_vault_certificate.key_vault_cert, azurerm_app_service_certificate.appsvc_certificate]
}

# Link the SSL cert to the bindings
resource "azurerm_app_service_certificate" "appsvc_certificate" {
  count = var.create_ssl_cert ? 1 : 0
  
  name                            = var.app_service_certificate_name
  resource_group_name             = data.azurerm_resource_group.resource_group.name
  location                        = data.azurerm_resource_group.resource_group.location
  hosting_environment_profile_id  = azurerm_app_service.appsvc.id
  key_vault_secret_id             = data.azurerm_key_vault_certificate.key_vault_cert.id

  depends_on                      = [azurerm_app_service.appsvc, data.azurerm_key_vault_certificate.key_vault_cert]
}*/

# add staging slot
resource "azurerm_app_service_slot" "appsvcslot" {
  name                    = "Staging"
  app_service_name        = azurerm_app_service.appsvc.name
  location                = data.azurerm_resource_group.resource_group.location
  resource_group_name     = data.azurerm_resource_group.resource_group.name
  app_service_plan_id     = var.create_app_service_plan ? azurerm_app_service_plan.appsvcplan[0].id : data.azurerm_app_service_plan.app_service_plan[0].id
  https_only              = true
  client_affinity_enabled = var.client_affinity_enabled
  #tags                    = var.tags

  site_config {
    dotnet_framework_version  = var.app_dotnet_version
    use_32_bit_worker_process = true
    always_on                 = true

    default_documents         = ["Default.htm", "Default.html", "Default.asp", "index.htm", "index.html", "default.aspx"]
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_app_service.appsvc]
}
/*
# Add custom Url
resource "azurerm_app_service_custom_hostname_binding" "appsvcslot_bindings" {
  hostname            = format("staging.%s", var.websiteurl)
  thumbprint          = data.azurerm_key_vault_certificate.key_vault_cert.thumbprint
  ssl_state           = "SniEnabled"
  app_service_name    = azurerm_app_service_slot.appsvcslot.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}


# Add key vault secrets for web app
resource "azurerm_key_vault_secret" "application-insights-key" {
  count = var.create_app_insights ? 1 : 0

  name          = "ApplicationInsights--InstrumentationKey"
  value         = azurerm_application_insights.appinsights[0].instrumentation_key
  key_vault_id  = data.azurerm_key_vault.key_store.id
  #tags          = var.tags

  depends_on    = [azurerm_application_insights.appinsights]
}

# Give web app prod access
resource "azurerm_key_vault_access_policy" "key_vault_access_prod" {
  key_vault_id  = data.azurerm_key_vault.key_store.id
  tenant_id     = data.azurerm_client_config.current.tenant_id
  object_id     = azurerm_app_service.appsvc.identity[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]

  depends_on = [azurerm_app_service.appsvc]
}

# Add key vault secrets for staging web app
# Give staging slot access
resource "azurerm_key_vault_access_policy" "key_vault_access_staging" {
  count = var.create_staging_key_vault_secrects ? 1 : 0

  key_vault_id = data.azurerm_key_vault.key_store_staging[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service_slot.appsvcslot.identity[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]

  depends_on = [azurerm_app_service_slot.appsvcslot]
}

resource "azurerm_key_vault_secret" "application-insights-key-staging" {
  count = var.create_app_insights && var.create_staging_key_vault_secrects ? 1 : 0

  name          = "ApplicationInsights--InstrumentationKey"
  value         = azurerm_application_insights.appinsights[0].instrumentation_key
  key_vault_id  = data.azurerm_key_vault.key_store_staging[0].id
  #tags          = var.tags

  depends_on    = [azurerm_application_insights.appinsights]
}