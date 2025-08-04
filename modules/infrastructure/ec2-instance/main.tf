resource "aws_instance" "instance" {
  ami                         = var.ami
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  monitoring                  = true
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = "1"
  }
  tags = merge(
    var.tags,
    {
      Name = var.server_type
    }
  )
}