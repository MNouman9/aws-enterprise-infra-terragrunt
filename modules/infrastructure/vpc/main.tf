resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    var.tags,
    {
      Name = "VPC for ${var.application}-${var.environment}"
    }
  )
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.default.id
  tags   = var.tags
}

resource "aws_eip" "nat_gateway_eip" {
  tags = var.tags
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags          = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  tags = merge(
    var.tags,
    {
      Name = "public-route-table-${var.application}-${var.environment}"
    }
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id
  tags = merge(
    var.tags,
    {
      Name = "private-route-table-${var.application}-${var.environment}"
    }
  )
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.default.id
  availability_zone = "${var.region}a"
  cidr_block        = var.cidr_block_private_subnet_a
  tags = merge(
    var.tags, {
      Name                              = "${var.application}.${var.environment}.private.subnet.a"
      "kubernetes.io/role/internal-elb" = 1
    }
  )
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.default.id
  availability_zone = "${var.region}b"
  cidr_block        = var.cidr_block_private_subnet_b
  tags = merge(
    var.tags,
    {
      Name                              = "${var.application}.${var.environment}.private.subnet.b"
      "kubernetes.io/role/internal-elb" = 1
    }
  )
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.default.id
  availability_zone = "${var.region}c"
  cidr_block        = var.cidr_block_private_subnet_c
  tags = merge(
    var.tags,
    {
      Name                              = "${var.application}.${var.environment}.private.subnet.c"
      "kubernetes.io/role/internal-elb" = 1
    }
  )
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.default.id
  availability_zone = "${var.region}a"
  cidr_block        = var.cidr_block_public_subnet_a
  tags = merge(
    var.tags,
    {
      Name                     = "${var.application}.${var.environment}.public.subnet.a"
      "kubernetes.io/role/elb" = 1
    }
  )
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.default.id
  availability_zone = "${var.region}b"
  cidr_block        = var.cidr_block_public_subnet_b
  tags = merge(
    var.tags,
    {
      Name                     = "${var.application}.${var.environment}.public.subnet.b"
      "kubernetes.io/role/elb" = 1
    }
  )
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.default.id
  availability_zone = "${var.region}c"
  cidr_block        = var.cidr_block_public_subnet_c
  tags = merge(
    var.tags,
    {
      Name                     = "${var.application}.${var.environment}.public.subnet.c"
      "kubernetes.io/role/elb" = 1
    }
  )
}

resource "aws_default_security_group" "default" {
  vpc_id  = aws_vpc.default.id
  ingress = []
  egress  = []
  tags    = var.tags
}

resource "aws_flow_log" "flow_log" {
  log_destination      = var.logging_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.default.id
  destination_options {
    hive_compatible_partitions = true
  }
  tags = var.tags
}