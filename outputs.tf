# Set out the output variables
output "WebAppName" {
  value = azurerm_app_service.appsvc.name
  description = "The web app name"
}

output "WebAppSlotName" {
  value = azurerm_app_service_slot.appsvcslot.name
  description = "The web app slot name"
}

output "WebAppAppInsightsName" {
  value = var.create_app_insights ? azurerm_application_insights.appinsights[0].name : ""
  description = "The app insights name"
}

output "WebAppAppInsightsKey" {
  value = var.create_app_insights ? azurerm_application_insights.appinsights[0].instrumentation_key : ""
  description = "The app insights instrumentation key"
}

output "WebappAppInsightsConnectionString" {
  value = var.create_app_insights ? azurerm_application_insights.appinsights[0].connection_string : ""
  description = "The app insights connection string"
}

output "WebAppUrl" {
  value = format("https://%s/signin-oidc", azurerm_app_service.appsvc.default_site_hostname)
  description = "The web apps sign in url"
}

output "WebAppSlotUrl" {
  value = format("https://%s/signin-oidc", azurerm_app_service_slot.appsvcslot.default_site_hostname)
  description = "The web apps slot sign in url"
}