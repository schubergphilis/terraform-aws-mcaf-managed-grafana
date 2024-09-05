output "workspace" {
  description = "The Grafana workspace details"
  value       = aws_grafana_workspace.default
}

output "workspace_api_keys" {
  description = "The workspace API keys created including their attributes"
  value       = aws_grafana_workspace_api_key.default
  sensitive   = true
}

output "workspace_iam_role" {
  description = "The IAM role details of the Grafana workspace"
  value       = local.create_iam_role ? module.execution_role[0].arn : var.iam_role_arn
}

output "workspace_id" {
  description = "The ID of the Grafana workspace"
  value       = aws_grafana_workspace.default.id
}

output "workspace_saml" {
  description = "The Grafana workspace saml configuration details"
  value       = try(aws_grafana_workspace_saml_configuration.default, null)
}
