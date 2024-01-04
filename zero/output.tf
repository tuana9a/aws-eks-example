output "eks-name" {
  value = aws_eks_cluster.zero.name
}

output "eks-endpoint" {
  value = aws_eks_cluster.zero.endpoint
}

output "update-kubeconfig" {
  value = "aws eks update-kubeconfig --name ${aws_eks_cluster.zero.name}"
}
