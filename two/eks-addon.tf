# WARN: apply BEFORE node_group
resource "aws_eks_addon" "two_vpccni" {
  cluster_name  = aws_eks_cluster.two.name
  addon_name    = "vpc-cni"
  addon_version = "v1.18.1-eksbuild.3"
}

# WARN: apply BEFORE node_group
resource "aws_eks_addon" "two_kubeproxy" {
  cluster_name  = aws_eks_cluster.two.name
  addon_name    = "kube-proxy"
  addon_version = "v1.30.0-eksbuild.3"
}

# WARN: apply AFTER node_group
resource "aws_eks_addon" "two_coredns" {
  cluster_name  = aws_eks_cluster.two.name
  addon_name    = "coredns"
  addon_version = "v1.11.1-eksbuild.8"

  depends_on = [aws_eks_node_group.two]
}
