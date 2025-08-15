```
{
  "TrustPolicy": {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "BatchInferenceJobManagement",
        "Effect": "Allow",
        "Action": [
          "bedrock:CreateModelInvocationJob",
          "bedrock:GetModelInvocationJob",
          "bedrock:ListModelInvocationJobs",
          "bedrock:StopModelInvocationJob"
        ],
        "Resource": [
          "arn:aws:bedrock:us-east-1:982534393096:model-invocation-job/uais-86ef73a8-*",
          "arn:aws:bedrock:us-east-1::foundation-model/*",
          "arn:aws:bedrock:us-east-1:982534393096:provisioned-model/uais-86ef73a8-*"
        ]
      },
      {
        "Sid": "SecretsManagerForThirdPartyKB",
        "Sid": "BatchInferenceInferenceProfiles",
        "Effect": "Allow",
        "Action": [
          "bedrock:InvokeModel"
        ],
        "Resource": [
          "arn:aws:bedrock:us-east-1:982534393096:inference-profile/uais-86ef73a8-*",
          "arn:aws:bedrock:*::foundation-model/*"
        ]
      },
      {
        "Sid": "AccessS3ForBatchInference",
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::uais-86ef73a8-batch-input-bucket",
          "arn:aws:s3:::uais-86ef73a8-batch-input-bucket/*",
          "arn:aws:s3:::uais-86ef73a8-batch-output-bucket",
          "arn:aws:s3:::uais-86ef73a8-batch-output-bucket/*"
        ],
        "Condition": {
          "StringEquals": {
            "aws:ResourceAccount": "982534393096"
          }
        }
      },
      {
        "Sid": "VPCPermissionsForBatchInference",
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ],
        "Resource": "*"
      },
      {
        "Sid": "VPCNetworkInterfaceManagement",
        "Effect": "Allow",
        "Action": [
          "ec2:CreateNetworkInterface"
        ],
        "Resource": [
          "arn:aws:ec2:us-east-1:982534393096:network-interface/*",
          "arn:aws:ec2:us-east-1:982534393096:subnet/uais-86ef73a8-*",
          "arn:aws:ec2:us-east-1:982534393096:security-group/uais-86ef73a8-*"
        ],
        "Condition": {
          "StringEquals": {
            "aws:RequestTag/BedrockManaged": "true"
          },
          "ArnEquals": {
            "aws:RequestTag/BedrockModelInvocationJobArn": "arn:aws:bedrock:us-east-1:982534393096:model-invocation-job/uais-86ef73a8-*"
          }
        }
      },
      {
        "Sid": "VPCNetworkInterfaceCleanup",
        "Effect": "Allow",
        "Action": [
          "ec2:CreateNetworkInterfacePermission",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteNetworkInterfacePermission"
        ],
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "ec2:Subnet": [
              "arn:aws:ec2:us-east-1:982534393096:subnet/uais-86ef73a8-*"
            ]
          }
        }
      },
        "Effect": "Allow",
        "Principal": {
          "Service": "bedrock.amazonaws.com"
        },
        "Action": "sts:AssumeRole",
        "Condition": {
          "StringEquals": {
            "aws:SourceAccount": "982534393096"
          },
          "ArnLike": {
            "AWS:SourceArn": [
              "arn:aws:bedrock:us-east-1:982534393096:agent/*",
              "arn:aws:bedrock:us-east-1:982534393096:agent-alias/*",
              "arn:aws:bedrock:us-east-1:982534393096:flow/*"
            ]
          }
        }
      }
    ]
  },
  "PermissionsPolicy": {
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
          "arn:aws:bedrock:us-east-1::foundation-model/*"
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
          "arn:aws:bedrock:us-east-1:982534393096:provisioned-model/uais-86ef73a8-*"
        ]
      },
      {
        "Sid": "AccessPromptManagement",
        "Effect": "Allow",
        "Action": [
          "bedrock:GetPrompt",
          "bedrock:RenderPrompt"
        ],
        "Resource": [
          "arn:aws:bedrock:us-east-1:982534393096:prompt/uais-86ef73a8-*:*"
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
          "arn:aws:bedrock:us-east-1:982534393096:knowledge-base/uais-86ef73a8-*"
        ]
      },
      {
        "Sid": "InvokeAgentsAndCollaborators",
        "Effect": "Allow",
        "Action": [
          "bedrock:InvokeAgent",
          "bedrock:GetAgent",
          "bedrock:GetAgentAlias"
        ],
        "Resource": [
          "arn:aws:bedrock:us-east-1:982534393096:agent/uais-86ef73a8-*",
          "arn:aws:bedrock:us-east-1:982534393096:agent-alias/uais-86ef73a8-*/*"
        ]
      },
      {
        "Sid": "InvokeLambdaFunctions",
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Resource": [
          "arn:aws:lambda:us-east-1:982534393096:function:uais-86ef73a8-*"
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
          "arn:aws:lex:us-east-1:982534393096:bot-alias/uais-86ef73a8-*"
        ]
      },
      {
        "Sid": "ApplyGuardrails",
        "Effect": "Allow",
        "Action": [
          "bedrock:ApplyGuardrail"
        ],
        "Resource": [
          "arn:aws:bedrock:us-east-1:982534393096:guardrail/uais-86ef73a8-*"
        ]
      },
      {
        "Sid": "AccessS3ForSchemasAndWorkspace",
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::uais-86ef73a8-workspace-bucket",
          "arn:aws:s3:::uais-86ef73a8-workspace-bucket/*",
          "arn:aws:s3:::uais-86ef73a8-schemas-bucket",
          "arn:aws:s3:::uais-86ef73a8-schemas-bucket/*"
        ],
        "Condition": {
          "StringEquals": {
            "aws:ResourceAccount": "982534393096"
          }
        }
      },
      {
        "Sid": "AccessS3ForCodeInterpretation",
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": [
          "arn:aws:s3:::uais-86ef73a8-code-interpretation-bucket/*"
        ],
        "Condition": {
          "StringEquals": {
            "aws:ResourceAccount": "982534393096"
          }
        }
      },
      {
        "Sid": "KMSAccess",
        "Effect": "Allow",
        "Action": [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:CreateGrant"
        ],
        "Resource": [
          "arn:aws:kms:us-east-1:982534393096:key/1227cc92-2315-4440-8f76-4353eb78e7c9"
        ],
        "Condition": {
          "StringEquals": {
            "kms:ViaService": [
              "s3.us-east-1.amazonaws.com",
              "bedrock.us-east-1.amazonaws.com"
            ]
          }
        }
      },
      {
        "Sid": "CloudWatchLogsForFlows",
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:us-east-1:982534393096:log-group:/aws/bedrock/flows/uais-86ef73a8-*",
          "arn:aws:logs:us-east-1:982534393096:log-group:/aws/bedrock/agents/uais-86ef73a8-*",
          "arn:aws:logs:us-east-1:982534393096:log-group:/aws/bedrock/model-invocation-jobs/uais-86ef73a8-*"
        ]
      },
      {
        "Sid": "AccessThirdPartyKnowledgeBases",
        "Effect": "Allow",
        "Action": [
          "bedrock:AssociateThirdPartyKnowledgeBase"
        ],
        "Resource": [
          "arn:aws:bedrock:us-east-1:982534393096:knowledge-base/uais-86ef73a8-*"
        ],
        "Condition": {
          "StringEquals": {
            "aws:ResourceAccount": "982534393096"
          }
        }
      },
      {
        "Sid": "SecretsManagerForThirdPartyKB",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetSecretValue"
        ],
        "Resource": [
          "arn:aws:secretsmanager:us-east-1:982534393096:secret:uais-86ef73a8-*"
        ],
        "Condition": {
          "StringEquals": {
            "aws:ResourceAccount": "982534393096"
          }
        }
      }
    ]
  }
}
```
