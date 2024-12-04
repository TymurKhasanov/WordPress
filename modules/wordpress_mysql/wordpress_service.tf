resource "kubernetes_service" "wordpress-service" {
  metadata {
    name      = "wordpress-service-${var.env}"
    namespace = var.wordpress_namespace
  }
  spec {
    selector = local.wordpress_labels
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
    #type = "LoadBalancer"
    #type = "Ingress"

  }
}
