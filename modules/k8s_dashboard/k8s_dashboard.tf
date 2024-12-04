
resource "kubernetes_namespace" "kubernetes_dashboard" {
  metadata {
    name = var.dashboard_namespace
  }
}

resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  namespace  = kubernetes_namespace.kubernetes_dashboard.metadata[0].name
  version    = "7.6.1"

  set {
    name  = "protocolHttp"
    value = "false"
  }

  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }

  set {
    name  = "metrics-server.enabled"
    value = "false"
  }

  set {
    name  = "kong.enabled"
    value = "true"
  }

  set {
    name  = "nginx.enabled"
    value = "false"
  }

  set {
    name  = "cert-manager.enabled"
    value = "true"
  }
  set {
    name  = "kong.admin.tls.enabled"
    value = "true"
  }
}

resource "kubernetes_service" "dashboard" {
  metadata {
    name      = "kubernetes-dashboard"
    namespace = kubernetes_namespace.kubernetes_dashboard.metadata[0].name
  }
  spec {
    selector = {
      "app.kubernetes.io/component" = "app"
      "app.kubernetes.io/instance"  = "kubernetes-dashboard"
      "app.kubernetes.io/name"      = "kong"

    }
    port {
      port        = 443
      target_port = 8443
    }
    type = "NodePort"
  }
}


resource "kubernetes_ingress_v1" "dashboard_ingress" {
  metadata {
    name      = "dashboard-ingress"
    namespace = kubernetes_namespace.kubernetes_dashboard.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"     = "true"
      "nginx.ingress.kubernetes.io/proxy-body-size"  = "10m"
      "nginx.ingress.kubernetes.io/proxy-buffering"  = "off"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
  }


  spec {
    ingress_class_name = "nginx"
    rule {
      host = "dashboard.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.dashboard.metadata[0].name
              port {
                number = 443
              }
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_service.dashboard]
}

output "dashboard_url" {
  value = "http://dashboard.local"
}
