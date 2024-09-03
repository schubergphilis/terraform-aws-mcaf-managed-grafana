locals {
  create_iam_role = var.iam_role_arn == null && var.permission_type == "CUSTOMER_MANAGED" ? true : false

  data_source_iam_policies = {
    ATHENA     = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaAthenaAccess"
    CLOUDWATCH = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaCloudWatchAccess"
    REDSHIFT   = "arn:aws:iam::aws:policy/service-role/AmazonGrafanaRedshiftAccess"
    SITEWISE   = "arn:aws:iam::aws:policy/service-role/AWSIoTSiteWiseReadOnlyAccess"
    TIMESTREAM = "arn:aws:iam::aws:policy/AmazonTimestreamReadOnlyAccess"
    XRAY       = "arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"
  }
}

data "aws_iam_policy_document" "default" {
  count = local.create_iam_role ? 1 : 0

  dynamic "statement" {
    for_each = contains(var.data_sources, "AMAZON_OPENSEARCH_SERVICE") ? { create : true } : {}

    content {
      actions = [
        "es:ESHttpGet",
        "es:DescribeElasticsearchDomains",
        "es:ListDomainNames",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = contains(var.data_sources, "AMAZON_OPENSEARCH_SERVICE") ? { create : true } : {}

    content {
      actions = ["es:ESHttpGet"]
      resources = [
        "arn:aws:es:*:*:domain/*/_msearch*",
        "arn:aws:es:*:*:domain/*/_opendistro/_ppl",
      ]
    }
  }

  dynamic "statement" {
    for_each = contains(var.data_sources, "PROMETHEUS") ? { create : true } : {}

    content {
      actions = [
        "aps:ListWorkspaces",
        "aps:DescribeWorkspace",
        "aps:QueryMetrics",
        "aps:GetLabels",
        "aps:GetSeries",
        "aps:GetMetricMetadata",
      ]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = contains(var.notification_destinations, "SNS") ? { create : true } : {}

    content {
      actions   = ["sns:Publish"]
      resources = ["arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:grafana*"]
    }
  }
}

module "execution_role" {
  count = local.create_iam_role ? 1 : 0

  source                = "github.com/schubergphilis/terraform-aws-mcaf-role?ref=v0.4.0"
  name                  = "GrafanaExecution-${var.name}"
  create_policy         = true
  policy_arns           = [for i, v in var.data_sources : local.data_source_iam_policies[v]]
  principal_type        = "Service"
  principal_identifiers = ["grafana.amazonaws.com"]
  role_policy           = data.aws_iam_policy_document.default[0].json
  tags                  = var.tags
}
