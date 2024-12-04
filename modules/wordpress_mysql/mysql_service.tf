# MySQL Service
resource "kubernetes_service" "mysql_service" {
  metadata {
    name      = "mysql-service-${var.env}"
    namespace = var.wordpress_namespace
  }
  spec {
    selector = local.mysql_labels
    port {
      port        = 3306
      target_port = 3306
    }
    type = "NodePort"
  }
}
