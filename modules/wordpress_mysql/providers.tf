# terraform {
#   required_providers {
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = ">= 2.0.0"
#     }
#     helm = {
#       source  = "hashicorp/helm"
#       version = ">= 2.0.0"
#     }
#   }
# }

# provider "kubernetes" {
#   config_path    = "~/.kube/config" # Path to your kubeconfig file
#   config_context = "k3d-k3dcluster"
# }

# provider "helm" {
#   kubernetes {
#     config_path    = "~/.kube/config" # Path to your kubeconfig file
#     config_context = "k3d-k3dcluster"
#   }
# }
