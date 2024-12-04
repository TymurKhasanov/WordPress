resource "kubernetes_ingress_v1" "wordpress" {
  metadata {
    name      = "wordpress-ingress-${var.env}"
    namespace = var.wordpress_namespace
    annotations = {
      "kubernetes.io/ingress.class"                     = "nginx"
      "nginx.ingress.kubernetes.io/affinity"            = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name" = "wp-session"
    }
  }

  spec {
    rule {
      host = "wordpress.local"
      http {
        path {
          backend {
            service {
              name = kubernetes_service.wordpress-service.metadata.0.name
              port {
                number = 80 # Ensure this matches the service port
              }
            }
          }

          path = "/"
        }
      }

    }
  }
}
