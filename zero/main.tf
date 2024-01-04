resource "aws_eks_cluster" "zero" {
  name     = "zero"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.28"

  vpc_config {
    subnet_ids = [
      aws_subnet.zero_one.id,
      aws_subnet.zero_two.id,
      aws_subnet.zero_three.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_policy_attachment_1,
  ]
}

resource "aws_eks_node_group" "zero" {
  cluster_name    = aws_eks_cluster.zero.name
  node_group_name = "zero"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
    aws_subnet.zero_one.id,
    aws_subnet.zero_two.id,
    aws_subnet.zero_three.id,
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
    aws_iam_role_policy_attachment.eks_node_role_policy_attachment_1,
    aws_iam_role_policy_attachment.eks_node_role_policy_attachment_2,
    aws_iam_role_policy_attachment.eks_node_role_policy_attachment_3,
    aws_iam_role_policy_attachment.eks_node_role_policy_attachment_4, # OPTIONAL for cluster autoscaler
    aws_eks_addon.zero_vpccni,
    aws_eks_addon.zero_kubeproxy,
  ]
}

# OPTIONAL for cluster autoscaler
resource "local_file" "autoscaler-manifest" {
  content  = templatefile("templates/cluster-autoscaler-autodiscover.yaml.tftpl", { cluster_name = aws_eks_cluster.zero.name })
  filename = "cluster-autoscaler-autodiscover.yaml"
}
