module "nginx_ingress" {
  source = "./modules/nginx_ingress" # Path to the module
}

module "k8s_dashboard" {
  source                      = "./modules/k8s_dashboard"
  dashboard_admin_user_name   = var.dashboard_admin_user_name
  dashboard_namespace         = var.dashboard_namespace
  dashboard_secret_token_name = var.dashboard_secret_token_name
}


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
