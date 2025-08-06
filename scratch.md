```
resource "aws_cloudwatch_log_resource_policy" "opensearch_logs_policy" {
  policy_name     = "${local.base_prefix}-opensearch-logs-policy"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "es.amazonaws.com"
        }
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Resource = [
          "${aws_cloudwatch_log_group.opensearch_slow_logs.arn}:*",
          "${aws_cloudwatch_log_group.opensearch_app_logs.arn}:*", 
          "${aws_cloudwatch_log_group.opensearch_audit_logs.arn}:*"
        ]
      }
    ]
  })
}```
