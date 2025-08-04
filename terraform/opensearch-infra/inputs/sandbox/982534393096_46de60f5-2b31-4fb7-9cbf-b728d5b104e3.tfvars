aws_region     = "us-east-1"
aws_account_id = "982534393096"
project_id     = "46de60f5-2b31-4fb7-9cbf-b728d5b104e3"

tags = {
  "project_id"   = "46de60f5-2b31-4fb7-9cbf-b728d5b104e3",
  "aide-id"      = "AIDE_0074310"
  "hcp_rg"       = "migration-aide-0074310-4416a57",
  "environment"  = "dev",
  "service-tier" = "p2"
}

# OpenSearch specific configurations
instance_type             = "m6g.large.search"
instance_count            = 2
dedicated_master_enabled  = true
master_instance_type      = "m6g.medium.search"
master_instance_count     = 3
ebs_volume_size          = 100
ebs_volume_type          = "gp3"
engine_version           = "OpenSearch_2.13"
zone_awareness_enabled   = true
