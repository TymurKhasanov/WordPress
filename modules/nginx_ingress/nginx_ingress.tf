# NGINX Ingress Controller Helm Chart
resource "kubernetes_namespace" "nginx_ingress_namespace" {
  metadata {
    annotations = {
      name = "ingress-nginx"
    }

    labels = {
      app = "ingress-nginx"
    }

    name = "ingress-nginx"
  }

}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.11.2"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.ports.http"
    value = "80"
  }

  set {
    name  = "controller.service.ports.https"
    value = "443"
  }


  depends_on = [kubernetes_namespace.nginx_ingress_namespace]
}
