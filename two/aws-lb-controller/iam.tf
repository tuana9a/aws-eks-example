# https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html

resource "aws_iam_policy" "aws_lb_controller" {
  name = "AWSLoadBalancerControllerIAMPolicy"

  # curl https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.9.0/docs/install/iam_policy.json -o iam-policy.json
  policy = file("./iam-policy.json")
}

resource "aws_iam_role" "aws_lb_controller" {
  name                = "AmazonEKSLoadBalancerControllerRole"
  managed_policy_arns = [aws_iam_policy.aws_lb_controller.arn]

  # https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html
  assume_role_policy = templatefile("./iam-trust-policy.json", {
    account_id      = data.aws_caller_identity.current.account_id
    namespace       = kubernetes_namespace.aws_lb_controller.metadata[0].name
    service_account = "aws-lb-controller"
    oidc_provider   = replace(data.aws_eks_cluster.two.identity[0].oidc[0].issuer, "https://", "")
  })
}
