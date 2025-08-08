```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "LexProjectAccess",
      "Effect": "Allow",
      "Action": "lex:*",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "lex:bot-name": "project-${uuid}-*"
        }
      }
    },
    {
      "Sid": "SupportingServices",
      "Effect": "Allow",
      "Action": [
        "lambda:GetFunction",
        "lambda:ListFunctions",
        "logs:*LogGroup*",
        "logs:GetLogEvents",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:lambda:*:*:function:project-${uuid}-*",
        "arn:aws:logs:*:*:log-group:/aws/lex/project-${uuid}-*",
        "arn:aws:s3:::project-${uuid}-conversation-logs*"
      ]
    },
    {
      "Sid": "SecurityBoundaries",
      "Effect": "Deny",
      "Action": [
        "iam:*",
        "sts:AssumeRole"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EnforceServiceRole",
      "Effect": "Deny",
      "Action": "lex:UpdateBot",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "lex:service-role": "arn:aws:iam::${aws:accountId}:role/project-${uuid}-lex-service-role"
        }
      }
    }
  ]
}
```
----
```

resource "aws_cloudwatch_log_group" "lex_conversation_logs" {
  name              = "/aws/lex/bots/${local.base_prefix}-lex"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.base_kms_key.arn
  
  tags = merge(
    var.tags,
    {
      provisoner = local.resource_provisioner
    }
  )
}
```
