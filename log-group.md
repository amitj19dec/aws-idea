## Template
```
{
  "widgets": [
    {
      "type": "log",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Total Bedrock Invocations (Agents + Flows + KB)",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @timestamp, @message | filter @message like /InvokeModel|InvokeAgent|InvokeFlow|Retrieve|RetrieveAndGenerate/ | stats count() as invocations by bin(1h) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Invocations"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Model Usage Distribution",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @message | filter @message like /modelId/ | parse @message /\"modelId\":\"(?<model>[^\"]+)\"/ | stats count() as usage by model | sort usage desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "pie"
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Input Token Consumption Trend",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @timestamp, @message | filter @message like /inputTokens/ | parse @message /\"inputTokens\":(?<inputTokens>\\d+)/ | stats sum(inputTokens) as total_input_tokens by bin(1h) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Input Tokens"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Output Token Consumption Trend",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @timestamp, @message | filter @message like /outputTokens/ | parse @message /\"outputTokens\":(?<outputTokens>\\d+)/ | stats sum(outputTokens) as total_output_tokens by bin(1h) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Output Tokens"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 12,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Error Patterns Across All Bedrock Services",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | SOURCE '/aws/bedrock/guardrails/${base_prefix}-*' | fields @timestamp, @message, @logStream | filter @message like /ERROR|FAILED|Exception|Throttl|Timeout/ | stats count() as errors by bin(5m) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Error Count"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 12,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Top Error Types",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | SOURCE '/aws/bedrock/guardrails/${base_prefix}-*' | fields @message | filter @message like /ERROR|FAILED|Exception/ | parse @message /(?<error_type>Throttl|Timeout|ValidationException|AccessDeniedException|ResourceNotFoundException|ServiceException|KnowledgeBaseException|GuardrailException)/ | stats count() as occurrences by error_type | sort occurrences desc | limit 10",
        "region": "${aws_region}",
        "view": "table"
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 18,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Token Usage by Model (Cost Proxy)",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @message | filter @message like /modelId/ and @message like /Tokens/ | parse @message /\"modelId\":\"(?<model>[^\"]+)\".*\"inputTokens\":(?<input>\\d+).*\"outputTokens\":(?<output>\\d+)/ | stats sum(input) as total_input, sum(output) as total_output by model",
        "region": "${aws_region}",
        "view": "table"
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 18,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Response Latency Distribution (P50, P90, P99)",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @timestamp, @message | filter @message like /latency|duration/ | parse @message /\"latency\":(?<latency>\\d+)/ | stats pct(latency, 50) as p50, pct(latency, 90) as p90, pct(latency, 99) as p99 by bin(5m) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Latency (ms)"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 24,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Top 10 Most Active Agents",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | fields @logStream, @message | filter @message like /InvokeAgent/ | stats count() as invocations by @logStream as agent | sort invocations desc | limit 10",
        "region": "${aws_region}",
        "view": "table"
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 24,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Top 10 Most Active Flows",
        "query": "SOURCE '/aws/bedrock/flows/${base_prefix}-*' | fields @logStream, @message | filter @message like /InvokeFlow/ | stats count() as invocations by @logStream as flow | sort invocations desc | limit 10",
        "region": "${aws_region}",
        "view": "table"
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 30,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Knowledge Base Retrieval Operations",
        "query": "SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @timestamp, @message | filter @message like /Retrieve|RetrieveAndGenerate/ | parse @message /\"operation\":\"(?<operation>[^\"]+)\".*\"documentsRetrieved\":(?<docs>\\d+)/ | stats count() as retrievals, avg(docs) as avg_docs_retrieved by bin(1h) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Retrievals"
          },
          "right": {
            "label": "Avg Docs Retrieved"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 30,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Knowledge Base Performance Metrics",
        "query": "SOURCE '/aws/bedrock/knowledge-bases/${base_prefix}-*' | fields @message | filter @message like /retrievalLatency|relevanceScore/ | parse @message /\"retrievalLatency\":(?<latency>\\d+).*\"relevanceScore\":(?<score>[0-9.]+)/ | stats avg(latency) as avg_latency, avg(score) as avg_relevance by bin(15m) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Latency (ms)"
          },
          "right": {
            "label": "Relevance Score"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 36,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Guardrail Violations and Applications",
        "query": "SOURCE '/aws/bedrock/guardrails/${base_prefix}-*' | fields @timestamp, @message | filter @message like /guardrail/ | parse @message /\"action\":\"(?<action>[^\"]+)\".*\"violationType\":\"(?<violation>[^\"]+)\"/ | stats count() as total by action, violation | sort total desc",
        "region": "${aws_region}",
        "view": "table"
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 36,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Guardrail Application Trend",
        "query": "SOURCE '/aws/bedrock/guardrails/${base_prefix}-*' | fields @timestamp, @message | filter @message like /ApplyGuardrail/ | parse @message /\"action\":\"(?<action>[^\"]+)\"/ | stats count() as applications by action, bin(1h) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": true,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Guardrail Applications"
          }
        }
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 42,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "User Session Patterns",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | fields @timestamp, @message | filter @message like /userId|sessionId/ | parse @message /\"userId\":\"(?<user>[^\"]+)\".*\"sessionId\":\"(?<session>[^\"]+)\"/ | stats count() as interactions, dc(session) as unique_sessions by user | sort interactions desc | limit 20",
        "region": "${aws_region}",
        "view": "table"
      }
    },
    {
      "type": "log",
      "x": 12,
      "y": 42,
      "width": 12,
      "height": 6,
      "properties": {
        "title": "Active Sessions Over Time",
        "query": "SOURCE '/aws/bedrock/agents/${base_prefix}-*' | SOURCE '/aws/bedrock/flows/${base_prefix}-*' | fields @timestamp, @message | filter @message like /sessionId/ | parse @message /\"sessionId\":\"(?<session>[^\"]+)\"/ | stats dc(session) as active_sessions by bin(1h) as time | sort time desc",
        "region": "${aws_region}",
        "stacked": false,
        "view": "timeSeries",
        "yAxis": {
          "left": {
            "label": "Active Sessions"
          }
        }
      }
    }
  ]
}
```


## Code 
```
# Note: Log groups are NOT pre-created here.
# Bedrock services will create them dynamically when users create agents/flows/knowledge-bases/guardrails
# with names like "${base_prefix}-my-agent", "${base_prefix}-my-flow", etc.
# The IAM policy already grants permission to create log groups with the pattern:
# /aws/bedrock/{service}/${base_prefix}-*
#
# For monitoring dynamically created log groups, consider:
# 1. Using CloudWatch Logs Insights queries in the dashboard (which support wildcards)
# 2. Creating a Lambda function to monitor new log groups and create metric filters
# 3. Using AWS Config or EventBridge to track resource creation and setup monitoring

# CloudWatch Dashboard for Bedrock AI Usage Monitoring
resource "aws_cloudwatch_dashboard" "bedrock_ai_usage" {
  count = var.enable_bedrock_dashboard ? 1 : 0
  
  dashboard_name = "${local.base_prefix}-bedrock-ai-usage"

  dashboard_body = templatefile("${path.module}/dashboards/bedrock_dashboard.tpl", {
    base_prefix = local.base_prefix
    aws_region  = var.aws_region
  })

  tags = merge(
    var.tags,
    {
      provisoner  = local.resource_provisioner
      name        = "${local.base_prefix}-bedrock-ai-usage-dashboard"
      description = "Monitors comprehensive Bedrock AI usage across all services in the project"
    }
  )
}

# CloudWatch Alarms for Bedrock Monitoring
# Note: These alarms use wildcard patterns in dimensions which may not work as expected.
# CloudWatch metrics typically require exact log group names. For production use, consider:
# 1. Creating alarms dynamically when resources are created
# 2. Using CloudWatch Logs metric filters with exact log group names
# 3. Using AWS Lambda to monitor log groups and create custom metrics
resource "aws_cloudwatch_metric_alarm" "bedrock_high_error_rate" {
  count = var.enable_bedrock_dashboard && var.enable_bedrock_alarms ? 1 : 0

  alarm_name          = "${local.base_prefix}-bedrock-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  threshold           = var.bedrock_error_threshold
  alarm_description   = "This metric monitors Bedrock error rate"
  insufficient_data_actions = []

  metric_query {
    id = "e1"
    
    metric {
      metric_name = "Errors"
      namespace   = "AWS/Logs"
      period      = "300"
      stat        = "Sum"

      dimensions = {
        LogGroupName = "/aws/bedrock/agents/${local.base_prefix}-*"
      }
    }
  }

  metric_query {
    id = "e2"
    
    metric {
      metric_name = "Errors"
      namespace   = "AWS/Logs"
      period      = "300"
      stat        = "Sum"

      dimensions = {
        LogGroupName = "/aws/bedrock/flows/${local.base_prefix}-*"
      }
    }
  }

  metric_query {
    id = "error_rate"
    expression = "(e1 + e2) / PERIOD(e1)"
    label      = "Error Rate"
    return_data = "true"
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "bedrock_high_token_usage" {
  count = var.enable_bedrock_dashboard && var.enable_bedrock_alarms ? 1 : 0

  alarm_name          = "${local.base_prefix}-bedrock-high-token-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "TokensUsed"
  namespace           = "AWS/Bedrock"
  period              = "3600" # 1 hour
  statistic           = "Sum"
  threshold           = var.bedrock_token_threshold
  alarm_description   = "This metric monitors high token usage in Bedrock"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ModelId = "all"
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "bedrock_guardrail_violations" {
  count = var.enable_bedrock_dashboard && var.enable_bedrock_alarms ? 1 : 0

  alarm_name          = "${local.base_prefix}-bedrock-guardrail-violations"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = var.bedrock_guardrail_violation_threshold
  alarm_description   = "This metric monitors Bedrock guardrail violations"
  insufficient_data_actions = []

  metric_query {
    id = "violations"
    
    metric {
      metric_name = "GuardrailViolations"
      namespace   = "AWS/Logs"
      period      = "300"
      stat        = "Sum"

      dimensions = {
        LogGroupName = "/aws/bedrock/guardrails/${local.base_prefix}-*"
      }
    }
    
    return_data = "true"
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "bedrock_knowledge_base_low_relevance" {
  count = var.enable_bedrock_dashboard && var.enable_bedrock_alarms ? 1 : 0

  alarm_name          = "${local.base_prefix}-bedrock-kb-low-relevance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  threshold           = var.bedrock_relevance_threshold
  alarm_description   = "This metric monitors low relevance scores in Knowledge Base retrievals"
  treat_missing_data  = "notBreaching"

  metric_query {
    id = "relevance"
    
    metric {
      metric_name = "RelevanceScore"
      namespace   = "AWS/Logs"
      period      = "900" # 15 minutes
      stat        = "Average"

      dimensions = {
        LogGroupName = "/aws/bedrock/knowledge-bases/${local.base_prefix}-*"
      }
    }
    
    return_data = "true"
  }

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}

# Variables for dashboard configuration
variable "enable_bedrock_dashboard" {
  description = "Enable Bedrock AI usage monitoring dashboard"
  type        = bool
  default     = true
}

variable "enable_bedrock_alarms" {
  description = "Enable CloudWatch alarms for Bedrock monitoring (Note: requires exact log group names)"
  type        = bool
  default     = false
}

variable "bedrock_error_threshold" {
  description = "Threshold for Bedrock error rate alarm (errors per 5 minutes)"
  type        = number
  default     = 10
}

variable "bedrock_token_threshold" {
  description = "Threshold for high token usage alarm (tokens per hour)"
  type        = number
  default     = 100000
}

variable "bedrock_guardrail_violation_threshold" {
  description = "Threshold for guardrail violations alarm (violations per 5 minutes)"
  type        = number
  default     = 5
}

variable "bedrock_relevance_threshold" {
  description = "Minimum relevance score threshold for Knowledge Base retrievals"
  type        = number
  default     = 0.7
}
```
