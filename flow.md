## Bedrock Flows Policy Template ##
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "InvokeFoundationModels",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream"
      ],
      "Resource": [
        "${bedrock_foundation_model_arn}"
      ]
    },
    {
      "Sid": "InvokeProvisionedModels",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:GetProvisionedModelThroughput"
      ],
      "Resource": [
        "${bedrock_provisioned_model_arn}"
      ]
    },
    {
      "Sid": "InvokeCustomModels",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:GetCustomModel"
      ],
      "Resource": [
        "${bedrock_custom_model_arn}"
      ]
    },
    {
      "Sid": "AccessPromptManagement",
      "Effect": "Allow",
      "Action": [
        "bedrock:GetPrompt"
      ],
      "Resource": [
        "${bedrock_prompt_arn}"
      ]
    },
    {
      "Sid": "QueryKnowledgeBases",
      "Effect": "Allow",
      "Action": [
        "bedrock:Retrieve",
        "bedrock:RetrieveAndGenerate"
      ],
      "Resource": [
        "${bedrock_kb_arn}"
      ]
    },
    {
      "Sid": "InvokeAgents",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeAgent"
      ],
      "Resource": [
        "${bedrock_agent_arn}",
        "${bedrock_agent_alias_arn}"
      ]
    },
    {
      "Sid": "InvokeLambdaFunctions",
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": [
        "${lambda_function_arn}"
      ]
    },
    {
      "Sid": "AccessLexBots",
      "Effect": "Allow",
      "Action": [
        "lex:RecognizeText",
        "lex:RecognizeUtterance",
        "lex:PostContent",
        "lex:PostText"
      ],
      "Resource": [
        "${lex_bot_arn}"
      ]
    },
    {
      "Sid": "ApplyGuardrails",
      "Effect": "Allow",
      "Action": [
        "bedrock:ApplyGuardrail"
      ],
      "Resource": [
        "${bedrock_guardrail_arn}"
      ]
    },
    {
      "Sid": "AccessS3ForFlows",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${workspace_bucket_arn}",
        "${workspace_bucket_arn}/*"
      ]
    },
    {
      "Sid": "KMSAccess",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:CreateGrant"
      ],
      "Resource": "${base_kms_arn}",
      "Condition": {
        "StringEquals": {
          "kms:ViaService": [
            "s3.${aws_region}.amazonaws.com",
            "bedrock.${aws_region}.amazonaws.com"
          ]
        }
      }
    },
    {
      "Sid": "CloudWatchLogs",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${cloudwatch_logs_arn}"
      ]
    }
  ]
}
```
## locals ##
```
# Add these lines to your existing locals block in base/locals.tf

  # Bedrock Flows Role and Policy locals
  bedrock_flows_role_name   = "${local.base_prefix}-bedrock-flows-service-role"
  bedrock_flows_policy_name = "${local.base_prefix}-bedrock-flows-service-policy"
  
  # Bedrock ARN patterns for Flows
  bedrock_foundation_model_arn = format("${local.policy_arn_prefix}::foundation-model/*", "bedrock")
  bedrock_provisioned_model_arn = format("${local.policy_arn_prefix}:provisioned-model/*", "bedrock")
  bedrock_custom_model_arn = format("${local.policy_arn_prefix}:custom-model/*", "bedrock")
  bedrock_prompt_arn = format("${local.policy_arn_prefix}:prompt/*", "bedrock")
  # Reuse existing bedrock ARNs: bedrock_kb_arn, bedrock_agent_arn, bedrock_agent_alias_arn, bedrock_guardrail_arn
  
  # Lex ARN patterns for Flows
  lex_bot_arn = format("${local.policy_arn_prefix}:bot-alias/${local.base_prefix}-*", "lex")
  
  # CloudWatch Logs for Flows
  bedrock_flows_logs_arn = format("${local.policy_arn_prefix}:log-group:/aws/bedrock/flows/${local.base_prefix}-*", "logs")

  # Bedrock Flows Policy
  bedrock_flows_policy = templatefile("${path.module}/policies/bedrock_flows/bedrock_flows.tpl", {
    bedrock_foundation_model_arn = local.bedrock_foundation_model_arn
    bedrock_provisioned_model_arn = local.bedrock_provisioned_model_arn
    bedrock_custom_model_arn = local.bedrock_custom_model_arn
    bedrock_prompt_arn = local.bedrock_prompt_arn
    bedrock_kb_arn = local.bedrock_kb_arn
    bedrock_agent_arn = local.bedrock_agent_arn
    bedrock_agent_alias_arn = local.bedrock_agent_alias_arn
    bedrock_guardrail_arn = local.bedrock_guardrail_arn
    lambda_function_arn = local.lambda_resource_arn
    lex_bot_arn = local.lex_bot_arn
    workspace_bucket_arn = module.s3_bucket.workspace_bucket_arn
    base_kms_arn = aws_kms_key.base_kms_key.arn
    aws_region = var.aws_region
    cloudwatch_logs_arn = local.bedrock_flows_logs_arn
  })

```
## role ##
```
# IAM Role for Bedrock Flows
resource "aws_iam_role" "bedrock_flows_service_role" {
  name               = local.bedrock_flows_role_name
  assume_role_policy = data.aws_iam_policy_document.bedrock_flows_assume_role_policy.json

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      service    = "bedrock-flows"
    }
  )
}

# Trust policy for Bedrock Flows service role
data "aws_iam_policy_document" "bedrock_flows_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values   = [
        format("arn:aws:bedrock:%s:%s:flow/*", var.aws_region, data.aws_caller_identity.current.account_id)
      ]
    }
  }
}

# IAM Policy for Bedrock Flows service operations
resource "aws_iam_policy" "bedrock_flows_service_policy" {
  name        = local.bedrock_flows_policy_name
  description = "Policy for Bedrock Flows service role to access AWS resources"
  policy      = local.bedrock_flows_policy

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      service    = "bedrock-flows"
    }
  )
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_bedrock_flows_policy" {
  role       = aws_iam_role.bedrock_flows_service_role.name
  policy_arn = aws_iam_policy.bedrock_flows_service_policy.arn
}

# Output the role ARN for use in other modules
output "bedrock_flows_service_role_arn" {
  value       = aws_iam_role.bedrock_flows_service_role.arn
  description = "ARN of the Bedrock Flows service role"
}

# Store the role ARN in Parameter Store for service discovery
resource "aws_ssm_parameter" "bedrock_flows_role_arn" {
  name  = "/params/${local.base_prefix}/platform/bedrock-flows-role-arn"
  type  = "String"
  value = aws_iam_role.bedrock_flows_service_role.arn

  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
      service    = "bedrock-flows"
    }
  )
}
```

## data.tf ##
```
# Add this to your existing base/data.tf file

data "aws_iam_policy_document" "bedrock_flows_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values   = [
        format("arn:aws:bedrock:%s:%s:flow/*", data.aws_region.current.name, data.aws_caller_identity.current.account_id)
      ]
    }
  }
}
```


