resource "aws_iam_policy" "ec2-role-policy" {
  name   = "${var.application}-ec2-access-policy-${var.environment}"
  tags   = var.tags
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "ec2-instance-connect:SendSSHPublicKey",
        "Resource": ${jsonencode(var.ec2_instances)},
        "Condition": {
            "StringEquals": {
                "ec2:osuser": "ami-username"
            }
        }
      },
      {
        "Effect": "Allow",
        "Action": "ec2:DescribeInstances",
        "Resource": "*"
      }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "this" {
  for_each = toset(
    var.iam_user_names
  )
  user       = each.value
  policy_arn = aws_iam_policy.ec2-role-policy.arn
}