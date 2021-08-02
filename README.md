# web-app
##Purpose
This module is to manage an Azure web app

## Usage
Use this module to manage an Azure web app as part of a larger composition
### Examples

#### Simple Web App module usage
```
module "webapp-module" {
    source                                  = "./web-app"
    app_service_name                        = "as-appname-environmentname"
    resource_group_name                     = "rg"
    app_service_plan_tier                   = "Standard"
    app_service_plan_size                   = "S1"
    app_service_plan_name                   = module.naming.app_service_plan.name_unique
    tags                                    = var.tags
    key_vault_name                          = "kv-appname-environment"
    key_vault_staging_name                  = "kv-appname-stage-environment"
    app_insights_name                       = module.naming.application_insights.name_unique
    websiteurl                              = "websiteUrl"
    openidconnectauthority                  = var.openidconnectauthority
    openidconnectclientid                   = var.openidconnectclientid
    key_vault_sslcert_certificate_name      = var.key_vault_sslcert_certificate_name
    key_vault_sslcert_name                  = var.key_vault_sslcert_name
    key_vault_sslcert_resource_group        = var.key_vault_sslcert_resource_group
    client_affinity_enabled                 = false
    app_service_certificate_name            = var.app_service_certificate_name
}

## External Dependencies
1. An Azure Resource Group
2. An Azure Key Vault for the prod slot settings
3. An Azure Key Vault for the staging slot settings
4. A reference to the key vault holding the SSL cert