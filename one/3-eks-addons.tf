# WARN: apply BEFORE node_group
resource "aws_eks_addon" "one_vpccni" {
  cluster_name  = aws_eks_cluster.one.name
  addon_name    = "vpc-cni"
  addon_version = "v1.19.5-eksbuild.1" # UPDATED 2025
}

# WARN: apply BEFORE node_group
resource "aws_eks_addon" "one_kubeproxy" {
  cluster_name  = aws_eks_cluster.one.name
  addon_name    = "kube-proxy"
  addon_version = "v1.33.3-eksbuild.4" # UPDATED 2025
}

# WARN: apply AFTER node_group
resource "aws_eks_addon" "one_coredns" {
  cluster_name  = aws_eks_cluster.one.name
  addon_name    = "coredns"
  addon_version = "v1.12.1-eksbuild.2" # UPDATED 2025

  depends_on = [aws_eks_node_group.one]
}
