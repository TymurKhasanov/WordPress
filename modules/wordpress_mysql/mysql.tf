# MySQL Deployment
resource "kubernetes_deployment" "mysql" {
  metadata {
    name      = "mysql-${var.env}"
    labels    = local.mysql_labels
    namespace = var.wordpress_namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.mysql_labels
    }
    template {
      metadata {
        labels = local.mysql_labels
      }
      spec {
        container {
          image = "mysql:8.0.27"
          name  = "mysql"
          port {
            container_port = 3306
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_pass.metadata[0].name
                key  = "password"
              }
            }
          }
          env {
            name  = "MYSQL_DATABASE"
            value = var.mysql_database
          }
          env {
            name  = "MYSQL_USER"
            value = var.mysql_user
          }
          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_pass.metadata[0].name
                key  = "password"
              }
            }
          }
        }
      }
    }
  }
}
