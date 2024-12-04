terraform {
  required_providers {
    k3d = {
      source  = "pvotal-tech/k3d"
      version = "0.0.7"
    }
  }
}

provider "k3d" {}

resource "k3d_cluster" "k3dcluster" {
  name    = "k3dcluster"
  servers = 1
  agents  = 2

  k3s {
    extra_args {
      arg          = "--disable=traefik"
      node_filters = ["server:*"]
    }
  }

  kube_api {
    host      = "0.0.0.0"
    host_ip   = "127.0.0.1"
    host_port = 6445
  }

  image   = "rancher/k3s:v1.30.1-k3s1"
  network = "local-k3d-net"

  k3d {
    disable_load_balancer = false
    disable_image_volume  = false
  }

  port {
    host_port      = 80
    container_port = 80
    node_filters = [
      "loadbalancer",
    ]
  }

  port {
    host_port      = 443
    container_port = 443
    node_filters = [
      "loadbalancer",
    ]
  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }
}

output "cluster_name" {
  value = k3d_cluster.k3dcluster.name
}

# output "kubeconfig" {
#   value     = k3d_cluster.k3dcluster.credentials.0.raw
#   sensitive = true
# }
