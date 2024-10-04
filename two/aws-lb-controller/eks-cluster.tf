data "aws_eks_cluster" "two" {
  name = "two"
}

data "aws_eks_cluster_auth" "two" {
  name = "two"
}