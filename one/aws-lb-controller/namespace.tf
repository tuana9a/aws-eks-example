resource "kubernetes_namespace" "aws_lb_controller" {
  metadata {
    name = "aws-lb-controller"
  }
}
