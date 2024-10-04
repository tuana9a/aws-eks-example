resource "kubernetes_service_account" "aws_lb_controller" {
  metadata {
    name      = "aws-lb-controller"
    namespace = kubernetes_namespace.aws_lb_controller.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_lb_controller.arn
    }
  }
}
