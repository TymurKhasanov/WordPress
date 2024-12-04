
resource "kubernetes_namespace" "wordpress_namespace" {
  metadata {
    name = var.wordpress_namespace
  }
}
