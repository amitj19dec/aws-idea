resource "aws_s3_bucket" "service_bucket" {
  bucket = "${var.bucket_prefix}-service-bucket"
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "service_bucket" {
  bucket = aws_s3_bucket.service_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "service_bucket_life_cycle_config" {
  bucket = aws_s3_bucket.service_bucket.id

  rule {
    id = "life-cycle-configuration-rule"
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
    status = "Enabled"
    filter {}  # Applies to all objects in the bucket
  }
}

resource "aws_s3_bucket_logging" "service_bucket_access_log" {
  bucket = aws_s3_bucket.service_bucket.id

  target_bucket = aws_s3_bucket.service_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_versioning" "service_bucket_versioning" {
  bucket = aws_s3_bucket.service_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
