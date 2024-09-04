# terraform-aws-mcaf-managed-grafana
Terraform module to create and manage Amazon Managed Grafana

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_execution_role"></a> [execution\_role](#module\_execution\_role) | github.com/schubergphilis/terraform-aws-mcaf-role | v0.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_grafana_role_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_role_association) | resource |
| [aws_grafana_workspace.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace) | resource |
| [aws_grafana_workspace_api_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_api_key) | resource |
| [aws_grafana_workspace_saml_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_saml_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The workspace description | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The Grafana workspace name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources | `map(string)` | n/a | yes |
| <a name="input_account_access_type"></a> [account\_access\_type](#input\_account\_access\_type) | The type of account access for the workspace. Valid values are `CURRENT_ACCOUNT` and `ORGANIZATION`. If ORGANIZATION is specified, then organizational\_units must also be present | `string` | `"CURRENT_ACCOUNT"` | no |
| <a name="input_authentication_providers"></a> [authentication\_providers](#input\_authentication\_providers) | The authentication providers for the workspace. Valid values are `AWS_SSO`, `SAML`, or both | `list(string)` | <pre>[<br>  "AWS_SSO"<br>]</pre> | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | The configuration string for the workspace that you create | `string` | `null` | no |
| <a name="input_data_sources"></a> [data\_sources](#input\_data\_sources) | The data sources for the workspace. Valid values are `AMAZON_OPENSEARCH_SERVICE`, `ATHENA`, `CLOUDWATCH`, `PROMETHEUS`, `REDSHIFT`, `SITEWISE`, `TIMESTREAM`, `XRAY` | `list(string)` | `[]` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | Specifies the version of Grafana to support in the new workspace. If not specified, the default version for the `aws_grafana_workspace` resource will be used. See `aws_grafana_workspace` documentation for available options. | `string` | `"10"` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | The optional arn of the IAM role to use for grafana workspace | `string` | `null` | no |
| <a name="input_network_access_control"></a> [network\_access\_control](#input\_network\_access\_control) | Configuration for network access to your workspace | <pre>object({<br>    prefix_list_ids = list(string)<br>    vpce_ids        = list(string)<br>  })</pre> | `null` | no |
| <a name="input_notification_destinations"></a> [notification\_destinations](#input\_notification\_destinations) | The notification destinations. If a data source is specified here, Amazon Managed Grafana will create IAM roles and permissions needed to use these destinations. Must be set to `SNS` | `list(string)` | <pre>[<br>  "SNS"<br>]</pre> | no |
| <a name="input_organization_role_name"></a> [organization\_role\_name](#input\_organization\_role\_name) | The role name that the workspace uses to access resources through Amazon Organizations | `string` | `null` | no |
| <a name="input_organizational_units"></a> [organizational\_units](#input\_organizational\_units) | The Amazon Organizations organizational units that the workspace is authorized to use data sources from | `list(string)` | `[]` | no |
| <a name="input_permission_type"></a> [permission\_type](#input\_permission\_type) | The permission type of the workspace. If `SERVICE_MANAGED` is specified, the IAM roles and IAM policy attachments are generated automatically. If `CUSTOMER_MANAGED` is specified, the IAM roles and IAM policy attachments will not be created | `string` | `"CUSTOMER_MANAGED"` | no |
| <a name="input_role_association"></a> [role\_association](#input\_role\_association) | List of user/group IDs to assocaite to a role | <pre>list(object({<br>    group_ids = optional(list(string))<br>    role      = string<br>    user_ids  = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_saml_configuration"></a> [saml\_configuration](#input\_saml\_configuration) | The SAML configuration for the workspace | <pre>object({<br>    admin_role_values       = optional(list(string))<br>    allowed_organizations   = optional(list(string))<br>    editor_role_values      = list(string)<br>    email_assertion         = optional(string)<br>    groups_assertion        = optional(string)<br>    idp_metadata_url        = optional(string)<br>    idp_metadata_xml        = optional(string)<br>    login_assertion         = optional(string)<br>    login_validity_duration = optional(number)<br>    name_assertion          = optional(string)<br>    org_assertion           = optional(string)<br>    role_assertion          = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_vpc_configuration"></a> [vpc\_configuration](#input\_vpc\_configuration) | The configuration settings for an Amazon VPC that contains data sources for your Grafana workspace to connect to | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |
| <a name="input_workspace_api_key"></a> [workspace\_api\_key](#input\_workspace\_api\_key) | List of workspace API Key resources to create | <pre>list(object({<br>    name            = string<br>    role            = string<br>    seconds_to_live = number<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace"></a> [workspace](#output\_workspace) | The Grafana workspace details |
| <a name="output_workspace_api_keys"></a> [workspace\_api\_keys](#output\_workspace\_api\_keys) | The workspace API keys created including their attributes |
| <a name="output_workspace_iam_role"></a> [workspace\_iam\_role](#output\_workspace\_iam\_role) | The IAM role details of the Grafana workspace |
| <a name="output_workspace_saml"></a> [workspace\_saml](#output\_workspace\_saml) | The Grafana workspace saml configuration details |
<!-- END_TF_DOCS -->
