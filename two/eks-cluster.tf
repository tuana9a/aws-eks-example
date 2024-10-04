resource "aws_eks_cluster" "two" {
  name     = "two"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.30"

  vpc_config {
    # Error: creating EKS Cluster (two): InvalidParameterException: Subnets specified must be in at least two different AZs
    subnet_ids = [
      aws_subnet.two1.id,
      aws_subnet.two2.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role.eks_cluster_role,
  ]
}
