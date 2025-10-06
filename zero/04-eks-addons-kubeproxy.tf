# WARN: apply BEFORE node_group
resource "aws_eks_addon" "zero_kubeproxy" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "kube-proxy"
  addon_version = "v1.33.3-eksbuild.4" # UPDATED 2025
}
