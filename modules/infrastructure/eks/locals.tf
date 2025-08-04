locals {
  configmap_roles = [
    {
      rolearn  = aws_iam_role.eks_node_group_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }
  ]
}
