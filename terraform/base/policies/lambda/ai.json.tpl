{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ParameterStoreAccess",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": "${param_store_resource_arn}"
        },
        {
            "Sid": "OpenSearchAccess",
            "Effect": "Allow",
            "Action": [
                "es:ESHttpGet",
                "es:ESHttpPost",
                "es:ESHttpPut",
                "es:ESHttpDelete",
                "es:ESHttpHead",
                "es:DescribeDomains"
            ],
            "Resource": "${opensearch_domain_arn}"
        },
        {
            "Sid": "BedrockAccess",
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream",
                "bedrock:GetFoundationModel",
                "bedrock:ListFoundationModels"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AssumeOpenSearchMasterRole",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "${opensearch_master_role_arn}"
        }
    ]
}
