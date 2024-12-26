data "aws_eks_cluster" "one" {
  name = "one"
}

data "aws_eks_cluster_auth" "one" {
  name = "one"
}