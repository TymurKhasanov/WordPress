resource "kubernetes_service_account" "dashboard_admin_user" {

  automount_service_account_token = true

  metadata {
    name      = var.dashboard_admin_user_name
    namespace = var.dashboard_namespace
  }

  # secret {
  #   name = var.dashboard_secret_token_name
  # }
}

resource "kubernetes_cluster_role_binding" "dashboard_admin_user" {
  metadata {
    name = var.dashboard_admin_user_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.dashboard_admin_user.metadata[0].name
    namespace = kubernetes_service_account.dashboard_admin_user.metadata[0].namespace
  }
}


resource "kubernetes_secret" "token_secret" {
  metadata {
    name      = var.dashboard_secret_token_name
    namespace = var.dashboard_namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.dashboard_admin_user.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}


# kubectl get secret dashboard-admin-user-token -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 --decode
