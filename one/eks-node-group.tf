# WARN: apply AFTER vpc-cni, kube-proxy
# WARN: apply BEFORE coredns
resource "aws_eks_node_group" "one" {
  cluster_name    = aws_eks_cluster.one.name
  node_group_name = "one"
  version         = "1.29"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  capacity_type   = "SPOT"

  instance_types = [
    "t3.medium"
  ]

  subnet_ids = [
    aws_subnet.one_private_a.id,
    aws_subnet.one_private_b.id,
  ]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role.eks_node_role,
    aws_eks_addon.one_vpccni,
    aws_eks_addon.one_kubeproxy,
  ]
}
