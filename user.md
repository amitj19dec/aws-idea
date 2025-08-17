## Basic
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PlatformVPCResourcesRead",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeRouteTables",
        "ec2:DescribeNetworkAcls"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "us-east-1"
        },
        "ForAllValues:StringLike": {
          "ec2:ResourceTag/Name": "*uais-86ef73a8*"
        }
      }
    },
    {
      "Sid": "PlatformS3BucketsRead",
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketLocation",
        "s3:GetBucketVersioning",
        "s3:GetBucketEncryption",
        "s3:GetBucketLogging",
        "s3:GetBucketAcl",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::uais-86ef73a8-workspace-bucket",
        "arn:aws:s3:::uais-86ef73a8-byod-bucket",
        "arn:aws:s3:::uais-86ef73a8-service-bucket"
      ]
    },
    {
      "Sid": "PlatformKMSRead",
      "Effect": "Allow",
      "Action": [
        "kms:DescribeKey"
      ],
      "Resource": "arn:aws:kms:us-east-1:982534393096:key/*",
      "Condition": {
        "ForAllValues:StringLike": {
          "kms:AliasName": "alias/uais-86ef73a8-*"
        }
      }
    },
    {
      "Sid": "PlatformKMSListAliases",
      "Effect": "Allow",
      "Action": [
        "kms:ListAliases"
      ],
      "Resource": "*"
    },
    {
      "Sid": "PlatformECRRead",
      "Effect": "Allow",
      "Action": [
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
        "ecr:GetRepositoryPolicy"
      ],
      "Resource": "arn:aws:ecr:us-east-1:982534393096:repository/uais-86ef73a8-ecr"
    },
    {
      "Sid": "PlatformSageMakerRead",
      "Effect": "Allow",
      "Action": [
        "sagemaker:DescribeDomain",
        "sagemaker:DescribeUserProfile",
        "sagemaker:ListDomains",
        "sagemaker:ListUserProfiles"
      ],
      "Resource": [
        "arn:aws:sagemaker:us-east-1:982534393096:domain/uais-86ef73a8-*",
        "arn:aws:sagemaker:us-east-1:982534393096:user-profile/uais-86ef73a8-*/*"
      ]
    },
    {
      "Sid": "PlatformOpenSearchRead",
      "Effect": "Allow",
      "Action": [
        "es:DescribeDomain",
        "es:DescribeDomains",
        "es:DescribeDomainConfig",
        "es:ListDomainNames",
        "aoss:BatchGetCollection",
        "aoss:ListCollections"
      ],
      "Resource": [
        "arn:aws:es:us-east-1:982534393096:domain/uais-86ef73a8-*",
        "arn:aws:aoss:us-east-1:982534393096:collection/uais-86ef73a8-*"
      ]
    },
    {
      "Sid": "PlatformIAMRolesRead",
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:ListAttachedRolePolicies"
      ],
      "Resource": [
        "arn:aws:iam::982534393096:role/uais-86ef73a8-*"
      ]
    },
    {
      "Sid": "PlatformParameterStoreRead",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:DescribeParameters"
      ],
      "Resource": "arn:aws:ssm:us-east-1:982534393096:parameter/params/uais-86ef73a8/platform/*"
    },
    {
      "Sid": "PlatformGlueRead",
      "Effect": "Allow",
      "Action": [
        "glue:GetDatabase",
        "glue:GetDatabases",
        "glue:GetTable",
        "glue:GetTables"
      ],
      "Resource": [
        "arn:aws:glue:us-east-1:982534393096:catalog",
        "arn:aws:glue:us-east-1:982534393096:database/uais-86ef73a8-*",
        "arn:aws:glue:us-east-1:982534393096:table/uais-86ef73a8-*/*"
      ]
    },
    {
      "Sid": "PlatformCloudWatchLogsRead",
      "Effect": "Allow",
      "Action": [
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:982534393096:log-group:/aws/sagemaker/domains/uais-86ef73a8-*",
        "arn:aws:logs:us-east-1:982534393096:log-group:/aws/opensearch/domains/uais-86ef73a8-*",
        "arn:aws:logs:us-east-1:982534393096:log-group:/aws/lex/uais-86ef73a8-*"
      ]
    },
    {
      "Sid": "GeneralAWSServiceDiscovery",
      "Effect": "Allow",
      "Action": [
        "sts:GetCallerIdentity"
      ],
      "Resource": "*"
    }
  ]
}
```

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
