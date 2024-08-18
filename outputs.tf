output "plugin_server_url" {
  description = "The URL of the plugin server"
  value       = module.api_gateway.api_endpoint
}