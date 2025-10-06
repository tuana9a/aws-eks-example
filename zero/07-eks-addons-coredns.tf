# WARN: apply AFTER node_group
resource "aws_eks_addon" "zero_coredns" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "coredns"
  addon_version = "v1.12.1-eksbuild.2" # UPDATED 2025
}
