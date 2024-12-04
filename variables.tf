
variable "dashboard_admin_user_name" {
}
variable "dashboard_namespace" {
}

variable "dashboard_secret_token_name" {
}


# variable "k8s_service_account_email" {}
variable "namespace" {
  default = "logging"
}

variable "namespace_fd" {
  default = "kube-system"
}
