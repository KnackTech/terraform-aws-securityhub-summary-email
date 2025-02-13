
#    _____ _   _  _____
#   / ____| \ | |/ ____|
#  | (___ |  \| | (___
#   \___ \| . ` |\___ \
#   ____) | |\  |____) |
#  |_____/|_| \_|_____/

resource "aws_sns_topic" "this" {
  count = var.sns_topic_arn == null ? 1 : 0

  name              = var.name
  display_name      = replace(var.name, ".", "-") # dots are illegal in display names and for .fifo topics required as part of the name (AWS SNS by design)
  kms_master_key_id = var.kms_key_id
  # delivery_policy             = var.delivery_policy
  # fifo_topic                  = var.fifo_topic
  # content_based_deduplication = var.content_based_deduplication

  tags = var.tags
}

resource "aws_sns_topic_subscription" "this" {
  count = (var.sns_topic_arn == null) && (var.email != null) ? 1 : 0

  topic_arn = aws_sns_topic.this[0].arn
  protocol  = "email"
  endpoint  = var.email
}

#   _____           _       _     _
#  |_   _|         (_)     | |   | |
#    | |  _ __  ___ _  __ _| |__ | |_ ___
#    | | | '_ \/ __| |/ _` | '_ \| __/ __|
#   _| |_| | | \__ \ | (_| | | | | |_\__ \
#  |_____|_| |_|___/_|\__, |_| |_|\__|___/
#                      __/ |
#                     |___/

resource "aws_securityhub_insight" "aws_best_prac_by_status" {
  name = "Summary Email - AWS Foundational Security Best practices findings by compliance status"

  group_by_attribute = "ComplianceStatus"

  filters {
    type {
      comparison = "EQUALS"
      value      = "Software and Configuration Checks/Industry and Regulatory Standards/AWS-Foundational-Security-Best-Practices"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "aws_best_prac_by_severity" {
  name = "Summary Email - Failed AWS Foundational Security Best practices findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    type {
      comparison = "EQUALS"
      value      = "Software and Configuration Checks/Industry and Regulatory Standards/AWS-Foundational-Security-Best-Practices"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    compliance_status {
      comparison = "EQUALS"
      value      = "FAILED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "cis_by_status" {
  name = "Summary Email - CIS Benchmark findings by compliance status"

  group_by_attribute = "ComplianceStatus"

  filters {
    type {
      comparison = "EQUALS"
      value      = "Software and Configuration Checks/Industry and Regulatory Standards/CIS AWS Foundations Benchmark"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "cis_by_severity" {
  name = "Summary Email - Failed CIS Benchmark findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    type {
      comparison = "EQUALS"
      value      = "Software and Configuration Checks/Industry and Regulatory Standards/CIS AWS Foundations Benchmark"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    compliance_status {
      comparison = "EQUALS"
      value      = "FAILED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "health_by_severity" {
  name = "Summary Email - Count of Health findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Health"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "guardduty_by_severity" {
  name = "Summary Email - Count of Amazon GuardDuty findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "GuardDuty"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "RESOLVED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "macie_by_severity" {
  name = "Summary Email - Count of Macie findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Macie"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}
resource "aws_securityhub_insight" "iam_by_severity" {
  name = "Summary Email - Count of IAM Access Analyzer findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "IAM Access Analyzer"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "ta_by_severity" {
  name = "Summary Email - Count of Trusted Advisor findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Trusted Advisor"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "inspector_by_severity" {
  name = "Summary Email - Count of Inspector findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Inspector"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "ssmpm_by_severity" {
  name = "Summary Email - Count of Systems Manager Patch Manager findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Systems Manager Patch Manager"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "ssmops_by_severity" {
  name = "Summary Email - Count of Systems Manager OpsCenter and Explorer findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Systems Manager OpsCenter and Explorer"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "fwman_by_severity" {
  name = "Summary Email - Count of Firewall Manager findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Firewall Manager"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "auditman_by_severity" {
  name = "Summary Email - Count of Audit Manager findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Audit Manager"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "detective_by_severity" {
  name = "Summary Email - Count of Detective findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Detective"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "chatbot_by_severity" {
  name = "Summary Email - Count of Chatbot findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    product_name {
      comparison = "EQUALS"
      value      = "Chatbot"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "all_by_severity" {
  name = "Summary Email - Count of all unresolved findings by severity"

  group_by_attribute = "SeverityLabel"

  filters {
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "RESOLVED"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "new_findings" {
  name = "Summary Email - new findings in the last 7 days"

  group_by_attribute = "ProductName"

  filters {
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "RESOLVED"
    }
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    created_at {
      date_range {
        unit  = "DAYS"
        value = "7"
      }
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

resource "aws_securityhub_insight" "top_resource_types" {
  name = "Summary Email - Top Resource Types with findings by count"

  group_by_attribute = "ResourceType"

  filters {
    workflow_status {
      comparison = "NOT_EQUALS"
      value      = "SUPPRESSED"
    }
    record_state {
      comparison = "EQUALS"
      value      = "ACTIVE"
    }
  }
}

locals {
  insight_map = {
    "aws_best_practices_by_status"              = aws_securityhub_insight.aws_best_prac_by_status.arn
    "aws_best_practices_by_severity"            = aws_securityhub_insight.aws_best_prac_by_severity.arn
    "cis_by_status"                             = aws_securityhub_insight.cis_by_status.arn
    "cis_by_severity"                           = aws_securityhub_insight.cis_by_severity.arn
    "health_by_severity"                        = aws_securityhub_insight.health_by_severity.arn
    "guardduty_by_severity"                     = aws_securityhub_insight.guardduty_by_severity.arn
    "macie_by_severity"                         = aws_securityhub_insight.macie_by_severity.arn
    "iam_by_severity"                           = aws_securityhub_insight.iam_by_severity.arn
    "ta_by_severity"                            = aws_securityhub_insight.ta_by_severity.arn
    "inspector_by_severity"                     = aws_securityhub_insight.inspector_by_severity.arn
    "ssmpm_by_severity"                         = aws_securityhub_insight.ssmpm_by_severity.arn
    "ssmops_by_severity"                        = aws_securityhub_insight.ssmops_by_severity.arn
    "fwman_by_severity"                         = aws_securityhub_insight.fwman_by_severity.arn
    "auditman_by_severity"                      = aws_securityhub_insight.auditman_by_severity.arn
    "detective_by_severity"                     = aws_securityhub_insight.detective_by_severity.arn
    "chatbot_by_severity"                       = aws_securityhub_insight.chatbot_by_severity.arn
    "all_findings_by_severity"                  = aws_securityhub_insight.all_by_severity.arn
    "new_findings"                              = aws_securityhub_insight.new_findings.arn
    "top_resource_types_with_findings_by_count" = aws_securityhub_insight.top_resource_types.arn
  }

  insight_list = [
    for i in var.insights : [i, local.insight_map[i]]
  ]
}

#   _                     _         _
#  | |                   | |       | |
#  | |     __ _ _ __ ___ | |__   __| | __ _
#  | |    / _` | '_ ` _ \| '_ \ / _` |/ _` |
#  | |___| (_| | | | | | | |_) | (_| | (_| |
#  |______\__,_|_| |_| |_|_.__/ \__,_|\__,_|

resource "aws_iam_role" "iam_for_lambda" {
  name = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  inline_policy {
    name = "SecurityHubSendEmailToSNS"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["sns:Publish"]
          Effect   = "Allow"
          Resource = var.sns_topic_arn != null ? var.sns_topic_arn : aws_sns_topic.this[0].arn
        },
      ]
    })
  }

  managed_policy_arns = [
    "arn:${data.aws_partition.this.partition}:iam::aws:policy/AWSSecurityHubReadOnlyAccess",
    "arn:${data.aws_partition.this.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

data "archive_file" "code" {
  type        = "zip"
  source_file = "${path.module}/sec-hub-email.py"
  output_path = "${path.module}/sec-hub-email.zip"
}

resource "aws_lambda_function" "sechub_summariser" {
  filename         = data.archive_file.code.output_path
  function_name    = var.name
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "sec-hub-email.lambda_handler"
  source_code_hash = data.archive_file.code.output_base64sha256

  runtime = "python3.11"
  timeout = 30

  environment {
    variables = {
      Insights                  = jsonencode(local.insight_list)
      SNSTopic                  = var.sns_topic_arn != null ? var.sns_topic_arn : aws_sns_topic.this[0].arn
      AdditionalEmailHeaderText = var.additional_email_header_text
      AdditionalEmailFooterText = var.additional_email_footer_text
    }
  }
}

resource "aws_lambda_permission" "trigger" {
  statement_id  = "AllowExecutionFromEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sechub_summariser.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger.arn
}

#   _______   _                         ______               _
#  |__   __| (_)                       |  ____|             | |
#     | |_ __ _  __ _  __ _  ___ _ __  | |____   _____ _ __ | |_
#     | | '__| |/ _` |/ _` |/ _ \ '__| |  __\ \ / / _ \ '_ \| __|
#     | | |  | | (_| | (_| |  __/ |    | |___\ V /  __/ | | | |_
#     |_|_|  |_|\__, |\__, |\___|_|    |______\_/ \___|_| |_|\__|
#                __/ | __/ |
#               |___/ |___/

resource "aws_cloudwatch_event_rule" "trigger" {
  name        = "security_hub_summary_email_schedule"
  description = "Triggers the Recurring Security Hub summary email"

  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.trigger.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.sechub_summariser.arn
}
