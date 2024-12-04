# Kubernetes Secret for MySQL root password
resource "kubernetes_secret" "mysql_pass" {
  metadata {
    name      = "mysql-pass-${var.env}"
    namespace = var.wordpress_namespace
  }
  data = {
    password = var.mysql_password
  }
}
