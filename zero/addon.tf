# WARN: apply BEFORE node_group
resource "aws_eks_addon" "zero_vpccni" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "vpc-cni"
  addon_version = "v1.14.1-eksbuild.1"
}

# WARN: apply BEFORE node_group
resource "aws_eks_addon" "zero_kubeproxy" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "kube-proxy"
  addon_version = "v1.28.1-eksbuild.1"
}

# WARN: apply AFTER node_group
resource "aws_eks_addon" "zero_coredns" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "coredns"
  addon_version = "v1.10.1-eksbuild.2"
}
