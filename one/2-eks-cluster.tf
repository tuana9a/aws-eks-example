resource "aws_iam_role" "eks_cluster_role" {
  name = "EKSClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

resource "aws_eks_cluster" "one" {
  name     = "one"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.33" # UPDATED 2025

  vpc_config {
    subnet_ids = [
      aws_subnet.one_private_a.id,
      aws_subnet.one_private_b.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role.eks_cluster_role,
  ]
}