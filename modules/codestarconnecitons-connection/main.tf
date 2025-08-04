resource "aws_codestarconnections_connection" "default" {
  name          = "${var.application}-connection-${var.environment}"
  provider_type = "Bitbucket"
  tags          = var.tags
}