locals {
  wordpress_labels = {
    App  = "wordpress"
    Tier = "frontend"
  }
  mysql_labels = {
    App  = "wordpress"
    Tier = "mysql"
  }
}