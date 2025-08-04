output "sagemaker_domain_id" {
  value       = aws_sagemaker_domain.sagemaker_domain.id
  description = "The ID of the created SageMaker domain"
}
