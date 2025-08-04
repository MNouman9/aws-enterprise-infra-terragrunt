output "cluster_id" {
  value = aws_eks_cluster.cluster.id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

output "kubernetes_version" {
  description = "The Kubernetes version for the cluster"
  value       = aws_eks_cluster.cluster.version
}
