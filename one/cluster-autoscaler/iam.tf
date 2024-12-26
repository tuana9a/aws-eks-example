resource "aws_iam_policy" "cluster_autoscaler" {
  name = "EKSClusterAutoscaler"

  # curl https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.9.0/docs/install/iam_policy.json -o ./templates/iam-policy.json
  policy = file("./templates/iam-policy.json")
}

resource "aws_iam_role" "cluster_autoscaler" {
  name                = "EKSClusterAutoscaler"
  managed_policy_arns = [aws_iam_policy.cluster_autoscaler.arn]

  # https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html
  assume_role_policy = templatefile("./templates/iam-trust-policy.json", {
    account_id      = data.aws_caller_identity.current.account_id # IMPORTANT if not then "AccessDenied: Not authorized to perform sts:AssumeRoleWithWebIdentity"
    namespace       = kubernetes_namespace.cluster_autoscaler.metadata[0].name
    service_account = "cluster-autoscaler-aws-cluster-autoscaler" # NOTE: I applied the terraform and kubectl get serviceaccount to detect its name :V
    oidc_provider   = replace(data.aws_eks_cluster.one.identity[0].oidc[0].issuer, "https://", "")
  })
}
