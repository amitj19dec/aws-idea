## Flows service role ##

```
{
    "Statement": [
        {
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:bedrock:us-east-1::foundation-model/*"
            ],
            "Sid": "InvokeFoundationModels"
        },
        {
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:GetProvisionedModelThroughput"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:bedrock:us-east-1:982534393096:provisioned-model/uais-86ef73a8-*"
            ],
            "Sid": "InvokeProvisionedModels"
        },
        {
            "Action": [
                "bedrock:GetPrompt"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:bedrock:us-east-1:982534393096:prompt/uais-86ef73a8-*:*"
            ],
            "Sid": "AccessPromptManagement"
        },
        {
            "Action": [
                "bedrock:Retrieve",
                "bedrock:RetrieveAndGenerate"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:bedrock:us-east-1:982534393096:knowledge-base/uais-86ef73a8-*"
            ],
            "Sid": "QueryKnowledgeBases"
        },
        {
            "Action": [
                "bedrock:InvokeAgent"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:bedrock:us-east-1:982534393096:agent/uais-86ef73a8-*",
                "arn:aws:bedrock:us-east-1:982534393096:agent-alias/uais-86ef73a8-*/*"
            ],
            "Sid": "InvokeAgents"
        },
        {
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:lambda:us-east-1:982534393096:function:uais-86ef73a8-*"
            ],
            "Sid": "InvokeLambdaFunctions"
        },
        {
            "Action": [
                "lex:RecognizeText",
                "lex:RecognizeUtterance",
                "lex:PostContent",
                "lex:PostText"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:lex:us-east-1:982534393096:bot-alias/uais-86ef73a8-*"
            ],
            "Sid": "AccessLexBots"
        },
        {
            "Action": [
                "bedrock:ApplyGuardrail"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:bedrock:us-east-1:982534393096:guardrail/*"
            ],
            "Sid": "ApplyGuardrails"
        },
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::uais-86ef73a8-workspace-bucket",
                "arn:aws:s3:::uais-86ef73a8-workspace-bucket/*"
            ],
            "Sid": "AccessS3ForFlows"
        },
        {
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey",
                "kms:CreateGrant"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": [
                        "s3.us-east-1.amazonaws.com",
                        "bedrock.us-east-1.amazonaws.com"
                    ]
                }
            },
            "Effect": "Allow",
            "Resource": "arn:aws:kms:us-east-1:982534393096:key/1227cc92-2315-4440-8f76-4353eb78e7c9",
            "Sid": "KMSAccess"
        },
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:us-east-1:982534393096:log-group:/aws/bedrock/flows/uais-86ef73a8-*"
            ],
            "Sid": "CloudWatchLogs"
        }
    ],
    "Version": "2012-10-17"
}
```
