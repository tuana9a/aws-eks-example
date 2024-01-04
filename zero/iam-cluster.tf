# setup IAM for the control plane

data "aws_iam_policy_document" "eks_cluster_role_trust_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "EKSClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy_attachment_1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}
