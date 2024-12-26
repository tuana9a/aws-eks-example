resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = kubernetes_namespace.cluster_autoscaler.metadata[0].name
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  version    = "9.43.2"

  set {
    name  = "awsRegion"
    value = data.aws_region.current.name
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = data.aws_eks_cluster.one.name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler.arn
  }
}
