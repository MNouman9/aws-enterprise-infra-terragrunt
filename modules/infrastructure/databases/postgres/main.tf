resource "aws_db_instance" "default" {
  identifier                          = "database-${var.application}-${var.environment}"
  allocated_storage                   = var.allocated_storage
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  username                            = var.username
  password                            = var.password
  storage_encrypted                   = true
  kms_key_id                          = var.key_arn
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.preferred_backup_window
  copy_tags_to_snapshot               = true
  enabled_cloudwatch_logs_exports     = ["postgresql", "upgrade"]
  maintenance_window                  = var.maintenance_window
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = var.skip_final_snapshot
  final_snapshot_identifier           = var.skip_final_snapshot ? null : "${var.application}-postgres-snapshot-${var.environment}-${uuid()}"
  db_subnet_group_name                = aws_db_subnet_group.default.name
  vpc_security_group_ids              = var.securitygroup_ids
  tags                                = var.tags
}

resource "aws_db_instance" "snapshot_restore" {
  count                               = var.create_db_snapshot_restore ? 1 : 0
  identifier                          = "database-snapshotrestore-${var.application}-${var.environment}"
  engine                              = "postgres"
  engine_version                      = "12.14"
  instance_class                      = var.instance_class
  backup_retention_period             = 0
  copy_tags_to_snapshot               = true
  enabled_cloudwatch_logs_exports     = ["postgresql", "upgrade"]
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true
  snapshot_identifier                 = var.snapshot_identifier
  db_subnet_group_name                = aws_db_subnet_group.default.name
  vpc_security_group_ids              = var.securitygroup_ids
  tags                                = var.tags
}

resource "aws_db_subnet_group" "default" {
  name       = "database-subnetgroup-${var.application}-${var.environment}"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}
