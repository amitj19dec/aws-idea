{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOpenSearchDomainAccess",
      "Effect": "Allow",
      "Action": [
        "es:*"
      ],
      "Resource": "${opensearch_domain_arn}"
    },
    {
      "Sid": "AllowOpenSearchServiceAccess",
      "Effect": "Allow",
      "Action": [
        "es:DescribeDomains",
        "es:ListTags",
        "es:DescribeDomainHealth"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowKMSAccess",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:CreateGrant"
      ],
      "Resource": "${base_kms_arn}"
    }
  ]
}
