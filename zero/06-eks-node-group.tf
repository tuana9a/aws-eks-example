# WARN: apply AFTER vpc-cni, kube-proxy
# WARN: apply BEFORE coredns
resource "aws_eks_node_group" "zero" {
  cluster_name    = aws_eks_cluster.zero.name
  version         = "1.33" # UPDATED 2025
  node_group_name = "zero"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  instance_types  = ["t3.medium"]

  subnet_ids = [
    aws_subnet.zero1.id,
    aws_subnet.zero2.id,
    aws_subnet.zero3.id,
  ]
  capacity_type = "SPOT"

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
  ]
}
