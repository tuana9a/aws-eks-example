# WARN: apply BEFORE node_group
resource "aws_eks_addon" "zero_vpccni" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "vpc-cni"
  addon_version = "v1.22.2-eksbuild.1"
}
