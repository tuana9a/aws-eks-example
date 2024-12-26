resource "kubernetes_namespace" "cluster_autoscaler" {
  metadata {
    name = "cluster-autoscaler"
  }
}
