aws_region     = "us-east-1"
aws_account_id = "982534393096"
project_id     = "46de60f5-2b31-4fb7-9cbf-b728d5b104e3"


vpc = {
  cidr_block             = "10.93.128.0/22"
  number_azs             = 2
  sagemaker_subnet_cidrs = ["10.93.128.0/25", "10.93.128.128/25"]
  endpoint_subnet_cidrs  = ["10.93.129.0/25", "10.93.129.128/25"]
}

tags = {
  "project_id"   = "46de60f5-2b31-4fb7-9cbf-b728d5b104e3",
  "aide-id"      = "AIDE_0074310"
  "hcp_rg"       = "migration-aide-0074310-4416a57",
  "environment"  = "dev",
  "service-tier" = "p2"
}

endpoint_names = ["ecr.api", "ecr.dkr", "logs", "ssm", "ssmmessages", "ec2messages", "sagemaker.api", "secretsmanager", "sagemaker.runtime",
  "sagemaker.featurestore-runtime", "servicecatalog", "forecast", "forecastquery", "rekognition", "textract", "comprehend", "sts", "redshift-data",
"athena", "glue", "codewhisperer"]
