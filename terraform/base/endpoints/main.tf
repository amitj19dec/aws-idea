# VPC endpoints
resource "aws_vpc_endpoint" "endpoint" {
  for_each = toset(var.endpoint_names)

  vpc_id              = var.vpc.vpc_attributes.id
  service_name        = "com.amazonaws.${data.aws_region.region.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values({ for k, v in var.vpc.private_subnet_attributes_by_az : split("/", k)[1] => v.id if split("/", k)[0] == "endpoints_subnet" })
  security_group_ids  = [aws_security_group.endpoints_vpc_sg.id]
  private_dns_enabled = true
  tags                = var.tags
}

# Security Group
resource "aws_security_group" "endpoints_vpc_sg" {
  name        = "${var.vpc_name}-endpoints-security-group"
  description = "VPC endpoint"
  vpc_id      = var.vpc.vpc_attributes.id
  tags        = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allowing_ingress_https" {
  security_group_id = aws_security_group.endpoints_vpc_sg.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc.vpc_attributes.cidr_block
  tags        = var.tags
}

resource "aws_vpc_endpoint" "vpc_s3_endpoint" {
  vpc_id            = var.vpc.vpc_attributes.id
  service_name      = "com.amazonaws.${data.aws_region.region.name}.s3"
  vpc_endpoint_type = "Gateway"
  tags              = var.tags
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpce_route_table_association" {
  for_each        = var.vpc.rt_attributes_by_type_by_az.private
  route_table_id  = each.value.id
  vpc_endpoint_id = aws_vpc_endpoint.vpc_s3_endpoint.id
}
