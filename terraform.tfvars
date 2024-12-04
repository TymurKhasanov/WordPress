# DASHBOARD
dashboard_admin_user_name   = "dashboard-admin-user"
dashboard_namespace         = "kubernetes-dashboard"
dashboard_secret_token_name = "dashboard-admin-user-token"


# WordPress configuration
wordpress_replica_count = 2                 # Number of WordPress replicas
wordpress_domain        = "wordpress.local" # Ingress domain for WordPress

# MySQL configuration
mysql_root_password = "supersecretrootpassword" # Root password for MySQL
mysql_user          = "wordpress_user"          # MySQL user for WordPress
mysql_password      = "supersecretpassword"     # Password for the MySQL user
mysql_database      = "wordpress_db"            # MySQL database name
wordpress_namespace = "wordpress-dev"           # Namespace


