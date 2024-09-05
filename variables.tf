variable "account_access_type" {
  type        = string
  default     = "CURRENT_ACCOUNT"
  description = "The type of account access for the workspace. Valid values are `CURRENT_ACCOUNT` and `ORGANIZATION`. If ORGANIZATION is specified, then organizational_units must also be present"

  validation {
    condition     = contains(["CURRENT_ACCOUNT", "ORGANIZATION"], var.account_access_type)
    error_message = "Valid values are \"CURRENT_ACCOUNT\" or \"ORGANIZATION\"."
  }
}

variable "authentication_providers" {
  type        = list(string)
  default     = ["AWS_SSO"]
  description = "The authentication providers for the workspace. Valid values are `AWS_SSO`, `SAML`, or both"

  validation {
    condition = alltrue([
      for v in var.authentication_providers : contains(["AWS_SSO", "SAML"], v)
    ])
    error_message = "Valid values are \"AWS_SSO\" or \"SAML\" or or both."
  }
}

variable "configuration" {
  type        = string
  default     = null
  description = "The configuration string for the workspace that you create"
}

variable "data_sources" {
  type        = list(string)
  default     = []
  description = "The data sources for the workspace. Valid values are `AMAZON_OPENSEARCH_SERVICE`, `ATHENA`, `CLOUDWATCH`, `PROMETHEUS`, `REDSHIFT`, `SITEWISE`, `TIMESTREAM`, `XRAY`"

  validation {
    condition = alltrue([
      for v in var.data_sources : contains(["AMAZON_OPENSEARCH_SERVICE", "ATHENA", "CLOUDWATCH", "PROMETHEUS", "REDSHIFT", "SITEWISE", "TIMESTREAM", "XRAY"], v)
    ])
    error_message = "Valid values are \"AMAZON_OPENSEARCH_SERVICE\" or \"ATHENA\" or \"CLOUDWATCH\" or \"PROMETHEUS\" or \"REDSHIFT\" or \"SITEWISE\" or \"TIMESTREAM\" or \"XRAY\"."
  }
}

variable "description" {
  type        = string
  description = "The workspace description"
}

variable "grafana_version" {
  type        = string
  default     = "10.4"
  description = "Specifies the version of Grafana to support in the new workspace."

  validation {
    condition     = contains(["8.4", "9.4", "10.4"], var.grafana_version)
    error_message = "Valid values are \"8.4\", \"9.4\" or \"10.4\"."
  }
}

variable "iam_role_arn" {
  type        = string
  default     = null
  description = "The optional arn of the IAM role to use for grafana workspace"
}

variable "name" {
  type        = string
  description = "The Grafana workspace name"
}

variable "network_access_control" {
  type = object({
    prefix_list_ids = list(string)
    vpce_ids        = list(string)
  })
  default     = null
  description = "Configuration for network access to your workspace"
}

variable "notification_destinations" {
  type        = list(string)
  default     = ["SNS"]
  description = "The notification destinations. If a data source is specified here, Amazon Managed Grafana will create IAM roles and permissions needed to use these destinations. Must be set to `SNS`"
}

variable "organization_role_name" {
  type        = string
  default     = null
  description = "The role name that the workspace uses to access resources through Amazon Organizations"
}

variable "organizational_units" {
  type        = list(string)
  default     = []
  description = "The Amazon Organizations organizational units that the workspace is authorized to use data sources from"
}

variable "permission_type" {
  type        = string
  default     = "CUSTOMER_MANAGED"
  description = "The permission type of the workspace. If `SERVICE_MANAGED` is specified, the IAM roles and IAM policy attachments are generated automatically. If `CUSTOMER_MANAGED` is specified, the IAM roles and IAM policy attachments will not be created"

  validation {
    condition     = contains(["CUSTOMER_MANAGED", "SERVICE_MANAGED"], var.permission_type)
    error_message = "Valid values are \"CUSTOMER_MANAGED\" or \"SERVICE_MANAGED\"."
  }
}

variable "role_association" {
  type = list(object({
    group_ids = optional(list(string))
    role      = string
    user_ids  = optional(list(string))
  }))
  default     = []
  description = "List of user/group IDs to assocaite to a role"

  validation {
    condition = alltrue([
      for v in var.role_association : contains(["ADMIN", "EDITOR", "VIEWER"], v.role)
    ])
    error_message = "Valid values are \"ADMIN\" or \"EDITOR\" or \"VIEWER\"."
  }
}

variable "saml_configuration" {
  type = object({
    admin_role_values       = optional(list(string))
    allowed_organizations   = optional(list(string))
    editor_role_values      = list(string)
    email_assertion         = optional(string)
    groups_assertion        = optional(string)
    idp_metadata_url        = optional(string)
    idp_metadata_xml        = optional(string)
    login_assertion         = optional(string)
    login_validity_duration = optional(number)
    name_assertion          = optional(string)
    org_assertion           = optional(string)
    role_assertion          = optional(string)
  })
  default     = null
  description = "The SAML configuration for the workspace"

  validation {
    condition     = (contains(["SAML"], var.authentication_providers) && var.saml_configuration != null) || (!contains(["SAML"], var.authentication_providers) && var.saml_configuration == null)
    error_message = "If SAML is specified in authentication_providers, then saml_configuration must be configured"
  }
}

variable "vpc_configuration" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default     = null
  description = "The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to"
}

variable "workspace_api_key" {
  type = list(object({
    name            = string
    role            = string
    seconds_to_live = number
  }))
  default     = []
  description = "List of workspace API Key resources to create"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resources"
}
