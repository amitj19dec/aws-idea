output "workspace_bucket_id" {
  value = aws_s3_bucket.workspace_bucket.id
}

output "workspace_bucket_arn" {
  value = aws_s3_bucket.workspace_bucket.arn
}

output "byod_bucket_id" {
  value = aws_s3_bucket.byod_bucket.id
}

output "byod_bucket_arn" {
  value = aws_s3_bucket.byod_bucket.arn
}

output "service_bucket_id" {
  value = aws_s3_bucket.service_bucket.id
}

output "service_bucket_arn" {
  value = aws_s3_bucket.service_bucket.arn
}
