resource "aws_docdb_cluster" "default" {
  cluster_identifier              = "docdb-${var.application}-${var.environment}"
  engine                          = var.engine
  engine_version                  = var.engine_version
  storage_encrypted               = true
  kms_key_id                      = var.key_arn
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  master_username                 = var.username
  master_password                 = var.password
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.maintenance_window
  db_subnet_group_name            = aws_docdb_subnet_group.default.name
  vpc_security_group_ids          = var.securitygroup_ids
  skip_final_snapshot             = var.skip_final_snapshot
  snapshot_identifier             = var.snapshot_identifier
  final_snapshot_identifier       = var.skip_final_snapshot ? null : "${var.application}-docdb-snapshot-${var.environment}-${uuid()}"
  tags                            = var.tags
}

resource "aws_docdb_cluster_instance" "default" {
  identifier         = "docdb-${var.application}-${var.environment}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = var.instance_class
  tags               = var.tags
}

resource "aws_docdb_subnet_group" "default" {
  name       = "docdb-subnetgroup-${var.application}-${var.environment}"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_docdb_cluster" "search" {
  cluster_identifier              = "docdb-${var.application}-${var.environment}-search"
  engine                          = "docdb"
  engine_version                  = var.engine_version
  storage_encrypted               = true
  kms_key_id                      = var.key_arn
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  master_username                 = var.username
  master_password                 = var.password
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.maintenance_window
  db_subnet_group_name            = aws_docdb_subnet_group.search.name
  vpc_security_group_ids          = var.securitygroup_ids
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.skip_final_snapshot ? null : "${var.application}-docdb-snapshot-${var.environment}-search-${uuid()}"
  tags                            = var.tags
}

resource "aws_docdb_cluster_instance" "search" {
  identifier         = "docdb-${var.application}-${var.environment}-search"
  cluster_identifier = aws_docdb_cluster.search.id
  instance_class     = var.instance_class
  tags               = var.tags
}

resource "aws_docdb_subnet_group" "search" {
  name       = "docdb-subnetgroup-${var.application}-${var.environment}-search"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}