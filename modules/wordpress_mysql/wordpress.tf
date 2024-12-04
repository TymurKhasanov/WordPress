# WordPress Deployment
resource "kubernetes_deployment" "wordpress" {
  metadata {
    name      = "wordpress-${var.env}"
    labels    = local.wordpress_labels
    namespace = var.wordpress_namespace
  }
  spec {
    replicas = var.wordpress_replica_count
    selector {
      match_labels = local.wordpress_labels
    }
    template {
      metadata {
        labels = local.wordpress_labels
      }
      spec {
        container {
          image = "wordpress:5.8.2-apache"
          name  = "wordpress"
          port {
            container_port = 80
          }
          env {
            name  = "WORDPRESS_DB_HOST"
            value = kubernetes_service.mysql_service.metadata[0].name
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = var.mysql_user
          }
          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          env {
            name  = "WORDPRESS_DB_NAME"
            value = var.mysql_database
          }
        }
      }
    }
  }
}
