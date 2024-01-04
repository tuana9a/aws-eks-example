# setup IAM for the worker node

data "aws_iam_policy_document" "eks_node_role_trust_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# OPTIONAL for cluster autoscaler
resource "aws_iam_policy" "eks_auto_scaler" {
  name        = "EKSAutoScaler"
  path        = "/"
  description = "EKS cluster auto scaler"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeImages",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name               = "EKSNodeRole"
  assume_role_policy = data.aws_iam_policy_document.eks_node_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

# OPTIONAL for cluster autoscaler
resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_4" {
  policy_arn = aws_iam_policy.eks_auto_scaler.arn
  role       = aws_iam_role.eks_node_role.name
}
