## Lex
```
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "lex:*",
        "Resource": [
          "arn:aws:lex:us-east-1:982534393096:bot/uais-86ef73a8-*",
          "arn:aws:lex:us-east-1:982534393096:bot-alias/uais-86ef73a8-*/*",
          "arn:aws:lex:us-east-1:982534393096:test-set/uais-86ef73a8-*"
        ]
      },
      {
        "Effect": "Deny",
        "Action": [
          "lex:CreateBotChannel",
          "lex:DeleteBotChannel",
          "lex:DescribeBotChannel",
          "lex:ListBotChannels"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "lex:CreateUploadUrl",
          "lex:ListBuiltInSlotTypes",
          "lex:ListBots",
          "lex:CreateTestSet",
          "lex:ListTestSets",
          "lex:ListBuiltInIntents",
          "lex:ListImports",
          "lex:ListTestExecutions",
          "lex:ListExports"
        ],
        "Resource": "*"
      }
    ]
  }
```

## Lambda
```
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:List*",
          "lambda:GetAccountSettings",
          "iam:ListRoles",
          "iam:GetRole",
          "s3:GetObject*"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": "lambda:CreateFunction",
        "Resource": "arn:aws:lambda:us-east-1:982534393096:function:uais-86ef73a8-*",
        "Condition": {
          "StringEquals": {
            "lambda:VpcIds": "vpc-0f95ee35f56b4973d"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": "lambda:*EventSourceMapping",
        "Resource": "*",
        "Condition": {
          "StringLike": {
            "lambda:FunctionArn": "arn:aws:lambda:us-east-1:982534393096:function:uais-86ef73a8-*"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": "iam:PassRole",
        "Resource": "arn:aws:iam::982534393096:role/uais-86ef73a8-lambda-exec-role",
        "Condition": {
          "StringEquals": {
            "iam:PassedToService": "lambda.amazonaws.com"
          }
        }
      },
      {
        "Effect": "Allow",
        "Action": [
          "lambda:Get*",
          "lambda:Update*",
          "lambda:Delete*",
          "lambda:Invoke*",
          "lambda:Publish*",
          "lambda:CreateAlias",
          "lambda:CreateFunctionUrlConfig",
          "lambda:*LayerVersion",
          "lambda:CreateCodeSigningConfig",
          "lambda:Add*",
          "lambda:Remove*",
          "lambda:Put*",
          "lambda:Tag*",
          "lambda:Untag*"
        ],
        "Resource": [
          "arn:aws:lambda:us-east-1:982534393096:function:uais-86ef73a8-*",
          "arn:aws:lambda:us-east-1:982534393096:function:uais-86ef73a8-*:*",
          "arn:aws:lambda:us-east-1:982534393096:layer:uais-86ef73a8-*",
          "arn:aws:lambda:us-east-1:982534393096:layer:uais-86ef73a8-*:*",
          "arn:aws:lambda:us-east-1:982534393096:code-signing-config:uais-86ef73a8-*"
        ]
      }
    ]
  }
```

## Bedrock
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowBedrockFullAccess",
      "Effect": "Allow",
      "Action": "bedrock:*",
      "Resource": [
        "arn:aws:bedrock:us-east-1:982534393096:data-automation-profile/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:async-invoke/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:flow/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:agent/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:evaluation-job/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:knowledge-base/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:blueprint/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:automated-reasoning-policy/uais-86ef73a8-*:*",
        "arn:aws:bedrock:us-east-1:982534393096:guardrail-profile/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:application-inference-profile/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:inference-profile/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:data-automation-project/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:marketplace/model-endpoint/all-access",
        "arn:aws:bedrock:us-east-1:982534393096:provisioned-model/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:session/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:default-prompt-router/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:guardrail/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:model-invocation-job/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1::foundation-model/*",
        "arn:aws:bedrock:us-east-1:982534393096:agent-alias/uais-86ef73a8-*/*",
        "arn:aws:bedrock:us-east-1:982534393096:data-automation-invocation/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:prompt-router/uais-86ef73a8-*",
        "arn:aws:bedrock:us-east-1:982534393096:prompt/uais-86ef73a8-*:*"
      ]
    },
    {
      "Sid": "DenyCustomModelAndMarketplaceActions",
      "Effect": "Deny",
      "Action": [
        "bedrock:ListCustomModels",
        "bedrock:ListCustomModelDeployments",
        "bedrock:ListModelCopyJobs",
        "bedrock:ListModelImportJobs",
        "bedrock:GetMarketplaceModelEndpoint",
        "bedrock:ListMarketplaceModelEndpoints",
        "bedrock:GetModelImportJob",
        "bedrock:GetModelCopyJob",
        "bedrock:GetCustomModelDeployment",
        "bedrock:GetModelCustomizationJob",
        "bedrock:CreateMarketplaceModelEndpoint",
        "bedrock:DeleteCustomModelDeployment",
        "bedrock:DeleteMarketplaceModelAgreement",
        "bedrock:CreateCustomModel",
        "bedrock:CreateModelCopyJob",
        "bedrock:CreateModelImportJob",
        "bedrock:DeleteMarketplaceModelEndpoint",
        "bedrock:CreateCustomModelDeployment",
        "bedrock:CreateModelCustomizationJob",
        "bedrock:DeleteCustomModel",
        "bedrock:DeregisterMarketplaceModelEndpoint",
        "bedrock:RegisterMarketplaceModelEndpoint",
        "bedrock:UpdateMarketplaceModelEndpoint"
      ],
      "Resource": "*"
    }
  ]
}

```
