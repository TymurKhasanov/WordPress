
# Terraform Kubernetes Infrastructure

This project contains Terraform modules to deploy and manage a Kubernetes cluster with NGINX ingress, Kubernetes dashboard, WordPress, and MySQL, among other components.

### Prerequisites

Before running the project, ensure you have the following:

1. **Terraform Installed**: Download and install Terraform from the official website: [Terraform Install Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).
2. **Kubernetes Cluster**: A running Kubernetes cluster (e.g., GKE, EKS, k3d, etc.). This setup uses the `k3d-k3dcluster` context.
3. **Kubeconfig**: Ensure your Kubernetes configuration file (`~/.kube/config`) is correctly set up to access your cluster.
4. **Helm Installed**: Helm should be installed to manage Kubernetes resources. [Install Helm](https://helm.sh/docs/intro/install/).
5. **Configured Variables**: Ensure the required variables such as MySQL passwords, admin usernames, and tokens are set in the project or via environment variables.

## Modules

### NGINX Ingress
The NGINX Ingress module is responsible for setting up NGINX as an ingress controller for the Kubernetes cluster.

```hcl
module "nginx_ingress" {
  source = "./modules/nginx_ingress" # Path to the module
}
```

### Kubernetes Dashboard
This module sets up the Kubernetes Dashboard with an admin user and secures it using a secret token.

```hcl
module "k8s_dashboard" {
  source                      = "./modules/k8s_dashboard"
  dashboard_admin_user_name   = var.dashboard_admin_user_name
  dashboard_namespace         = var.dashboard_namespace
  dashboard_secret_token_name = var.dashboard_secret_token_name
}
```

- **Admin User Name:** `${var.dashboard_admin_user_name}`
- **Namespace:** `${var.dashboard_namespace}`
- **Secret Token Name:** `${var.dashboard_secret_token_name}`

Get tocken:
```sh
kubectl get secret dashboard-admin-user-token -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 --decode
```

### WordPress and MySQL
The WordPress and MySQL module sets up a WordPress site and its database (MySQL). It allows for customization such as replica counts, domain configuration, and database credentials.

```hcl
module "wordpress_mysql" {
  source = "./modules/wordpress_mysql" # Path to the module
  env    = "dev"

  # WordPress configuration
  wordpress_replica_count = 2                 # Number of WordPress replicas
  wordpress_domain        = "wordpress.local" # Ingress domain for WordPress

  # MySQL configuration
  mysql_root_password = var.mysql_root_password # Root password for MySQL
  mysql_user          = var.mysql_user          # MySQL user for WordPress
  mysql_password      = var.mysql_password      # Password for the MySQL user
  mysql_database      = var.mysql_database      # MySQL database name
  wordpress_namespace = var.wordpress_namespace
}
```

### Required Providers
The infrastructure uses the following providers:

- **Kubernetes Provider:** Used for deploying resources into the Kubernetes cluster.
- **Helm Provider:** Used for managing Helm charts within the cluster.

```hcl
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
}
```

### Kubernetes Provider Configuration
The Kubernetes provider requires a `kubeconfig` file to authenticate and manage the cluster. You can configure the provider by pointing to the appropriate `kubeconfig` file and context.

```hcl
provider "kubernetes" {
  config_path    = "~/.kube/config" # Path to your kubeconfig file
  config_context = "k3d-k3dcluster"
}
```

### Helm Provider Configuration
The Helm provider uses the same `kubeconfig` file to manage Kubernetes resources through Helm charts.

```hcl
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config" # Path to your kubeconfig file
    config_context = "k3d-k3dcluster"
  }
}
```






## Steps to Run
To run this Terraform project, follow the steps below:
1. **Clone the Repository** (if it's hosted on a version control system like GitHub):
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```
   add the following  lines into your /etc/hosts file (for Linux):
   ```sh
    127.0.0.1 dashboard.local
    127.0.0.1 wordpress.local
    127.0.0.1 wordpress.test
    127.0.0.1 wordpress.prod
    127.0.0.1 nginx.local
   ```
   do steps in [`prerequisites`](./prerequisites/README.md) folder.
2. **Initialize Terraform**:
   Run the following command to initialize the Terraform project and download necessary providers:
   ```bash
   terraform init
   ```

3. **Configure Terraform Variables**:
   Before applying the configuration, ensure you have the necessary variables configured. You can either:
   
   - Set up a `terraform.tfvars` file with the required values, or
   - Pass them as command-line arguments when running Terraform.

   Example of `terraform.tfvars`:
   ```hcl
   mysql_root_password = "supersecretrootpassword"
   mysql_user          = "wordpress_user"
   mysql_password      = "supersecretpassword"
   mysql_database      = "wordpress_db"
   wordpress_namespace = "wordpress-dev"
   ```

4. **Validate the Configuration**:
   Ensure the Terraform files and configurations are correct:
   ```bash
   terraform validate
   ```

5. **Preview the Infrastructure Changes**:
   Use the `terraform plan` command to see what infrastructure changes will be made:
   ```bash
   terraform plan
   ```

6. **Apply the Configuration**:
   Once everything is ready, apply the Terraform configuration to deploy the resources:
   ```bash
   terraform apply
   ```

   You will be prompted to confirm the changes by typing `yes`.

7. **Access Kubernetes Dashboard**:
   After deployment, you can access the Kubernetes dashboard using the token generated during the deployment:
   
   - Get the secret token for the admin user:
     ```bash
     kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
     ```
     or
     ```sh
     kubectl get secret dashboard-admin-user-token -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 --decode
     ```

   - Open the dashboard by accessing the following URL in your browser:
     ```
     https://dashboard.local
     ```

8. **Access WordPress**:
   After deployment, access your WordPress installation by navigating to the configured domain (e.g., `wordpress.local`), or by checking the external IP or ingress URL:
   
   ```bash
   kubectl get ingress -n wordpress-dev
   ```

   Look for the ingress configuration.

### Clean Up Resources

When you're done and want to clean up the resources created by this project, run:

```bash
terraform destroy
```

This will remove all resources defined in the Terraform configuration.

### Troubleshooting

- **Kubeconfig issues**: Ensure your `~/.kube/config` file is set up correctly to access the Kubernetes cluster.
- **Helm issues**: Ensure Helm is installed and accessible from your command line.
- **Permissions**: Make sure the Kubernetes cluster allows the necessary permissions to create resources (e.g., RBAC roles might be needed).
