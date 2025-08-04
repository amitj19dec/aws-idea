resource "aws_s3_bucket" "workspace_bucket" {
  bucket = "${var.bucket_prefix}-workspace-bucket"
  tags   = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "workspace_bucket" {
  bucket = aws_s3_bucket.workspace_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "workspace_bucket_life_cycle_config" {
  bucket = aws_s3_bucket.workspace_bucket.id

  rule {
    id = "life-cycle-configuration-rule"
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
    status = "Enabled"
    filter {}  # Applies to all objects in the bucket
  }
}

resource "aws_s3_bucket_logging" "workspace_bucket_access_log" {
  bucket = aws_s3_bucket.workspace_bucket.id

  target_bucket = aws_s3_bucket.workspace_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_versioning" "workspace_bucket_versioning" {
  bucket = aws_s3_bucket.workspace_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "workspace_bucket_policy" {
  bucket = aws_s3_bucket.workspace_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            var.sagemaker_role_arn
          ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetBucketAcl",
          "s3:PutObjectAcl"
        ]
        Resource = [
          aws_s3_bucket.workspace_bucket.arn,
          "${aws_s3_bucket.workspace_bucket.arn}/*"
        ]
      }
    ]
  })
}
