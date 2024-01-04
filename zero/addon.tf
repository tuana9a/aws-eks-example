resource "aws_eks_addon" "zero_vpccni" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "vpc-cni"
  addon_version = "v1.14.1-eksbuild.1"

  configuration_values = jsonencode({
    env = {
      # TODO: these configs have interesting story to tell.
      WARM_ENI_TARGET   = "0",
      WARM_IP_TARGET    = "2",
      MINIMUM_IP_TARGET = "2",
    }
  })
}

resource "aws_eks_addon" "zero_kubeproxy" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "kube-proxy"
  addon_version = "v1.28.1-eksbuild.1"
}

resource "aws_eks_addon" "zero_coredns" {
  cluster_name  = aws_eks_cluster.zero.name
  addon_name    = "coredns"
  addon_version = "v1.10.1-eksbuild.2"

  depends_on = [aws_eks_node_group.zero]
}
