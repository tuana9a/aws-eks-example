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
    aws_iam_role.eks_cluster_role,
  ]
}