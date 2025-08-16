Perfect! Let's update your Terraform code step by step to implement this clean approach where AWS auto-creates log groups.

## 📋 Step-by-Step Terraform Updates

### **Step 1: Review What to Keep** ✅

Looking at your current code, these log groups should STAY:

1. **OpenSearch log groups** in `managed-opensearch/main.tf` - ✅ Keep (platform-managed)
2. **Lex conversation log group** in `base/main.tf` - ✅ Keep (optional, for conversation logging)

### **Step 2: Update Lambda IAM Policy** 🔧

**File:** `base/policies/lambda/base.json.tpl`

**Current:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    ...
  ]
}
```

**Update to:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLogGroupCreation",
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/${base_prefix}-*"
    },
    {
      "Sid": "AllowLogStreamOperations",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/${base_prefix}-*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
```

### **Step 3: Update Lambda Secret Policy Template** 🔧

**File:** `base/policies/lambda/secret.json.tpl`

**Update the template file reference in** `base/locals.tf`:

```hcl
lambda_policy_base = templatefile("${local.policy_lambda_template_path}/base.json.tpl", {
  base_prefix = local.base_prefix  # Add this parameter
})
```

### **Step 4: Update Glue IAM Policy** 🔧

**File:** `base/policies/glue/glue.tpl`

**Current has:**
```json
{
  "Sid": "AllowCloudWatchLogsForGlueJob",
  "Effect": "Allow",
  "Action": [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents"
  ],
  "Resource": [
    "${glue_log_group_arn}"
  ]
}
```

**Update to:**
```json
{
  "Sid": "AllowCloudWatchLogsForGlueJob",
  "Effect": "Allow",
  "Action": [
    "logs:CreateLogGroup"
  ],
  "Resource": "arn:aws:logs:*:*:log-group:/aws/glue/${base_prefix}-*"
},
{
  "Sid": "AllowLogStreamOperationsForGlue",
  "Effect": "Allow",
  "Action": [
    "logs:CreateLogStream",
    "logs:PutLogEvents"
  ],
  "Resource": "arn:aws:logs:*:*:log-group:/aws/glue/*"
}
```

**Update the template reference in** `base/locals.tf`:

```hcl
glue_policy = templatefile("${path.module}/policies/glue/glue.tpl", {
  workspace_bucket_arn = module.s3_bucket.workspace_bucket_arn
  service_bucket_arn = module.s3_bucket.service_bucket_arn
  glue_catalog_database_arn = format("${local.policy_arn_prefix}:%s/${local.glue_catalog}", "glue", "database")
  glue_catalog_table_arn = format("${local.policy_arn_prefix}:%s/${local.glue_catalog}", "glue", "table")
  base_prefix = local.base_prefix  # Add this
  param_store_allow_catalog_read_and_create_for_crawler_arn = format("${local.policy_arn_prefix}:catalog", "glue")
})
```

### **Step 5: Update Bedrock Service Policy** 🔧

**File:** `base/policies/bedrock_service/bedrock_service_policy.tpl`

**Current has:**
```json
{
  "Sid": "CloudWatchLogsForFlows",
  "Effect": "Allow",
  "Action": [
    "logs:CreateLogGroup",
    "logs:CreateLogStream",
    "logs:PutLogEvents"
  ],
  "Resource": [
    "${logs_arn_flows}",
    "${logs_arn_agents}"
  ]
}
```

**Update to:**
```json
{
  "Sid": "AllowLogGroupCreationForBedrock",
  "Effect": "Allow",
  "Action": "logs:CreateLogGroup",
  "Resource": [
    "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/bedrock/flows/${base_prefix}-*",
    "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/bedrock/agents/${base_prefix}-*"
  ]
},
{
  "Sid": "AllowLogStreamOperationsForBedrock",
  "Effect": "Allow",
  "Action": [
    "logs:CreateLogStream",
    "logs:PutLogEvents"
  ],
  "Resource": [
    "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/bedrock/flows/${base_prefix}-*:*",
    "arn:aws:logs:${aws_region}:${account_id}:log-group:/aws/bedrock/agents/${base_prefix}-*:*"
  ]
}
```

### **Step 6: Clean Up Locals** 🔧

**File:** `base/locals.tf`

Remove these lines (no longer needed):
```hcl
# Remove these as we're not pre-creating these log groups
# glue_log_group_arn = format("${local.policy_arn_prefix}:log-group:/aws-glue/*", "logs")
# logs_arn_flows = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/bedrock/flows/${local.base_prefix}*"
# logs_arn_agents = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/bedrock/agents/${local.base_prefix}*"
```

### **Step 7: Update Lex Policy (Optional)** 🔧

**File:** `base/policies/lex/lex.tpl`

Since you're keeping the Lex conversation log group, update the policy to be more flexible:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowLambdaInvocationForLex",
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "${lex_lambda_resource_arn}"
    },
    {
      "Sid": "AllowLogGroupCreationForLex",
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:*:*:log-group:/aws/lex/${base_prefix}-*"
    },
    {
      "Sid": "AllowLogStreamOperationsForLex",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:log-group:/aws/lex/${base_prefix}*:*"
    }
  ]
}
```

Update the template reference in `base/locals.tf`:
```hcl
lex_policy = templatefile("${path.module}/policies/lex/lex.tpl", {
  lex_lambda_resource_arn = local.lex_lambda_resource_arn
  base_prefix = local.base_prefix  # Add this
})
```

### **Step 8: Add Documentation Outputs** 📝

**File:** `base/outputs.tf`

Add these helpful outputs for users:

```hcl
# Add these outputs to help users understand the logging structure
output "project_prefix" {
  value       = local.base_prefix
  description = "Required prefix for all user-created resources"
}

output "log_group_patterns" {
  value = {
    lambda     = "/aws/lambda/${local.base_prefix}-*"
    glue       = "/aws/glue/${local.base_prefix}-*"
    bedrock    = "/aws/bedrock/*/${local.base_prefix}-*"
    lex        = "/aws/lex/${local.base_prefix}-*"
    opensearch = "/aws/opensearch/domains/${local.base_prefix}-opensearch/*"
  }
  description = "Expected log group patterns for monitoring"
}

output "cloudwatch_insights_queries" {
  value = {
    all_project_logs = "fields @timestamp, @logGroup, @message | filter @logGroup like /${local.base_prefix}/ | sort @timestamp desc"
    lambda_errors    = "fields @timestamp, @message | filter @logGroup like /\\/aws\\/lambda\\/${local.base_prefix}/ | filter @message like /ERROR/"
    recent_activity  = "fields @timestamp, @logGroup | filter @logGroup like /${local.base_prefix}/ | stats count() by @logGroup"
  }
  description = "Sample CloudWatch Insights queries for dashboards"
}
```

### **Step 9: Verify No Hardcoded Log Group ARNs** 🔍

Search your codebase for any hardcoded log group ARNs and update them:

```bash
# Run these commands in your terraform directory
grep -r "log-group:" .
grep -r "CreateLogGroup" .
grep -r "/aws/glue" .
grep -r "/aws/bedrock" .
```

### **Step 10: Test the Changes** 🧪

1. **Run Terraform plan:**
```bash
terraform plan
```

2. **Verify no log groups are being destroyed** (except ones you don't need)

3. **Check IAM policy updates:**
```bash
terraform plan -target=aws_iam_policy.lambda_exec_policy_base
terraform plan -target=aws_iam_policy.glue_exec_policy_base
terraform plan -target=aws_iam_policy.bedrock_service_policy
```

### **Step 11: Apply Changes** 🚀

```bash
# Apply in stages for safety
terraform apply -target=aws_iam_policy.lambda_exec_policy_base
terraform apply -target=aws_iam_policy.glue_exec_policy_base
terraform apply -target=aws_iam_policy.bedrock_service_policy
terraform apply -target=aws_iam_policy.lex_service_policy_base

# Then apply remaining changes
terraform apply
```

## 📋 Summary Checklist

- [ ] Updated Lambda base policy to allow log group creation
- [ ] Updated Glue policy to allow log group creation
- [ ] Updated Bedrock service policy to allow log group creation
- [ ] Updated Lex policy to allow log group creation
- [ ] Added base_prefix parameter to all policy templates
- [ ] Removed unnecessary log group ARN references from locals
- [ ] Added helpful outputs for users
- [ ] Tested with terraform plan
- [ ] Applied changes

## 🎯 Result

After these changes:
1. **Platform only manages** OpenSearch and optionally Lex conversation logs
2. **Users create resources** with enforced prefix (via IAM)
3. **AWS auto-creates** appropriate log groups
4. **Dashboards work** by filtering on the prefix

This is a much cleaner, maintenance-free approach! Let me know if you need clarification on any step.
