variable "resource_group_name" {
    type = string
    description = "Existing resource group name"
}

variable "app_service_plan_tier" {
  type = string
  description = "The web app service plan tier"
}

variable "app_service_plan_size" {
  type = string
  description = "The web app serivce plan size"
}

variable "app_service_plan_name" {
  type = string
  description = "The web app serivce plan name"
}
/*
variable "tags" {
  type = map
  description = "Tags to identify web app"
}
*/
/*variable "key_vault_name" {
    type = string
    description = "Name of an existing Key Vault under which to add settings from the web app"
}

variable "key_vault_staging_name" {
    type = string
    description = "Name of an existing Key Vault under which to add settings from the staging web app"
    default = "kv-name"
}*/

variable "app_insights_name" {
  type = string
  description = "Name of the app service"
}

variable "websiteurl" {
  type = string
  description = "Website Url"
}

variable "app_service_name" {
  type = string
  description = "App service name"
}

variable "app_dotnet_version" {
  type = string
  description = "Set the version of dotnet core"
  default = "v2.0"
}

/*variable "key_vault_sslcert_certificate_name" {
  type = string
  description = "Name of the certificate holding the SSL Cert within the key vault"
}

variable "key_vault_sslcert_name" {
  type = string
  description = "Key vault resource name that is holding the SSL Cert"
}

variable "key_vault_sslcert_resource_group" {
  type = string
  description = "Key vault resource group that is holding the SSL Cert key vault"
}*/

variable "client_affinity_enabled" {
  type = bool
  description = "Improve performance of your stateless app by turning Affinity Cookie off, stateful apps should keep this setting on for compatibility"
}

variable "create_app_insights" {
    type = bool
    description = "Set to true to create a dental site"
    default = true
}

/*variable "app_service_certificate_name" {
    type = string
    description = "Set app service cert"
    default  = "PopIfCertNeeded"
}*/

variable "create_app_service_plan" {
    type = bool
    description = "Set to true to create a service plan"
    default = true
}

variable "create_ssl_cert" {
    type = bool
    description = "Set to true to create ssl cert in hosting environment profile"
    default = true
}

variable "create_custom_domain" {
    type = bool
    description = "Set up the custom doamin for the web app"
    default = true
}

variable "create_staging_key_vault_secrects" {
    type = bool
    description = "Do we have a staging key vault secrect to create"
    default = true
}