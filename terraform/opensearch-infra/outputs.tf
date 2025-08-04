output "opensearch_domain_id" {
  value       = aws_opensearch_domain.opensearch.id
  description = "The ID of the OpenSearch domain"
}

output "opensearch_domain_arn" {
  value       = aws_opensearch_domain.opensearch.arn
  description = "The ARN of the OpenSearch domain"
}

output "opensearch_endpoint" {
  value       = aws_opensearch_domain.opensearch.endpoint
  description = "The OpenSearch domain endpoint"
}

output "opensearch_dashboards_endpoint" {
  value       = aws_opensearch_domain.opensearch.kibana_endpoint
  description = "The OpenSearch Dashboards endpoint"
}

output "opensearch_domain_name" {
  value       = aws_opensearch_domain.opensearch.domain_name
  description = "The name of the OpenSearch domain"
}
