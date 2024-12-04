# Terraform script to install a K3d cluster locally. 
K3d is a lightweight wrapper to run k3s (Rancher Lab's minimal Kubernetes distribution) in docker. 

## Prerequisites
Before launching the solution please install:
* [terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
* [docker](https://docs.docker.com/desktop/install/linux/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [k3d](https://k3d.io/v5.7.4/#what-is-k3d)


Here's a Terraform configuration to set this up:



```hcl
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
  agents  = 3

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

  k3d {
    disable_load_balancer = false
    disable_image_volume  = false
  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }
}

output "cluster_name" {
  value = k3d_cluster.k3dcluster.name
}

```

This Terraform configuration does the following:

1. Specifies the required provider (k3d) and its version.
2. Creates a K3d cluster named "k3dcluster" with 1 server node and 2 agent nodes.
3. Configures the Kubernetes API server to be accessible on the host machine.
4. Uses a specific K3s image version.
5. Sets up a custom network for the cluster.
6. Configures port forwarding for the load balancer.
7. Enables the load balancer and image volume.
8. Updates the default kubeconfig and switches the current context to the new cluster.
9. Outputs the cluster name and kubeconfig for easy access.

To use this configuration:

1. Save it to a file with a `.tf` extension (e.g., `k3d_cluster.tf`).
2. Run `terraform init` to initialize the Terraform working directory.
3. Run `terraform apply` to create the K3d cluster.

Remember that you need to have Docker and K3d installed on your local machine for this to work. Also, make sure you have Terraform installed.


# Delete cluster
Run `terraform destroy` to delete the K3d cluster.