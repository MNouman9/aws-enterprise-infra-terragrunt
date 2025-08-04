resource "aws_security_group" "ssh_public" {
  vpc_id      = var.vpc_id
  name        = "${var.application}-ssh-public-${var.environment}"
  description = "Allow public SSH connections from specific IPs"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_access_cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.application}-ssh-public-${var.environment}"
    }
  )
}

resource "aws_security_group" "ssh_private" {
  vpc_id      = var.vpc_id
  name        = "${var.application}-ssh-private-${var.environment}"
  description = "Allow SSH connections from bastion server"
  tags = merge(
    var.tags,
    {
      Name = "${var.application}-ssh-private-${var.environment}"
    }
  )
}

resource "aws_security_group" "postgres" {
  vpc_id      = var.vpc_id
  name        = "database-sg-${var.application}-${var.environment}"
  description = "Allow access to PostgreSQL instance"
  tags = merge(
    var.tags,
    {
      Name = "database.securitygroup.${var.application}.${var.environment}"
    }
  )
}

resource "aws_security_group" "documentdb" {
  vpc_id      = var.vpc_id
  name        = "docdb-sg-${var.application}-${var.environment}"
  description = "Allow access to DocumentDB instance"
  tags = merge(
    var.tags,
    {
      Name = "docdb.securitygroup.${var.application}.${var.environment}"
    }
  )
}

resource "aws_security_group" "eks_cluster" {
  vpc_id      = var.vpc_id
  name        = "${var.application}-eks-cluster-${var.environment}"
  description = "EKS cluster security group."
  tags = merge(
    var.tags,
    {
      Name = "${var.application}-eks-cluster-${var.environment}-eks_cluster_sg"
    }
  )
}

resource "aws_security_group" "eks_workers" {
  vpc_id      = var.vpc_id
  name        = "${var.application}-eks-workers-${var.environment}"
  description = "Security group for all nodes in the cluster."
  tags = merge(
    var.tags,
    {
      Name = "${var.application}-eks-workers-${var.environment}-eks_worker_sg"
    }
  )
}

resource "aws_security_group_rule" "ssh_private_tcp_22" {
  security_group_id        = aws_security_group.ssh_private.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.ssh_public.id
}

resource "aws_security_group_rule" "postgres_tcp_5432" {
  security_group_id        = aws_security_group.postgres.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.eks_workers.id
}

resource "aws_security_group_rule" "docdb_tcp_27017" {
  security_group_id        = aws_security_group.documentdb.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 27017
  to_port                  = 27017
  source_security_group_id = aws_security_group.eks_workers.id
}

resource "aws_security_group_rule" "eks_cluster_https_workers" {
  description              = "Allow pods to communicate with the EKS cluster API."
  security_group_id        = aws_security_group.eks_cluster.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_workers.id
}

resource "aws_security_group_rule" "ssh_private_egress" {
  security_group_id = aws_security_group.ssh_private.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_cluser_egress" {
  security_group_id = aws_security_group.eks_cluster.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_workers_egress" {
  security_group_id = aws_security_group.eks_workers.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "eks_workers_self" {
  security_group_id = aws_security_group.eks_workers.id
  description       = "Allow node to communicate with each other."
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  self              = true
}

resource "aws_security_group_rule" "eks_workers_https_cluster" {
  security_group_id        = aws_security_group.eks_workers.id
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.eks_cluster.id
}

resource "aws_security_group_rule" "eks_workers_cluster_control_plane" {
  security_group_id        = aws_security_group.eks_workers.id
  description              = "Allow workers pods to receive communication from the cluster control plane."
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 1025
  to_port                  = 65535
  source_security_group_id = aws_security_group.eks_cluster.id
}
