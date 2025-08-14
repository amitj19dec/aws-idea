## Lex User Policy
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"lex:DeleteImport",
				"lex:ListSlotTypes",
				"lex:CreateExport",
				"lex:StartTestSetGeneration",
				"lex:DescribeIntent",
				"lex:UpdateBotAlias",
				"lex:DescribeCustomVocabularyMetadata",
				"lex:ListBotVersionReplicas",
				"lex:CreateBotReplica",
				"lex:UpdateBotLocale",
				"lex:DescribeTestExecution",
				"lex:DeleteIntent",
				"lex:ListBotLocales",
				"lex:UpdateSlotType",
				"lex:ListIntentPaths",
				"lex:RecognizeUtterance",
				"lex:ListBotChannels",
				"lex:ListCustomVocabularyItems",
				"lex:CreateBot",
				"lex:DeleteBotAlias",
				"lex:DescribeBotLocale",
				"lex:DeleteBot",
				"lex:ListIntentStageMetrics",
				"lex:ListBotReplicas",
				"lex:GenerateBotElement",
				"lex:DeleteSlotType",
				"lex:UpdateBotRecommendation",
				"lex:DeleteSession",
				"lex:DeleteResourcePolicyStatement",
				"lex:StartBotResourceGeneration",
				"lex:DescribeImport",
				"lex:DescribeSlot",
				"lex:ListIntentMetrics",
				"lex:DescribeBotReplica",
				"lex:UpdateSlot",
				"lex:ListAggregatedUtterances",
				"lex:DeleteExport",
				"lex:DescribeTestSet",
				"lex:DescribeSlotType",
				"lex:DeleteCustomVocabulary",
				"lex:DeleteBotVersion",
				"lex:CreateResourcePolicy",
				"lex:BatchCreateCustomVocabularyItem",
				"lex:ListBotAliases",
				"lex:DescribeBotAlias",
				"lex:DescribeTestSetDiscrepancyReport",
				"lex:DescribeCustomVocabulary",
				"lex:ListSessionAnalyticsData",
				"lex:BuildBotLocale",
				"lex:ListBotVersions",
				"lex:CreateBotAlias",
				"lex:CreateSlotType",
				"lex:ListTagsForResource",
				"lex:DeleteBotLocale",
				"lex:CreateBotChannel",
				"lex:DescribeBotVersion",
				"lex:UpdateIntent",
				"lex:CreateResourcePolicyStatement",
				"lex:DeleteResourcePolicy",
				"lex:ListSlots",
				"lex:ListBotRecommendations",
				"lex:DescribeBot",
				"lex:CreateCustomVocabulary",
				"lex:CreateBotLocale",
				"lex:DescribeBotRecommendation",
				"lex:DescribeBotResourceGeneration",
				"lex:ListBotResourceGenerations",
				"lex:ListIntents",
				"lex:SearchAssociatedTranscripts",
				"lex:BatchUpdateCustomVocabularyItem",
				"lex:UpdateCustomVocabulary",
				"lex:UpdateExport",
				"lex:CreateSlot",
				"lex:DeleteUtterances",
				"lex:CreateBotVersion",
				"lex:StartTestExecution",
				"lex:DescribeBotChannel",
				"lex:PutSession",
				"lex:DescribeResourcePolicy",
				"lex:GetTestExecutionArtifactsUrl",
				"lex:StopBotRecommendation",
				"lex:DescribeTestSetGeneration",
				"lex:DeleteBotReplica",
				"lex:ListTestExecutionResultItems",
				"lex:UpdateTestSet",
				"lex:StartImport",
				"lex:StartBotRecommendation",
				"lex:CreateIntent",
				"lex:RecognizeText",
				"lex:DescribeExport",
				"lex:ListRecommendedIntents",
				"lex:StartConversation",
				"lex:ListTestSetRecords",
				"lex:ListSessionMetrics",
				"lex:CreateTestSetDiscrepancyReport",
				"lex:UpdateResourcePolicy",
				"lex:DeleteBotChannel",
				"lex:GetSession",
				"lex:DeleteSlot",
				"lex:UpdateBot",
				"lex:ListBotAliasReplicas",
				"lex:DeleteTestSet",
				"lex:BatchDeleteCustomVocabularyItem"
			],
			"Resource": [
				"arn:aws:lex:us-east-1:982534393096:bot/uais-86ef73a8-*",
				"arn:aws:lex:us-east-1:982534393096:bot-alias/uais-86ef73a8-*/*",
				"arn:aws:lex:us-east-1:982534393096:test-set/uais-86ef73a8-*"
			]
		},
		{
			"Sid": "VisualEditor1",
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


```
{
    "Statement": [
        {
            "Action": [
                "neptune-db:ManageStatistics",
                "neptune-db:ResetDatabase",
                "neptune-db:DeleteStatistics"
            ],
            "Effect": "Deny",
            "Resource": "arn:aws:rds:us-east-1:982534393096:cluster:uais-aaf481b1",
            "Sid": "DenyNeptuneDestructiveActions"
        },
        {
            "Action": [
                "es:ESHttpGet",
                "es:ESHttpPost",
                "es:ESHttpPut",
                "es:ESHttpDelete",
                "es:ESHttpHead",
                "es:ESHttpPatch"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:es:us-east-1:982534393096:domain/uais-aaf481b1-opensearch/*",
            "Sid": "AllowOpenSearchAccess"
        },
        {
            "Action": [
                "es:DescribeDomain",
                "es:DescribeDomains",
                "es:DescribeDomainConfig"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:es:us-east-1:982534393096:domain/uais-aaf481b1-opensearch/*",
            "Sid": "AllowOpenSearchDescribe"
        },
        {
            "Action": [
                "sagemaker:InvokeEndpoint",
                "sagemaker:InvokeEndpointAsync"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:sagemaker:us-east-1:982534393096:endpoint/uais-aaf481b1-*",
            "Sid": "AllowSageMakerEndpointInvocation"
        },
        {
            "Action": [
                "sagemaker:DescribeEndpoint",
                "sagemaker:DescribeEndpointConfig",
                "sagemaker:ListEndpoints",
                "sagemaker:ListEndpointConfigs"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowSageMakerEndpointOperations"
        },
        {
            "Action": [
                "sagemaker:DescribeModel",
                "sagemaker:ListModels"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowSageMakerModelOperations"
        },
        {
            "Action": [
                "sagemaker:CreateTransformJob",
                "sagemaker:DescribeTransformJob",
                "sagemaker:ListTransformJobs",
                "sagemaker:StopTransformJob"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:sagemaker:us-east-1:982534393096:transform-job/uais-aaf481b1-*",
            "Sid": "AllowSageMakerBatchOperations"
        },
        {
            "Action": [
                "sagemaker:GetRecord",
                "sagemaker:BatchGetRecord"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:sagemaker:us-east-1:982534393096:feature-group/uais-aaf481b1-*",
            "Sid": "AllowSageMakerFeatureStoreOperations"
        },
        {
            "Action": [
                "sagemaker:ListTags"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowSageMakerTagOperations"
        },
        {
            "Action": [
                "sagemaker:CreateModel",
                "sagemaker:CreateEndpointConfig",
                "sagemaker:CreateEndpoint",
                "sagemaker:UpdateEndpoint",
                "sagemaker:DeleteModel",
                "sagemaker:DeleteEndpointConfig",
                "sagemaker:DeleteEndpoint"
            ],
            "Effect": "Deny",
            "Resource": "*",
            "Sid": "DenySageMakerEndpointCreation"
        },
        {
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:bedrock:us-east-1:982534393096::foundation-model/*",
            "Sid": "AllowBedrockModelInvocation"
        },
        {
            "Action": [
                "bedrock:Retrieve",
                "bedrock:RetrieveAndGenerate"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:bedrock:us-east-1:982534393096:knowledge-base/*",
            "Sid": "AllowBedrockKnowledgeBaseOperations"
        },
        {
            "Action": [
                "bedrock:GetKnowledgeBase",
                "bedrock:ListKnowledgeBases",
                "bedrock:GetDataSource",
                "bedrock:ListDataSources"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowBedrockKnowledgeBaseRead"
        },
        {
            "Action": [
                "bedrock:InvokeAgent"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:bedrock:us-east-1:982534393096:agent/*",
                "arn:aws:bedrock:us-east-1:982534393096:agent-alias/*"
            ],
            "Sid": "AllowBedrockAgentOperations"
        },
        {
            "Action": [
                "bedrock:GetAgent",
                "bedrock:ListAgents",
                "bedrock:GetAgentAlias",
                "bedrock:ListAgentAliases"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowBedrockAgentRead"
        },
        {
            "Action": [
                "bedrock:ListFoundationModels",
                "bedrock:GetFoundationModel",
                "bedrock:ListCustomModels",
                "bedrock:GetCustomModel"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowBedrockModelDiscovery"
        },
        {
            "Action": [
                "bedrock:ApplyGuardrail"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:bedrock:us-east-1:982534393096:guardrail/*",
            "Sid": "AllowBedrockGuardrails"
        },
        {
            "Action": [
                "bedrock:GetGuardrail",
                "bedrock:ListGuardrails"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowBedrockGuardrailsRead"
        }
    ],
    "Version": "2012-10-17"
},

{
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
},

{
    "Statement": [
        {
            "Action": "dynamodb:*",
            "Condition": {
                "ArnEquals": {
                    "aws:SourceArn": "arn:aws:lambda:us-east-1:982534393096:function:uais-aaf481b1-*"
                }
            },
            "Effect": "Allow",
            "Resource": "arn:aws:dynamodb:us-east-1:982534393096:table/uais-aaf481b1-*",
            "Sid": "AllowDynamoDBFullAccess"
        },
        {
            "Action": "dynamodb:CreateTable",
            "Condition": {
                "ArnEquals": {
                    "aws:SourceArn": "arn:aws:lambda:us-east-1:982534393096:function:uais-aaf481b1-*"
                },
                "StringLike": {
                    "dynamodb:TableName": "uais-aaf481b1-*"
                }
            },
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowCreateTable"
        }
    ],
    "Version": "2012-10-17"
},
{
    "Statement": [
        {
            "Action": [
                "logs:DeleteSubscriptionFilter",
                "logs:DeleteIntegration",
                "logs:DeleteDeliveryDestinationPolicy",
                "logs:CreateLogStream",
                "logs:CreateLogAnomalyDetector",
                "logs:CancelExportTask",
                "logs:DeleteRetentionPolicy",
                "logs:DeleteTransformer",
                "logs:PutIndexPolicy",
                "logs:PutDataProtectionPolicy",
                "logs:UpdateAnomaly",
                "logs:DeleteDeliverySource",
                "logs:DeleteQueryDefinition",
                "logs:PutDeliverySource",
                "logs:CreateLogGroup",
                "logs:PutIntegration",
                "logs:Link",
                "logs:CreateLogDelivery",
                "logs:PutMetricFilter",
                "logs:PutResourcePolicy",
                "logs:UpdateLogDelivery",
                "logs:UpdateDeliveryConfiguration",
                "logs:PutDeliveryDestinationPolicy",
                "logs:PutSubscriptionFilter",
                "logs:DeleteDelivery",
                "logs:DeleteDataProtectionPolicy",
                "logs:CreateDelivery",
                "logs:DeleteLogStream",
                "logs:DeleteAccountPolicy",
                "logs:CreateExportTask",
                "logs:UpdateLogAnomalyDetector",
                "logs:DeleteResourcePolicy",
                "logs:DeleteMetricFilter",
                "logs:AssociateKmsKey",
                "logs:DeleteLogDelivery",
                "logs:DeleteLogAnomalyDetector",
                "logs:DeleteDeliveryDestination",
                "logs:PutDestination",
                "logs:DisassociateKmsKey",
                "logs:DeleteLogGroup",
                "logs:PutDestinationPolicy",
                "logs:PutQueryDefinition",
                "logs:DeleteDestination",
                "logs:PutAccountPolicy",
                "logs:PutLogEvents",
                "logs:PutDeliveryDestination",
                "logs:DeleteIndexPolicy",
                "logs:PutTransformer",
                "logs:PutRetentionPolicy"
            ],
            "Effect": "Deny",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
},
{
    "Statement": [
        {
            "Action": [
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:ssm:us-east-1:982534393096:parameter/params/uais-aaf481b1/platform/*",
            "Sid": "ReadPermissionOnPlatformParameterStore"
        },
        {
            "Action": "ssm:*",
            "Effect": "Allow",
            "Resource": "arn:aws:ssm:us-east-1:982534393096:parameter/params/uais-aaf481b1/application/*",
            "Sid": "AllPermissionOnApplicationParameterStore"
        },
        {
            "Action": [
                "ssm:DeleteResourcePolicy",
                "ssm:PutResourcePolicy",
                "ssm:ModifyDocumentPermission"
            ],
            "Effect": "Deny",
            "Resource": "arn:aws:ssm:us-east-1:982534393096:parameter/params/uais-aaf481b1/application/*",
            "Sid": "DenyPermissionOnParameterStore"
        },
        {
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::uais-aaf481b1-workspace-bucket",
                        "arn:aws:s3:::uais-aaf481b1-byod-bucket",
                        "arn:aws:s3:::uais-aaf481b1-service-bucket"
                    ],
                    "kms:ViaService": "s3.us-east-1.amazonaws.com"
                }
            },
            "Effect": "Allow",
            "Resource": "arn:aws:kms:us-east-1:982534393096:key/cf2ad850-4225-4df0-9f4f-5a088b40a45c",
            "Sid": "AllowKMSDecryptForS3Buckets"
        },
        {
            "Action": [
                "kms:GenerateDataKey",
                "kms:GenerateDataKeyWithoutPlaintext"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::uais-aaf481b1-workspace-bucket",
                        "arn:aws:s3:::uais-aaf481b1-byod-bucket",
                        "arn:aws:s3:::uais-aaf481b1-service-bucket"
                    ],
                    "kms:ViaService": "s3.us-east-1.amazonaws.com"
                }
            },
            "Effect": "Allow",
            "Resource": "arn:aws:kms:us-east-1:982534393096:key/cf2ad850-4225-4df0-9f4f-5a088b40a45c",
            "Sid": "AllowKMSGenerateDataKeyForS3Buckets"
        },
        {
            "Action": [
                "kms:CreateGrant"
            ],
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                },
                "StringEquals": {
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::uais-aaf481b1-workspace-bucket",
                        "arn:aws:s3:::uais-aaf481b1-byod-bucket",
                        "arn:aws:s3:::uais-aaf481b1-service-bucket"
                    ],
                    "kms:ViaService": "s3.us-east-1.amazonaws.com"
                }
            },
            "Effect": "Allow",
            "Resource": "arn:aws:kms:us-east-1:982534393096:key/cf2ad850-4225-4df0-9f4f-5a088b40a45c",
            "Sid": "AllowKMSCreateGrantForS3Buckets"
        },
        {
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": [
                        "ssm.us-east-1.amazonaws.com",
                        "secretsmanager.us-east-1.amazonaws.com",
                        "dynamodb.us-east-1.amazonaws.com"
                    ]
                }
            },
            "Effect": "Allow",
            "Resource": "arn:aws:kms:us-east-1:982534393096:key/cf2ad850-4225-4df0-9f4f-5a088b40a45c",
            "Sid": "AllowKMSDecryptForOtherServices"
        },
        {
            "Action": [
                "kms:ListKeys",
                "kms:ListAliases"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "AllowKMSListOperations"
        }
    ],
    "Version": "2012-10-17"
}


```
