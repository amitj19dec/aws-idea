{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowReadWriteDeleteAccessOnWorkspaceBucket",
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:Describe*",
        "s3:DeleteObject",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${workspace_bucket_arn}",
        "${workspace_bucket_arn}/*"
      ]
    },
    {
      "Sid": "AllowReadAccessOnByodBucket",
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*",
        "s3:Describe*"
      ],
      "Resource": [
        "${byod_bucket_arn}",
        "${byod_bucket_arn}/*"
      ]
    },
    {
      "Sid": "AllowReadWriteAccessOnWorkspaceEcr",
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:GetAuthorizationToken",
        "ecr:DescribeImages"
      ],
      "Resource": "${base_ecr_arn}"
    },
    {
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:CreateGrant"
      ],
      "Effect": "Allow",
      "Resource": "${base_kms_arn}"
    },
    {
      "Sid": "AllowPassRoleToSageMaker",
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "${sagemaker_role_arn}",
      "Condition": {
        "StringEquals": {
          "iam:PassedToService": "sagemaker.amazonaws.com"
        }
      }
    },
    {
      "Sid": "AllowVSCodeConnectivityInSageMaker",
      "Effect": "Allow",
      "Action": [
        "sagemaker:StartSession"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowMLFlowInSageMaker",
      "Effect": "Allow",
      "Action": [
        "sagemaker:CallMLflowAPI",
        "sagemaker:ListExperiments",
        "sagemaker:CreateTrackingServer",
        "sagemaker:UpdateTrackingServer",
        "sagemaker:DeleteTrackingServer",
        "sagemaker:ManageTrackingServer",
        "sagemaker:ListRuns",
        "sagemaker:CreateExperiment",
        "sagemaker:ListModelPackages",
        "sagemaker:CreateModelPackage",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "sagemaker:CreateModel",
        "sagemaker:CreateEndpointConfig",
        "sagemaker:CreateEndpoint",
        "sagemaker:UpdateEndpoint",
        "sagemaker:DeleteModel",
        "sagemaker:DeleteEndpointConfig",
        "sagemaker:DeleteEndpoint"
      ],
      "Resource": "*"
    }
  ]
}
